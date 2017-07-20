//
//  PeripheryViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "PeripheryViewController.h"
#import "PeripheryModel.h"
#import "PeripheryTableViewCell.h"
#import "iCarousel.h"


typedef NS_ENUM(NSUInteger, RequestMode) {
    RequestModeRefresh,
    RequestModeMore,
};

@interface PeripheryViewController ()<UITableViewDelegate, UITableViewDataSource, iCarouselDelegate, iCarouselDataSource>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSMutableArray *peripheryArr;
@property (nonatomic, strong) NSMutableArray *advertisementArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) iCarousel *MyCarousel;
@property (nonatomic, strong) NSTimer *MyTime;
@property (nonatomic, strong) UIPageControl *pageController;
@end

@implementation PeripheryViewController

#define kMenuArr @[@"购物",@"娱乐",@"美食",@"住宿",@"出行"]
#define kMenuImage @[@"type1",@"type7",@"type5",@"type6",@"type8"]

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    
    [self tableView];
    [self headView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PeripheryTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"PeripheryTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPeripheryWithRequestMode:RequestModeRefresh];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadPeripheryWithRequestMode:RequestModeMore];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.MyTime invalidate]
    self.type = nil;
    [self.MyTime setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.MyTime setFireDate:[NSDate distantFuture]];
}

#pragma mark - Method
/** 获取景点周边信息 **/
- (void)loadPeripheryWithRequestMode:(RequestMode)requestMode {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (requestMode == RequestModeRefresh) {
        [self.peripheryArr removeAllObjects];
//        [self.advertisementArr removeAllObjects];
        self.page = 1;
        params[@"scenicspotsid"] = [NSString stringWithFormat:@"%ld", self.scenicspotsid];
        params[@"page"] = [NSString stringWithFormat:@"%ld",self.page];
        params[@"pagecount"] = @10;
        params[@"scenicspotRimTypeId"] = self.type;
    }else {
        self.page += 1;
        params[@"scenicspotsid"] = [NSString stringWithFormat:@"%ld", self.scenicspotsid];
        params[@"page"] = [NSString stringWithFormat:@"%ld",self.page];
        params[@"pagecount"] = @10;
        params[@"scenicspotRimTypeId"] = self.type;
    }
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ScIdGetScenicspotRim parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                if (self.type == nil) {
                    for (NSDictionary *dic in jsonData[@"result"][@"ScenicspotRim"]) {
                        ScenicspotRimModel *model = [ScenicspotRimModel parse:dic];
                        [self.peripheryArr addObject:model];
                    }
                    if (requestMode == RequestModeRefresh) {
                        for (NSDictionary *dic in jsonData[@"result"][@"ScenicspotRimAdvertising"]) {
                            ScenicspotRimAdvertisingModel *model = [ScenicspotRimAdvertisingModel parse:dic];
                            [self.advertisementArr addObject:model];
                        }
                        self.pageController.numberOfPages = self.advertisementArr.count;
                    }
                }else {
                    for (NSDictionary *dic in jsonData[@"result"]) {
                        ScenicspotRimModel *model = [ScenicspotRimModel parse:dic];
                        [self.peripheryArr addObject:model];
                    }
                }
                [self.tableView reloadData];
                [self.MyCarousel reloadData];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

- (void)menuBtnClick:(UIButton *)sender {
    self.type = [NSString stringWithFormat:@"%ld", sender.tag];
    [self loadPeripheryWithRequestMode:RequestModeRefresh];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.peripheryArr != nil) {
        return self.peripheryArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PeripheryTableViewCell";
    PeripheryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setCellContent:self.peripheryArr[indexPath.row]];
    return cell;
}

#pragma mark - iCarousel 代理方法
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.advertisementArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:carousel.frame];
        UIImageView *iconIv = [UIImageView new];
        iconIv.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:iconIv];
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [iconIv sd_setImageWithURL:[NSURL URLWithString:[self.advertisementArr[index] scenicspotRimAdvertisingImg]]];
        iconIv.contentMode = UIViewContentModeScaleAspectFill;
        iconIv.clipsToBounds = YES;
        iconIv.tag = 100;
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}
//当ic中的页面发生变化时
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    self.pageController.currentPage = carousel.currentItemIndex;
}

//开始拖拽
- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    [self.MyTime setFireDate:[NSDate distantFuture]];
}

//结束拖拽
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    [self.MyTime setFireDate:[NSDate distantPast]];
}
#pragma mark - Lazy Load
- (NSMutableArray *)peripheryArr {
    if (!_peripheryArr) {
        _peripheryArr = [NSMutableArray new];
    }
    return _peripheryArr;
}

- (NSMutableArray *)advertisementArr {
    if (!_advertisementArr) {
        _advertisementArr = [NSMutableArray new];
    }
    return _advertisementArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 104) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 284)];
        _headView.backgroundColor  = RGBColor(226, 226, 226);
        _tableView.tableHeaderView = _headView;
        
        //头部广告栏
        _MyCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 200)];
        _MyCarousel.delegate = self;
        _MyCarousel.dataSource = self;
        //滚动阻尼
        _MyCarousel.scrollSpeed = 0.1;
        //滚动减速, 只滚动一页
        _MyCarousel.decelerationRate = 0.5;
        //显示类型
        _MyCarousel.type = iCarouselTypeCylinder;
        [_headView addSubview:_MyCarousel];
        
        _MyTime =  [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [_MyCarousel scrollToItemAtIndex:_MyCarousel.currentItemIndex + 1 animated:YES];
        }];
        
        _pageController = [[UIPageControl alloc] init];
        //页数展示
        [_MyCarousel addSubview:_pageController];
        [_pageController mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
        }];
        //pageController不接受用户操作
        _pageController.userInteractionEnabled = NO;
        
        //菜单栏
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, _MyCarousel.bottom, kMainScreenWidth, 80)];
        menuView.backgroundColor = kColorWhite;
        [_headView addSubview:menuView];
        
        for (int i = 0; i< 5; i ++) {
            UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 5 * i, 10, kMainScreenWidth / 5, 40)];
            [menuBtn setImage:[UIImage imageNamed:kMenuImage[i]] forState:UIControlStateNormal];
            menuBtn.tag = i + 1;
            [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *menuLab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth / 5 * i, menuBtn.bottom + 2, kMainScreenWidth / 5, 20)];
            menuLab.text = kMenuArr[i];
            menuLab.font = [UIFont systemFontOfSize:13];
            menuLab.textColor = kColorMajor;
            menuLab.textAlignment = NSTextAlignmentCenter;
            
            [menuView addSubview:menuBtn];
            [menuView addSubview:menuLab];
        }
        
    }
    return _headView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
