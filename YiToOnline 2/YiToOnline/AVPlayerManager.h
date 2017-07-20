//
//  AVPlayerManager.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/29.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface AVPlayerManager : NSObject
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy) NSString *languagename;
@property (nonatomic, assign) NSInteger languageid;
@property (nonatomic, assign) BOOL isStopPlay;

+ (AVPlayerManager *)shareManager;

- (void)setAVPlayerUrl:(NSString *)url;

- (void)avPlayerPause;

- (void)avPlayerPlay;
@end
