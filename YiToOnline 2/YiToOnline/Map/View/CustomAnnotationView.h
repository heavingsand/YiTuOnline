//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "POIAnnotation.h"
#import "AnnotationBaseModel.h"
@import AVFoundation;

@interface CustomAnnotationView : MAAnnotationView


@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, strong) AMapPOI *poi;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, assign) BOOL isGuide;
@property (nonatomic, strong) AnnotationBaseModel *baseModel;
@property (nonatomic, strong) MusicModel *music;
@property (nonatomic, strong) UISlider *MySlider;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, assign) BOOL isChangeMusicurl;//是否改变音乐路径

//点击不同标注后切换播放源
- (void)changeMusic;

@end
