//
//  AVPlayerManager.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/29.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "AVPlayerManager.h"

@implementation AVPlayerManager
+ (AVPlayerManager *)shareManager {
    static id avPlayer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avPlayer = [self new];
    });
    return avPlayer;
}

- (void)setAVPlayerUrl:(NSString *)url {
//    [self.player pause];
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
//    [self.player play];
}

- (void)avPlayerPause {
    [self.player pause];
}

- (void)avPlayerPlay {
    //如果不是强制暂停就播放
    if (!self.isStopPlay) {
        [self.player play];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        _languageid = 1;
    }
    return self;
}
@end
