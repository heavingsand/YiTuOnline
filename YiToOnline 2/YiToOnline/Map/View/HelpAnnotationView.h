//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "AnnotationBaseModel.h"

@interface HelpAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) AnnotationBaseModel *baseModel;
@property (nonatomic, copy) void (^addSOSBtnBlock)();
@property (nonatomic, assign) BOOL isHandle;
@end
