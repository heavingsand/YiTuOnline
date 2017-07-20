//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "HelpAnnotationView.h"
#import "CustomCalloutView.h"
#import "HelpSocketManager.h"
#import "SocketManager.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <UIImageView+WebCache.h>

#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface HelpAnnotationView ()
@property (nonatomic, strong) UIImageView *headImage;
@end

@implementation HelpAnnotationView

//@synthesize calloutView;

#pragma mark - Handle Action

- (void)btnAction1:(UIButton *)sender
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=2",@"YiToOnline", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude,@"我的位置", coorinate.latitude, coorinate.longitude, @"游客位置"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

}

- (void)btnAction2:(UIButton *)sender
{
    if (!self.isHandle) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"numberid"] = self.baseModel.ID;
        params[@"headportrait"] = [SocketManager sharedSocket].baseModel.headImg;
        params[@"acceptTime"] = [Common formatWithDate];
        [[HelpSocketManager sharedSocket] sendMessageWithData:params];
    }
    if(self.addSOSBtnBlock){
        self.addSOSBtnBlock();
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
        if (self.calloutView == nil)
        {
            /* 工作人员信息 */
            if (self.baseModel.isStaff) {
                self.calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
                self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                      -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
                self.calloutView.backgroundColor = kColorWhite;

                UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
                titlelab.text = @"受理人信息";
                titlelab.textAlignment = NSTextAlignmentCenter;
                titlelab.textColor = kColorMajor;
                [self.calloutView addSubview:titlelab];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 280, 1)];
                lineView.backgroundColor  = kColorBg;
                [self.calloutView addSubview:lineView];
                
                UIImageView *imageView = self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 70, 70)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.baseModel.imageName]];
                imageView.contentMode = UIViewContentModeCenter;
                imageView.layer.cornerRadius = 35;
                imageView.clipsToBounds = YES;
                [self.calloutView addSubview:imageView];
                //为图片添加手势控制
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBackgroudImage)]];
                imageView.userInteractionEnabled = YES;
                
                
                UILabel *nickNameLab = [self addLableWithFrame:CGRectMake(imageView.right + 2, 60, 0, 20) andText:@"员工姓名 : "];
                [self.calloutView addSubview:nickNameLab];
                UILabel *nickNameLab2 = [self addLableWithFrame2:CGRectMake(nickNameLab.right, 60, 190 - nickNameLab.width, 20) andText:self.baseModel.nickName];
                [self.calloutView addSubview:nickNameLab2];
                
                UILabel *phoneLab = [self addLableWithFrame:CGRectMake(imageView.right + 2, 80, 0, 20) andText:@"电话号码 : "];
                [self.calloutView addSubview:phoneLab];
                UILabel *phoneLab2 = [self addLableWithFrame2:CGRectMake(phoneLab.right, 80, 190 - phoneLab.width, 20) andText:self.baseModel.phoneNumber];
                [self.calloutView addSubview:phoneLab2];
                
                UILabel *timelab = [self addLableWithFrame:CGRectMake(imageView.right + 2, 100, 0, 20) andText:@"受理时间 : "];
                [self.calloutView addSubview:timelab];
                UILabel *timelab2 = [self addLableWithFrame2:CGRectMake(timelab.right, 100, 190 - timelab.width, 20) andText:self.baseModel.time];
                [self.calloutView addSubview:timelab2];
                
                UILabel *distancelab = [self addLableWithFrame:CGRectMake(imageView.right + 2, 120, 0, 20) andText:@"距离 : "];
                [self.calloutView addSubview:distancelab];
                UILabel *distancelab2 = [self addLableWithFrame2:CGRectMake(distancelab.right, 120, 190 - distancelab.width, 20) andText:[NSString stringWithFormat:@"%ld米",(long)[self howDistance]]];
                [self.calloutView addSubview:distancelab2];
                
            }
            /* 游客信息 */
            else {
                self.calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 140)];
                self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                      -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
                self.calloutView.backgroundColor = kColorWhite;
                
                UIImageView *imageView = self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.baseModel.imageName]];
                imageView.contentMode = UIViewContentModeCenter;
                imageView.layer.cornerRadius = 35;
                imageView.clipsToBounds = YES;
                [self.calloutView addSubview:imageView];
                //为图片添加手势控制
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBackgroudImage)]];
                imageView.userInteractionEnabled = YES;
                
                
                UILabel *nickNameLab = [self addLableWithFrame:CGRectMake(imageView.right + 2, 10, 0, 20) andText:@"游客昵称 : "];
                [self.calloutView addSubview:nickNameLab];
                UILabel *nickNameLab2 = [self addLableWithFrame2:CGRectMake(nickNameLab.right, 10, 190 - nickNameLab.width, 20) andText:self.baseModel.nickName];
                [self.calloutView addSubview:nickNameLab2];
                
                UILabel *phoneLab = [self addLableWithFrame:CGRectMake(imageView.right + 2, 30, 0, 20) andText:@"电话号码 : "];
                [self.calloutView addSubview:phoneLab];
                UILabel *phoneLab2 = [self addLableWithFrame2:CGRectMake(phoneLab.right, 30, 190 - phoneLab.width, 20) andText:self.baseModel.phoneNumber];
                [self.calloutView addSubview:phoneLab2];
                
                UILabel *timelab = [self addLableWithFrame:CGRectMake(imageView.right + 2, 50, 0, 20) andText:@"求助时间 : "];
                [self.calloutView addSubview:timelab];
                UILabel *timelab2 = [self addLableWithFrame2:CGRectMake(timelab.right, 50, 190 - timelab.width, 20) andText:self.baseModel.time];
                [self.calloutView addSubview:timelab2];
                
                UILabel *distancelab = [self addLableWithFrame:CGRectMake(imageView.right + 2, 70, 0, 20) andText:@"距离 : "];
                [self.calloutView addSubview:distancelab];
                UILabel *distancelab2 = [self addLableWithFrame2:CGRectMake(distancelab.right, 70, 190 - distancelab.width, 20) andText:[NSString stringWithFormat:@"%ld米",(long)[self howDistance]]];
                [self.calloutView addSubview:distancelab2];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, 280, 1)];
                lineView.backgroundColor  = kColorBg;
                [self.calloutView addSubview:lineView];
                
                UIButton *gotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 140, 40)];
                [gotoBtn setTitle:@"到这去" forState:UIControlStateNormal];
                [gotoBtn setTitleColor:kColorMajor forState:UIControlStateNormal];
                gotoBtn.backgroundColor = kColorWhite;
                [self.calloutView addSubview:gotoBtn];
                [gotoBtn addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 100, 140, 40)];
                [helpBtn setTitle:@"一键处理" forState:UIControlStateNormal];
                [helpBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
                helpBtn.backgroundColor = RGBColor(248, 117, 69);
                [self.calloutView addSubview:helpBtn];
                [helpBtn addTarget:self action:@selector(btnAction2:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
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
#pragma mark - Method

- (UILabel *)addLableWithFrame:(CGRect)frame andText:(NSString *)text {
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = kColorMajor;
    lable.font = [UIFont systemFontOfSize:13];
    [lable sizeToFit];
    return lable;
}

- (UILabel *)addLableWithFrame2:(CGRect)frame andText:(NSString *)text {
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = RGBColor(248, 117, 69);
    lable.font = [UIFont systemFontOfSize:13];
    lable.adjustsFontSizeToFitWidth = YES;
    [lable sizeToFit];
    return lable;
}

- (CLLocationDistance)howDistance {
    CLLocationCoordinate2D loc1 = self.userLocation.coordinate;
    CLLocationCoordinate2D loc2 = [self.annotation coordinate];
    
    MAMapPoint p1 = MAMapPointForCoordinate(loc1);
    MAMapPoint p2 = MAMapPointForCoordinate(loc2);
    
    CLLocationDistance distance =  MAMetersBetweenMapPoints(p1, p2);
    return distance;
}

//头像放大
- (void)settingBackgroudImage {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    
    if (self.headImage.image) {
        photo.image = self.headImage.image;
    }else{
        photo.url = [NSURL URLWithString:[SocketManager sharedSocket].baseModel.headImg]; // 图片路径
    }
    photo.srcImageView = self.headImage; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
    }
    
    return self;
}
#pragma mark - Lazy Load 
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
@end
