//
//  WDCycleView.h
//  轮播图封装
//
//  Created by dllo on 16/5/26.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import "UIImageView+WebCache.h"
@protocol WDCycleViewDelegate <NSObject>

@required
// 必须实现的
@optional
// 可选的
- (void)didClickedItemAtIndexPath:(NSIndexPath *)indexPath;
@end



@interface WDCycleView : UIView

/** 代理人 */
@property (nonatomic, assign) id<WDCycleViewDelegate> delegate;

// 声明初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                    DataSouce:(NSArray *)dataSouce
                 TimeInterval:(CGFloat)time;

//刷新方法：
- (void)reloadDataByArray:(NSMutableArray *)dataSource;

@end
