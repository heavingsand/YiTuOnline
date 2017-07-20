//
//  HelpSocketManager.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/7.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "HelpSocketManager.h"

@implementation HelpSocketManager
+ (HelpSocketManager *)sharedSocket {
    static id socket;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [self new];
    });
    return socket;
}

#pragma mark - Method
//建立连接
- (void)connectServer {
    NSError *error;
    [self.asyncSocket connectToHost:ServerSocketAdress onPort:8082 error:&error];
    if (error) {
        NSLog(@"连接失败connectServer:%@", error);
    } else {
//        self.isConnect = YES;
        NSLog(@"连接成功");
    }
}

//断开连接
- (void)disconnectedSocket {
//    [self.asyncSocket setDelegate:nil];
    [self.asyncSocket disconnect];
//    [asyncSocket setDelegate:nil];
//    * [asyncSocket disconnect];
//    * [asyncSocket release];

}

//发送信息
- (void)sendMessageWithData:(NSMutableDictionary *)dic {
    /**  打印  **/
    [self.dataDic removeAllObjects];
    self.dataDic = dic;
    NSString *parametersString = @"";
    for (NSString *key in [dic allKeys]) {
        parametersString = [parametersString stringByAppendingFormat:@"%@=%@&",key,dic[key]];
    }
    NSLog(@"parameter string:\n %@",parametersString);
    NSLog(@"parameters:\n %@",dic);
    /***********/
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [self.asyncSocket writeData:data withTimeout:-1 tag:200];
}

#pragma mark - GCDSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"成功连接到服务器");
    [self.asyncSocket readDataWithTimeout:-1 tag:200];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
//    self.isConnect = NO;
    if (err) {
        NSLog(@"连接失败DidDisconnect");
//        NSError *error;
//        [self.asyncSocket connectToHost:ServerSocketAdress onPort:8082 error:&error];
//        [self sendMessageWithData:self.dataDic];
    } else {
        NSLog(@"正常断开连接");
    }
}

//读取消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"%@", data);
//    [kNotificationCenter postNotificationName:kNotiSOS object:data];
    if (data != nil) {
        self.returnData = data;
    }
    [self.asyncSocket readDataWithTimeout:-1 tag:200];
}

#pragma mark - Lazy Load
- (instancetype)init {
    if (self = [super init]) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _baseModel = [[YiTuBaseModel alloc] init];
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end
