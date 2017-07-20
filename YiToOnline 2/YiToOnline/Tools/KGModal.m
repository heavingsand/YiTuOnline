//
//  KGModal.m
//  KGModal
//
//  Created by David Keegan on 10/5/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "KGModal.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const kFadeInAnimationDuration = 0.3;
CGFloat const kTransformPart1AnimationDuration = 0.2;
CGFloat const kTransformPart2AnimationDuration = 0.1;
NSString *const KGModalGradientViewTapped = @"KGModalGradientViewTapped";

@interface KGModalGradientView : UIView
@end

@interface KGModalContainerView : UIView
- (id)initPlayWayWithFrame:(CGRect)frame;
@end

@interface KGModalCloseButton : UIButton
@end

@interface KGModalViewController : UIViewController
@property (strong, nonatomic) KGModalGradientView *styleView;
@end

@interface KGModal()
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KGModalViewController *viewController;
@property (strong, nonatomic) KGModalContainerView *containerView;
@property (strong, nonatomic) KGModalCloseButton *closeButton;
@property (strong, nonatomic) UIView *contentView;
@end

@implementation KGModal

+ (id)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(!(self = [super init])){
        return nil;
    }
    
    self.tapOutsideToDismiss = YES;
    self.animateWhenDismissed = YES;
    self.showCloseButton = YES;

    return self;
}

- (void)setShowCloseButton:(BOOL)showCloseButton{
    if(_showCloseButton != showCloseButton){
        _showCloseButton = showCloseButton;
        [self.closeButton setHidden:!self.showCloseButton];
    }
}

- (void)showWithContentView:(UIView *)contentView{
    [self showWithContentView:contentView andAnimated:YES];
}

#pragma mark 普通弹出view 例如：电话
- (void)showWithContentView:(UIView *)contentView andAnimated:(BOOL)animated{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;

    KGModalViewController *viewController = self.viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;

    CGFloat padding = 17;
    CGRect containerViewRect = CGRectInset(contentView.bounds, -padding, -padding);
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = self.window.bounds.size.width - contentView.bounds.size.width - 30;
//    round(CGRectGetMidX(self.window.bounds)-CGRectGetMidX(containerViewRect));
    containerViewRect.origin.y =  self.window.bounds.size.height - contentView.bounds.size.height - 80;
//    round(CGRectGetMidY(self.window.bounds)-CGRectGetMidY(containerViewRect));
    KGModalContainerView *containerView = self.containerView = [[KGModalContainerView alloc] initWithFrame:containerViewRect];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){padding, padding, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];

    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window setHidden:NO];
        _showPicker = NO;
        if(animated){
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];

            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                }];
            }];
        }
    });
}

#pragma mark Picker弹出view 例如：机选红球
- (void)showPickerWithContentView:(UIView *)contentView andAnimated:(BOOL)animated{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    
    KGModalViewController *viewController = self.viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    
    CGFloat padding = 0;
    CGRect containerViewRect = CGRectInset(contentView.bounds, -padding, -padding);
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = round(CGRectGetMidX(self.window.bounds)-CGRectGetMidX(containerViewRect));
    containerViewRect.origin.y = round(CGRectGetMidY(self.window.bounds)-CGRectGetMidY(containerViewRect));
    KGModalContainerView *containerView = self.containerView = [[KGModalContainerView alloc] initWithFrame:containerViewRect];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){padding, padding, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    
    KGModalCloseButton *closeButton = self.closeButton = [[KGModalCloseButton alloc] init];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setHidden:!self.showCloseButton];
    [containerView addSubview:closeButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];
    
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window setHidden:NO];
        
        _showPicker = YES;
        if(animated){
            viewController.styleView.alpha = 0;
            containerView.alpha = 1;
            containerView.frame = (CGRect){0, CGRectGetHeight(self.window.bounds)-20, contentView.bounds.size};
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
                containerView.frame = (CGRect){0, round(CGRectGetHeight(self.window.bounds)-CGRectGetHeight(containerViewRect)), contentView.bounds.size};
            }];
        }
    });
}

#pragma mark 竟足、竞篮 选择时使用
- (void)showPlayWayWithView:(UIView *)contentView OffsetY:(CGFloat)offsetY
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    
    KGModalViewController *viewController = self.viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    
    CGFloat padding = 0;
    CGRect containerViewRect = CGRectInset(contentView.bounds, -padding, -padding);
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = round(CGRectGetMidX(self.window.bounds)-CGRectGetMidX(containerViewRect));;
    containerViewRect.origin.y = offsetY;
    // 当offsetY为0时，自动坐标为中间
    if (offsetY == 0) {
        containerViewRect.origin.y = round(CGRectGetMidY(self.window.bounds)-CGRectGetMidY(containerViewRect));
    }
    KGModalContainerView *containerView = self.containerView = [[KGModalContainerView alloc] initPlayWayWithFrame:containerViewRect];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){padding, padding, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    
    KGModalCloseButton *closeButton = self.closeButton = [[KGModalCloseButton alloc] init];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setHidden:!self.showCloseButton];
    [containerView addSubview:closeButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];
    
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window setHidden:NO];
        _showPicker = NO;
        viewController.styleView.alpha = 0;
        [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
            viewController.styleView.alpha = 1;
        }];
        
        containerView.alpha = 0;
        containerView.layer.shouldRasterize = YES;
        containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
        [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
            containerView.alpha = 1;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            } completion:^(BOOL finished2) {
                containerView.layer.shouldRasterize = NO;
            }];
        }];
    });
}
#pragma mark 玩法弹出view 例如：11选5中选择玩法
- (void)showPlayWayWithView:(UIView *)contentView{
    [self showPlayWayWithView:contentView OffsetY:60];
}

