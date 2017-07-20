//
//  TypeScrollView.h
//  Luohe
//
//  Created by linyingbin on 16/2/20.
//  Copyright © 2016年 linyingbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeScrollView : UIScrollView

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (nonatomic, copy) void (^changeTypeBlock)();
@property (nonatomic, assign) NSInteger selectBaseId;

//横向
- (void)layoutWithTagArray:(NSArray *)tagsArray;
//竖向
- (void)scrollVerticalWithArr: (NSArray *)tagsArray;
- (void)scrollWithArr:(NSArray *)tagsArray;
@end
