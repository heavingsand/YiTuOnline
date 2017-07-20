//
//  WDCycleView.m
//  轮播图封装
//
//  Created by dllo on 16/5/26.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "WDCycleView.h"
#import "WDCycleViewCell.h"
// #import "UIImageView+WebCache.h"
#import <UIImageView+WebCache.h>
#define SECTION_COUNT 1000
@interface WDCycleView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
/** 轮播图控件 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据源数组 */
@property (nonatomic, strong) NSArray *dataSouceArray;
/** 定时器时间间隔 */
@property (nonatomic, assign) CGFloat timeInterval;
/** 定时器对象 */
@property (nonatomic, strong) NSTimer *cycleTimer;
/** 当前item的下标 */
@property (nonatomic, assign) NSInteger itemIndex;
/** 当前section下标 */
@property (nonatomic, assign) NSInteger currentSection;
@end


@implementation WDCycleView

- (instancetype)initWithFrame:(CGRect)frame
                    DataSouce:(NSArray *)dataSouce
                 TimeInterval:(CGFloat)time{
    self = [super initWithFrame:frame];
    if (self) {
        // 将外界传递进来的数据源赋值给dataSourceArray
        self.dataSouceArray = dataSouce;
        // 初始化默认瀑布流样式
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = frame.size;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 初始化collctionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        // 注册cell
        [self.collectionView registerClass:[WDCycleViewCell class] forCellWithReuseIdentifier:@"WD_Cell"];
        //设置初始偏移量:(适用于非网络请求的图片，不需要刷新)
        if (self.dataSouceArray.count > 1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:SECTION_COUNT / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        // 判断时间是否合理
        if (time > 0) {
            self.timeInterval = time;
            [self addtimer];// 开启定时器
        }
        
    }
    return self;
}

#pragma mark - item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSouceArray.count;
}
#pragma mark - section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return SECTION_COUNT;
}

#pragma mark - 为item赋值
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSouceArray.count != 0) {
        WDCycleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WD_Cell" forIndexPath:indexPath];
        //记录当前的item和section:
        NSLog(@"%ld --- %ld", (long)indexPath.section, (long)_itemIndex);
        if (indexPath.item > _itemIndex)
        {
            _itemIndex = indexPath.item;
        }
        
        _currentSection = indexPath.section;
        NSLog(@"section : %ld", (long)_currentSection);
        //加一个数据保护
        if (self.dataSouceArray.count != 0) {
            [cell.cycleImageView sd_setImageWithURL:[NSURL URLWithString:[self.dataSouceArray objectAtIndex:indexPath.item]]];
        }
        //添加循环保护:(防止到最后一个分区出现崩溃)
        if (indexPath.section == SECTION_COUNT - 1) {
            //回到最初的起点
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:SECTION_COUNT / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        return cell;
    }
    return [UICollectionViewCell new];
}

#pragma mark - 点击item触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // NSLog(@"点击了图片:%ld", indexPath.item);
    // 命令代理人去执行协议方法
    if (self.delegate != nil) {
        [self.delegate didClickedItemAtIndexPath:indexPath];
    }
    
}


#pragma mark - 添加定时器
- (void)addtimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changePageByTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.cycleTimer = timer;
}

#pragma mark - 移除定时器
- (void)removeTimer{
    [self.cycleTimer invalidate];
    self.cycleTimer = nil;
}

#pragma mark - 定时器调用的方法
- (void)changePageByTime{
    if (_itemIndex == self.dataSouceArray.count) {
        _itemIndex = 0;
        _currentSection++;
    }
    // 偏移到最新位置(下一张)
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_itemIndex inSection:_currentSection] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    _itemIndex++;
    if (self.dataSouceArray.count > 0) {
        //偏移到最新位置(下一张)
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_itemIndex inSection:_currentSection] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        _itemIndex++;
    }
}

#pragma mark - 手指开始滑动定时器失效
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_timeInterval > 0) {
        [self removeTimer];
    }
}

#pragma mark - 手指开始滑动定时器开启
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_timeInterval > 0) {
        [self addtimer];
    }
}


#pragma mark -- 刷新
- (void)reloadDataByArray:(NSMutableArray *)dataSource
{
    self.dataSouceArray = dataSource;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:SECTION_COUNT / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}











@end
