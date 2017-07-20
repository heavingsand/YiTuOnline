//
//  WDNetworkHandler.h
//  网络请求封装
//
//  Created by dllo on 16/5/27.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
// #import "AFNetworking.h" // 网络请求文件

typedef void(^Block)(id result);

@interface WDNetworkHandler : NSObject

// 声明一个网络请求的方法:
+ (void)getDataByURLString:(NSString *)urlString
                BodyString:(NSString *)bodyString
             WithDataBlock:(Block)dataBlock;



@end
