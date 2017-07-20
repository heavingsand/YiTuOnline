//
//  UserManager.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/8.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YiTuBaseModel.h"

@interface UserManager : NSObject
@property (nonatomic, strong) YiTuBaseModel *baseModel;

+ (UserManager *) sharedSocket;
@end
