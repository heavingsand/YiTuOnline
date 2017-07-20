//
//  SocketManager.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/12.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
#import "YiTuBaseModel.h"

@interface SocketManager : NSObject<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSTimer *sendMessageTimer;
@property (nonatomic, strong) YiTuBaseModel *baseModel;
@property (nonatomic, assign) BOOL isNoFirst;
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isAddOverlay;

+ (SocketManager *) sharedSocket;


//连接服务器
- (void)connectServerWithAdress:(NSString *)adress andPort:(uint16_t)port;
//发送信息
- (void)sendMessageWithData;
//断开连接
- (void)disconnectedSocket;
@end
