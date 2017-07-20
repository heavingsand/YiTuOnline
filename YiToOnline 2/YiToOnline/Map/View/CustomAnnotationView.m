//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import "MapViewController.h"
#import "AVPlayerManager.h"


#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

#define kMusic @"http://www.yituinfo.cn/Travel/music/jd8y.mp3"

@interface CustomAnnotationView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isPlayer;

@end

@implementation CustomAnnotationView

//@synthesize calloutView;


#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=2",@"YiToOnline", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude,@"我的位置", coorinate.latitude, coorinate.longitude, self.poi.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)playerBtnClick:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        [[AVPlayerManager shareManager] avPlayerPause];
        //关闭定时器
        [self.timer setFireDate:[NSDate distantFuture]];
    } else {
        sender.selected = YES;
        [[AVPlayerManager shareManager] avPlayerPlay];
        //开启定时器
        [self.timer setFireDate:[NSDate distantPast]];
    }
}
#pragma mark - Override


- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.isChangeMusicurl && self.calloutView != nil) {
            [self changeMusic];
        }
        if (self.calloutView == nil)
        {
            self.isPlayer = NO;
            /* 语音播报 */
            [[AVPlayerManager shareManager] setAVPlayerUrl:self.music.musicurl];
            [[AVPlayerManager shareManager] avPlayerPlay];
            CMTime duration = [AVPlayerManager shareManager].player.currentItem.asset.duration;
            float seconds = CMTimeGetSeconds(duration);
            NSLog(@"duration: %.2f", seconds);
            
            /* Construct custom callout. */
            
            if (self.isGuide) {
                self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
            }else {
                self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
            }
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            //标题
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 45)];
            lable.text = self.baseModel.attractionsname;
            lable.backgroundColor = kColorWhite;
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = kColorMajor;
            lable.font = [UIFont systemFontOfSize:18];
            lable.layer.cornerRadius = 6;
            lable.clipsToBounds = YES;
            [self.calloutView addSubview:lable];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, lable.bottom - 4, 240, 4)];
            view.backgroundColor = kColorWhite;
            [self.calloutView addSubview:view];
            
            if (self.isGuide) {
                //图片和介绍
                UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 240, 120)];
                view2.backgroundColor = kColorWhite;
                [self.calloutView addSubview:view2];
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 1)];
                lineView.backgroundColor = kColorLine;
                [view2 addSubview:lineView];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 80, 80)];
                imageView.image = [UIImage imageNamed:@"cm2_default_cover_play"];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [view2 addSubview:imageView];
                
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(imageView.right + 10, 10, 130, 100)];
                scrollView.delegate = self;
                scrollView.bounces = NO;
                scrollView.indicatorStyle =UIScrollViewIndicatorStyleWhite;
                UILabel *introduceLab = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, scrollView.width, 50)];
                introduceLab.text = self.baseModel.introduce;
                introduceLab.numberOfLines = 0;
