//
//  TypeScrollView.m
//  Luohe
//
//  Created by linyingbin on 16/2/20.
//  Copyright © 2016年 linyingbin. All rights reserved.
//

#import "TypeScrollView.h"
#import "Common.h"
#import "BottomBtn.h"

#define kFontSize   13

@implementation TypeScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.scrollsToTop = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

//横向滚动
-(void)layoutWithTagArray:(NSArray *)tagsArray
{
    for (UIButton *button in self.buttonArray) {
        [button removeFromSuperview];
    }
    self.buttonArray = [NSMutableArray array];
    CGFloat left = 4;
    for (int i=1; i<=tagsArray.count; i++) {
        NSDictionary *tagDic = [NSDictionary dictionary];
        tagDic = tagsArray[i-1];
        CGSize size = [Common sizeWithString:tagDic[@"city"] width:300 font:kFontSize];
        UIButton *button = [BottomBtn buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.frame = CGRectMake(left, 0, size.width+20, self.frame.size.height);
        [button.titleLabel setFont:[UIFont systemFontOfSize:kFontSize]];
        [button setTitle:tagDic[@"city"] forState:UIControlStateNormal];
        [button setTitleColor:kColorMajor forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(248, 117, 69) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(typeChangedVer:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = [tagDic[@"cityid"] intValue];
        [button setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateSelected];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:button];
        [self.buttonArray addObject:button];
        left+=button.width+4;
        if (button.tag == self.selectBaseId) {
            [button setSelected:YES];
        }
        if (i==tagsArray.count) {
            self.contentSize = CGSizeMake(left, self.height);
        }
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, self.frame.size.height - 1, self.frame.size.width - 16, 1)];
    lineView.backgroundColor = RGBColor(241, 241, 241);
    [self addSubview:lineView];
}

//竖向滚动
- (void)scrollVerticalWithArr:(NSArray *)tagsArray {
    for (UIButton *button in self.buttonArray) {
        [button removeFromSuperview];
    }
    self.buttonArray = [NSMutableArray array];
    CGFloat buttonHeight = 0;
    for (int i=1; i<=tagsArray.count; i++) {
        NSDictionary *tagDic = [NSDictionary dictionary];
        tagDic = tagsArray[i-1];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.frame = CGRectMake(2, buttonHeight, self.frame.size.width, 40);
        [button.titleLabel setFont:[UIFont systemFontOfSize:kFontSize]];
        [button setTitle:tagDic[@"province"] forState:UIControlStateNormal];
        [button setTitleColor:kColorMajor forState:UIControlStateNormal];
        [button setTitleColor:kColorWhite forState:UIControlStateSelected];
        button.layer.borderColor = kColorMin3.CGColor;
        [button addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = [tagDic[@"provinceid"] intValue];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        buttonHeight += button.height;
        if (button.tag == self.selectBaseId) {
            [button setSelected:YES];
        }
        if (i==tagsArray.count) {
            self.contentSize = CGSizeMake(self.width, buttonHeight);
        }
    }
}

//竖向滚动
- (void)scrollWithArr:(NSArray *)tagsArray {
    for (UIButton *button in self.buttonArray) {
        [button removeFromSuperview];
    }
    self.buttonArray = [NSMutableArray array];
    CGFloat buttonHeight = 1;
    for (int i=1; i<=tagsArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, buttonHeight, self.frame.size.width, 39);
        [button.titleLabel setFont:[UIFont systemFontOfSize:kFontSize]];
        [button setTitle:tagsArray[i-1] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:kColorMajor forState:UIControlStateNormal];
        [button setTitleColor:kColorWhite forState:UIControlStateSelected];
        
//        [button setBackgroundColor:RGBColor(248, 117, 69)];
//        [button setTitleColor:kColorWhite forState:UIControlStateNormal];
//        [button setTitleColor:RGBColor(248, 117, 69) forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self addSubview:button];
        [self.buttonArray addObject:button];
        buttonHeight += button.height + 1;
        if (button.tag == self.selectBaseId) {
            [button setSelected:YES];
        }
        if (i==tagsArray.count) {
            self.contentSize = CGSizeMake(self.width, buttonHeight);
        }
    }
}

-(void)typeChanged:(id)sender
{
    for (UIButton *button in self.buttonArray) {
        if (button == sender) {
            [button setSelected:YES];
            button.backgroundColor = RGBColor(248, 117, 69);
        }else{
            [button setSelected:NO];
            button.backgroundColor = kColorWhite;
        }
    }
    self.selectBaseId = [sender tag];
    if(self.changeTypeBlock){
        self.changeTypeBlock();
    }
}

-(void)typeChangedVer:(UIButton *)sender
{
    
    for (UIButton *button in self.buttonArray) {
        if (button == sender) {
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
    }
    self.selectBaseId = [sender tag];
    if(self.changeTypeBlock){
        self.changeTypeBlock();
    }
}

@end
