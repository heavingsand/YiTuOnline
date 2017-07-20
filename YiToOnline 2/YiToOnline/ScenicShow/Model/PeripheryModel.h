//
//  PeripheryModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/28.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@class ScenicspotRimModel,ScenicspotRimAdvertisingModel;

@interface PeripheryModel : NSObject
@property (nonatomic, strong) NSArray<ScenicspotRimModel *> *ScenicspotRim;
@property (nonatomic, strong) NSArray<ScenicspotRimAdvertisingModel *> *ScenicspotRimAdvertising;
@end

@interface ScenicspotRimModel : NSObject
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger scenicspotRimId;
@property (nonatomic, copy) NSString *scenicspotRimName;
@property (nonatomic, copy) NSString *scenicspotRimPicture;
@property (nonatomic, copy) NSString *scenicspotRimType;
@property (nonatomic, assign) NSInteger scenicspotRimTypeId;
@property (nonatomic, assign) NSInteger scenicspotsid;
@property (nonatomic, assign) NSInteger starLove;
@end

@interface ScenicspotRimAdvertisingModel : NSObject
@property (nonatomic, assign) NSInteger scenicspotRimAdvertisingId;
@property (nonatomic, copy) NSString *scenicspotRimAdvertisingImg;

@end
