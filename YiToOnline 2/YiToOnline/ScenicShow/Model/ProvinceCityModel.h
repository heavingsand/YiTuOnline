//
//  ProvinceCityModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/8.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@class ResultModel, ProvincesArrayModdel, CityModel, CityDetailModel;

@interface ProvinceCityModel : NSObject
@property(nonatomic, copy) NSString *resultnumber;
@property(nonatomic, strong) ResultModel *result;
@end

@interface ResultModel : NSObject
@property(nonatomic, strong) NSArray<ProvincesArrayModdel *> *ProvincesArray;
@property(nonatomic, strong) CityModel *cityDic;
@end

@interface ProvincesArrayModdel : NSObject
@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *provinceid;
@end

@interface CityModel : NSObject
@property(nonatomic, strong) NSArray<CityDetailModel *> *cityDetail;
@end

@interface CityDetailModel : NSObject
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *cityid;
@end
