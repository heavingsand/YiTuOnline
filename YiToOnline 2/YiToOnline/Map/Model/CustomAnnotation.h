//
//  CustomAnnotation.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/24.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "AnnotationBaseModel.h"
#import <AMapSearchKit/AMapCommonObj.h>

@interface CustomAnnotation : MAPointAnnotation
@property (nonatomic, copy) NSString *customAdrress;
@property (nonatomic, strong) AnnotationBaseModel *baseModel;
@property (nonatomic, assign) BOOL isGuide;
@property (nonatomic, strong) AMapPOI *poi;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL isHelp;

- (id)initWithPOI:(AMapPOI *)poi;


@end
