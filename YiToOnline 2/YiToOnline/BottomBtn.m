//
//  BottomBtn.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/21.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "BottomBtn.h"

@implementation BottomBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height - 3, contentRect.size.width, 2);//图片的位置大小
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height / 2 - 10 , contentRect.size.width, 20);//文本的位置大小
}
@end
