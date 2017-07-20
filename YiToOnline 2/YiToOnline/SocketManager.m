//
//  SocketManager.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/12.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "SocketManager.h"

@implementation SocketManager
+ (SocketManager *)sharedSocket {
    static id socket;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [self new];
    });
    return socket;
}

#pragma mark - Method
- (void)connectServerWithAdress:(NSString *)adress andPort:(uint16_t)port {
    NSError *error;
    [self.asyncSocket connectToHost:adress onPort:port error:&error];
    if (error) {
        NSLog(@"连接失败:%@", error);
    } else {
        self.isConnect = YES;
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
- (void)sendMessageWithData {
    if (![SocketManager sharedSocket].isLogin) {
        return;
    }
    if (self.sendMessageTimer) {
        [self.sendMessageTimer invalidate];
        self.sendMessageTimer = nil;
    }
    self.sendMessageTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(sendMessageWithData) userInfo:nil repeats:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.isNoFirst) {
        params[@"scenicspotsid"] = self.baseModel.scenicspotsid;
        params[@"lat"] = self.baseModel.lat;
        params[@"lng"] = self.baseModel.lng;
        params[@"isstaff"] = self.baseModel.isstaff;
    }else {
        params[@"type"] = @"android";
        params[@"id"] = self.baseModel.ID;
        params[@"channelid"] = self.baseModel.channelid;
        params[@"name"] = self.baseModel.name;
        params[@"phonenumber"] = self.baseModel.phonenumber;
        self.isNoFirst = YES;
    }
    /**  打印  **/
    NSString *parametersString = @"";
    for (NSString *key in [params allKeys]) {
        parametersString = [parametersString stringByAppendingFormat:@"%@=%@&",key,params[key]];
    }
    NSLog(@"parameter string:\n %@",parametersString);
    NSLog(@"parameters:\n %@",params);
    /***********/
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [self.asyncSocket writeData:data withTimeout:-1 tag:100];
}

#pragma mark - GCDSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"成功连接到服务器");
    [self.asyncSocket readDataWithTimeout:-1 tag:100];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (err) {
        NSLog(@"连接失败DidDisconnect");
    } else {
        NSLog(@"正常断开连接");
    }
}

//读取消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self.asyncSocket readDataWithTimeout:-1 tag:100];
}

#pragma mark - Lazy Load
- (instancetype)init {
    if (self = [super init]) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _baseModel = [[YiTuBaseModel alloc] init];
        _baseModel.scenicspotsid = @"0";
        _isAddOverlay = YES;
    }
    return self;
}
@end
