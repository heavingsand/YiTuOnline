//
//  ScenicIntroModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/22.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenicIntroModel : NSObject
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *synopsis;
@property (nonatomic, copy) NSString *scenicspotname;
@property (nonatomic, copy) NSString *link;//景区链接
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *starlevel;
@property (nonatomic, copy) NSString *scenicspotsPhone;
@property (nonatomic, copy) NSString *img;//景区大图
@property (nonatomic, copy) NSString *gailantu;
@property (nonatomic, copy) NSString *vr;
@property (nonatomic, copy) NSString *daolanpngurl;//景区导览图
@property (nonatomic, assign) NSInteger cityid;
@property (nonatomic, assign) NSInteger scenicspotid;
@property (nonatomic, copy) NSString *scenicspotsAddress;
@property (nonatomic, copy) NSString *voice;
@property (nonatomic, copy) NSString *ticketprice;
@end
