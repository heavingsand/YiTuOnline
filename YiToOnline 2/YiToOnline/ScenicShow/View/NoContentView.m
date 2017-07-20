//
//  NoContentView.m
//  Luohe
//
//  Created by sks on 16/6/14.
//  Copyright © 2016年 linyingbin. All rights reserved.
//

#import "NoContentView.h"
#import "Common.h"

@implementation NoContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithStyle:(NSString *)style {
    if (self = [super init]) {
        self.frame = CGRectMake(20, 0, kMainScreenWidth, 60);
        self.label = [Common labelExplainedWithFrame:self.bounds];
        self.label.font = [UIFont systemFontOfSize:16];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.text = [NSString stringWithFormat:@"%@",style];
        [self addSubview:self.label];
    }
    return self;
}

//- (instancetype)init {
//    self = [super init];
//    
//    self.frame = CGRectMake(0, 0, kMainScreenWidth, 60);
//    self.label = [Common labelExplainedWithFrame:self.bounds];
//    self.label.font = [UIFont systemFontOfSize:16];
//    self.label.textAlignment = NSTextAlignmentCenter;
//    self.label.text = @"o(︶︿︶)o亲，您还没有发布内容~~";
//    [self addSubview:self.label];
//    return self;
//}
@end
