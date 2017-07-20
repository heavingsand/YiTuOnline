//
//  HelpSocketManager.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/7.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
#import "YiTuBaseModel.h"

@interface HelpSocketManager : NSObject<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSTimer *sendMessageTimer;
@property (nonatomic, strong) YiTuBaseModel *baseModel;
@property (nonatomic, assign) BOOL isStaff;
//@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, copy) NSData *returnData;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

+ (HelpSocketManager *) sharedSocket;

//连接服务器
- (void)connectServer;
//发送信息
- (void)sendMessageWithData:(NSMutableDictionary *)dic;
//断开连接
- (void)disconnectedSocket;
@end
