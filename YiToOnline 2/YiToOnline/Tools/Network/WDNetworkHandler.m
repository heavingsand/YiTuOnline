//
//  WDNetworkHandler.m
//  网络请求封装
//
//  Created by dllo on 16/5/27.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "WDNetworkHandler.h"

@implementation WDNetworkHandler

+ (void)getDataByURLString:(NSString *)urlString BodyString:(NSString *)bodyString WithDataBlock:(Block)dataBlock{
    // 请求地址的转码:(防止汉字的出现)
     urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // 获取AFN管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置允许请求的网络请求
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", nil];
    // 根据bodyString的值判断请求类型
    if (bodyString == nil) {
        // GET 请求
        [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 判断结果是否为空
            if (responseObject != nil) {
                // 将结果回调
                dataBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            
        }];
    } else {
        // POST请求
        [manager POST:urlString parameters:[self getDicByString:bodyString] progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject != nil) {
                dataBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败:%@", error);
            
        }];
    }
    
}

#pragma mark - 字符串转化为字典
+ (NSDictionary *)getDicByString:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *str in array) {
        NSArray *arr = [str componentsSeparatedByString:@"="];
        [dic setValue:arr[1] forKey:arr[0]];
    }
    return dic;
}











@end
