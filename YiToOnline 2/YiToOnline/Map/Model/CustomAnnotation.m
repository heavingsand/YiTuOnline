//
//  CustomAnnotation.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/24.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
- (instancetype)init {
    if (self = [super init]) {
        _baseModel = [[AnnotationBaseModel alloc] init];
    }
    return self;
}

- (id)initWithPOI:(AMapPOI *)poi {
    if (self = [super init])
    {
        self.poi = poi;
    }
    return self;
}
@end
