//
//  ComplainModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/23.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface ComplainModel : NSObject
//@property (nonatomic, copy) NSString *complaintsid;
@property (nonatomic, assign) NSInteger complaintsid;
@property (nonatomic, copy) NSString *complaints;
@property (nonatomic, copy) NSString *complaintstime;
@property (nonatomic, copy) NSString *scenicspotname;
@property (nonatomic, copy) NSString *reply;
@property (nonatomic, copy) NSString *replytime;
//@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger userid;
@end