- (void)closeAction:(id)sender{
    [self hideAnimated:self.animateWhenDismissed];
}

- (void)tapCloseAction:(id)sender{
    if(self.tapOutsideToDismiss){
        [self hideAnimated:self.animateWhenDismissed];
    }
}

- (void)hide{
    [self hideAnimated:YES];
}
- (void)hidePicker{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
            self.viewController.styleView.alpha = 0;
            self.containerView.frame = (CGRect){0, CGRectGetHeight(self.window.bounds), self.containerView.frame.size};
        } completion:^(BOOL finished) {
            [self cleanup];
        }];
    });
}
- (void)hideAnimated:(BOOL)animated{
    if(!animated){
        [self cleanup];
        return;
    }
    if (_showPicker) {
        [self hidePicker];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
            self.viewController.styleView.alpha = 0;
        }];

        self.containerView.layer.shouldRasterize = YES;
        [UIView animateWithDuration:kTransformPart2AnimationDuration animations:^{
            self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:kTransformPart1AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                self.containerView.alpha = 0;
                self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            } completion:^(BOOL finished2){
                [self cleanup];
            }];
        }];
    });
}

- (void)cleanup{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.containerView removeFromSuperview];
    [self.window removeFromSuperview];
    self.window = nil;
}

@end

@implementation KGModalViewController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    KGModalGradientView *styleView = self.styleView = [[KGModalGradientView alloc] initWithFrame:self.view.bounds];
    styleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    styleView.opaque = NO;
    [self.view addSubview:styleView];
}

@end

@implementation KGModalContainerView

- (id)initWithFrame:(CGRect)frame{
    if(!(self = [super initWithFrame:frame])){
        return nil;
    }

    CALayer *styleLayer = [[CALayer alloc] init];
//    styleLayer.cornerRadius = 20;
//    styleLayer.shadowColor= [[UIColor blackColor] CGColor];
//    styleLayer.shadowOffset = CGSizeMake(0, 0);
//    styleLayer.shadowOpacity = 0.5;
//    styleLayer.borderWidth = 1;
//    styleLayer.borderColor = [[UIColor whiteColor] CGColor];
//    styleLayer.backgroundColor = [[UIColor colorWithWhite:0 alpha:0.55] CGColor];
//    styleLayer.frame = CGRectInset(self.bounds, 12, 12);
    [self.layer addSublayer:styleLayer];
    
    return self;
}

- (id)initPlayWayWithFrame:(CGRect)frame{
    if(!(self = [super initWithFrame:frame])){
        return nil;
    }
    
    CALayer *styleLayer = [[CALayer alloc] init];
    styleLayer.cornerRadius = 0;
//    styleLayer.shadowColor= [[UIColor blackColor] CGColor];
//    styleLayer.shadowOffset = CGSizeMake(0, 0);
//    styleLayer.shadowOpacity = 0.5;
//    styleLayer.borderWidth = 0;
//    styleLayer.borderColor = [[UIColor whiteColor] CGColor];
//    styleLayer.backgroundColor = [[UIColor colorWithRed:50/255. green:102/255. blue:153/255. alpha:.80] CGColor];
    styleLayer.frame = CGRectInset(self.bounds, 0, 0);
    [self.layer addSublayer:styleLayer];
    
    return self;
}

@end

@implementation KGModalGradientView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalGradientViewTapped object:nil];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if([[KGModal sharedInstance] backgroundDisplayStyle] == KGModalBackgroundDisplayStyleSolid){
        [[UIColor colorWithWhite:0 alpha:0.55] set];
        CGContextFillRect(context, self.bounds);
    }else{
        CGContextSaveGState(context);
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace), colorSpace = NULL;
        CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
        CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
    }
}

@end

@implementation KGModalCloseButton

- (id)init{
    if(!(self = [super initWithFrame:(CGRect){0, 0, 32, 32}])){
        return nil;
    }
    static UIImage *closeButtonImage;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        closeButtonImage = [self closeButtonImage];
    });
    [self setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    return self;
}

- (UIImage *)closeButtonImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor *topGradient = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:0.9];
    UIColor *bottomGradient = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.9];

    //// Gradient Declarations
    NSArray *gradientColors = @[(id)topGradient.CGColor,
    (id)bottomGradient.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);

    //// Shadow Declarations
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 3;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(0, 1);
    CGFloat shadow2BlurRadius = 0;


    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 3, 24, 24)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 3), CGPointMake(16, 27), 0);
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    CGContextRestoreGState(context);


    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(18.83, 15)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(16, 17.83)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(13.17, 15)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(16, 12.17)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);


    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