//                introduceLab.text = @"答语令悬赏状态结束后，该答者进入“创作中”状态。答者进行问令的回答创作。答者回答问令后，可以获得该问令附加的答值。问令中第1名为“必答”问令，答者回答该问令后，将获得该问令悬赏的等额答值。如若答者不进行回答则会扣除该问令悬赏的等额答值。第2名及以后的问令答者可以选择回答，回答后则可得到与悬赏等额的答值，不回答不扣答值。";
                introduceLab.textColor = kColorMajor;
                introduceLab.font = [UIFont systemFontOfSize:13];
                [introduceLab sizeToFit];
                [scrollView addSubview:introduceLab];
                scrollView.contentSize = CGSizeMake(introduceLab.width, introduceLab.height);
                [view2 addSubview:scrollView];
                
                //播放部分
                UIButton *playerBtn =self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, view2.bottom + 1.5, 40, 40)];
                [playerBtn setImage:[UIImage imageNamed:@"playerBtn"] forState:UIControlStateNormal];
                [playerBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
                playerBtn.selected = YES;
                [playerBtn addTarget:self action:@selector(playerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.calloutView addSubview:playerBtn];
                
                UISlider *slider = self.MySlider = [[UISlider alloc] initWithFrame:CGRectMake(playerBtn.right + 10, view2.bottom + 16, 170, 10)];
                [slider setThumbImage:[UIImage imageNamed:@"playerPoint"] forState:UIControlStateNormal];
                slider.maximumTrackTintColor = [UIColor colorWithRed:239 green:239 blue:239 alpha:0.5];
                slider.minimumTrackTintColor = kColorWhite;
                slider.userInteractionEnabled = NO;
                [self.calloutView addSubview:slider];
                if (self.music.musicurl == nil) {
                    slider.maximumValue = 1;
                }else {
                    slider.maximumValue = seconds;
                    if ([AVPlayerManager shareManager].player.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
                            slider.value += 1.0;
                            if (slider.value == slider.maximumValue) {
                                [self.timer invalidate];
                                self.timer = nil;
                                self.isPlayer = YES;
                            }
                        } repeats:YES];
                        
                    }
                }
            }
            //距离和去哪
            UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
            CLLocationCoordinate2D loc1 = self.userLocation.coordinate;
            CLLocationCoordinate2D loc2 = [self.annotation coordinate];
            
            MAMapPoint p1 = MAMapPointForCoordinate(loc1);
            MAMapPoint p2 = MAMapPointForCoordinate(loc2);
            
            CLLocationDistance distance =  MAMetersBetweenMapPoints(p1, p2);
            lable2.text = [NSString stringWithFormat:@"距离 : %ld米", (long)distance];
            lable2.textColor = kColorWhite;
            lable2.font = [UIFont systemFontOfSize:14];
            [self.calloutView addSubview:lable2];
            [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.calloutView.bottom).offset(-16);
                make.left.mas_equalTo(self.calloutView.left).offset(10);
            }];
            
            UIImage *image = [[UIImage imageNamed:@"goto"] imageWithRenderingMode : UIImageRenderingModeAlwaysOriginal];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeTile];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateHighlighted];
            [self.calloutView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.calloutView.bottom).offset(-15);
                make.right.mas_equalTo(self.calloutView.right).offset(-10);
            }];
            [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        //切换语种后这里的路径要重新赋值
        if (self.isPlayer) {
            /* 重新播放 */
            self.MySlider.value = 0;
            [[AVPlayerManager shareManager].player seekToTime:CMTimeMake(0, 1)];
            [[AVPlayerManager shareManager] avPlayerPlay];
            self.isPlayer = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
                self.MySlider.value += 1.0;
                if (self.MySlider.value == self.MySlider.maximumValue) {
                    [self.timer invalidate];
                    self.timer = nil;
                    self.isPlayer = YES;
                }
            } repeats:YES];
            
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

//点击不同标注后切换播放源
- (void)changeMusic {
    [[AVPlayerManager shareManager] setAVPlayerUrl:self.music.musicurl];
    [[AVPlayerManager shareManager] avPlayerPlay];
    self.MySlider.value = 0;
    self.isPlayer = NO;
    
    CMTime duration = [AVPlayerManager shareManager].player.currentItem.asset.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    [self.timer invalidate];
    self.timer = nil;
    
    if (self.music.musicurl == nil) {
        self.MySlider.maximumValue = 1;
    }else {
        self.MySlider.maximumValue = seconds;
        if ([AVPlayerManager shareManager].player.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
                self.MySlider.value += 1.0;
                if (self.MySlider.value == seconds) {
                    [self.timer invalidate];
                    self.timer = nil;
                    self.isPlayer = YES;
                }
            } repeats:YES];
            
        }
    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}


#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
//        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
//        self.backgroundColor = [UIColor grayColor];
        
        self.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
        
     }
    
    return self;
}
#pragma mark - Lazy Load
- (AMapPOI *)poi {
    if (!_poi) {
        _poi = [[AMapPOI alloc ]init];
    }
    return _poi;
}

- (CLLocation *)userLocation {
    if (!_userLocation) {
        _userLocation = [[CLLocation alloc ]init];
    }
    return _userLocation;
}

- (AnnotationBaseModel *)baseModel {
    if (!_baseModel) {
        _baseModel = [[AnnotationBaseModel alloc] init];
    }
    return _baseModel;
}

- (MusicModel *)music {
    if (!_music) {
        _music = [[MusicModel alloc] init];
    }
    return _music;
}
@end
