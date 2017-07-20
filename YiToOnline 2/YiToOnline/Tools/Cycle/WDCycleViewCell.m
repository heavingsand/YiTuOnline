//
//  WDCycleViewCell.m
//  轮播图封装
//
//  Created by dllo on 16/5/26.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "WDCycleViewCell.h"

@implementation WDCycleViewCell



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cycleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_cycleImageView];
    }
    return self;
}

@end
