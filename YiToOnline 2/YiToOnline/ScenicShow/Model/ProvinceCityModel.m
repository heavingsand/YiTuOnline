//
//  ProvinceCityModel.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/8.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ProvinceCityModel.h"
//
@implementation ProvinceCityModel
@end
//
@implementation ResultModel
+ (NSDictionary *)objClassInArray {
    return @{@"ProvincesArray" : [ProvincesArrayModdel class ]};
}
@end
//
@implementation ProvincesArrayModdel
@end
//
@implementation CityModel
+ (NSDictionary *)objClassInArray {
    return @{@"cityDetail" : [CityDetailModel class]};
}

@end
//
@implementation CityDetailModel
@end
