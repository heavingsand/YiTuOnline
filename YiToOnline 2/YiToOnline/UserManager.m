//
//  UserManager.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/8.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
+ (UserManager *)sharedSocket {
    static id socket;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [self new];
    });
    return socket;
}

- (instancetype)init {
    if (self = [super init]) {
        _baseModel = [[YiTuBaseModel alloc] init];
    }
    return self;
}

@end
