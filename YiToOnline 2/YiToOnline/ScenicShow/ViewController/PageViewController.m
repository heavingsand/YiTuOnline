//
//  PageViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/21.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "PageViewController.h"
#import "ScenicShowDetailViewController.h"
#import "ScenicSpotIntroViewController.h"
#import "PerformanceViewController.h"
#import "PeripheryViewController.h"
#import "StrategyViewController.h"
#import "AVPlayerManager.h"
@import AVFoundation;

@interface PageViewController ()
@property (nonatomic, strong) AVPlayer *avPlayer;
@end

@implementation PageViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    
    self.title = @"景点详情";
    self.view.backgroundColor = kColorBg;
    self.menuBGColor = kColorWhite;
    self.titleColorNormal = kColorMajor;
    self.titleColorSelected = RGBColor(248, 117, 69);
    //设置高度
    self.menuHeight = 40;
    //设置横线风格
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleSizeSelected = 15;
    self.titleSizeNormal = 15;
    
    //景点语音播放
    NSString *voice = [self.model.voice stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.avPlayer = [AVPlayer playerWithURL:[NSURL URLWithString:voice]];
    [self.avPlayer play];
    
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//重写父类的titiles属性的getter方法, 设置题目
- (NSArray<NSString *> *)titles{
    return @[@"景点介绍", @"表演信息", @"景点周边", @"攻略游记"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [AVPlayerManager shareManager].isStopPlay = NO;
    [[AVPlayerManager shareManager] avPlayerPlay];
}

#pragma mark - WMPage Delegate
//内部有多少个子视图
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}
//每个子控制器什么样
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        ScenicSpotIntroViewController *jumpVc = [[ScenicSpotIntroViewController alloc] init];
        jumpVc.scenicspotsid = self.model.scenicspotid;
        return jumpVc;
    }
    if (index == 1) {
        PerformanceViewController *jumpVc = [[PerformanceViewController alloc] init];
        jumpVc.scenicspotsid = self.model.scenicspotid;
        return jumpVc;
    }
    if (index == 2) {
        PeripheryViewController *jumpVc = [[PeripheryViewController alloc] init];
        jumpVc.scenicspotsid = self.model.scenicspotid;
        return jumpVc;
    }
    if (index == 3) {
        StrategyViewController *jumpVc = [[StrategyViewController alloc] init];
        jumpVc.scenicspotsid = self.model.scenicspotid;
        return jumpVc;
    }
    ScenicShowDetailViewController *jumpVC = [[ScenicShowDetailViewController alloc] init];
    jumpVC.model = self.model;
    return jumpVC;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return self.titles[index];
}

#pragma mark - Lazy Load
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
