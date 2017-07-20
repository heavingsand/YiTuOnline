//
//  YiTuBaseModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/2.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface YiTuBaseModel : NSObject
@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *isstaff;
@property(nonatomic, copy) NSString *headportrait;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *channelid;
@property (nonatomic, copy) NSString *phonenumber;
@property (nonatomic, copy) NSString *scenicspotsid;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *name;//昵称
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *travelmodes; //旅游方式
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *adCode;//区域编码
@end
