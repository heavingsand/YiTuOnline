//
//  ScenicShowViewController.m
//  YiTuOnline
//
//  Created by 吴迪 on 16/8/31.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ScenicShowViewController.h"
#import "ModelScenicShowHomePage.h"
#import "WDNetworkHandler.h"
#import "ScenicShowHomePageTableViewCell.h"
#import "ScenicShowDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "TypeScrollView.h"
#import "ProvinceCityModel.h"
#import "NoContentView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "SocketManager.h"
#import "ScenicShowTableViewCell.h"
#import "PageViewController.h"
#import "MyTableView.h"
#import "AVPlayerManager.h"


@interface ScenicShowViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,AMapLocationManagerDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *allCityArr;
@property (nonatomic, strong) NSMutableArray *allProvincesArr;
@property (nonatomic, strong) NSMutableDictionary  *allCityDic;
@property (nonatomic, strong) TypeScrollView *topView;
@property (nonatomic, strong) TypeScrollView *transView;
@property (nonatomic, strong) ProvinceCityModel *provinceCityModel;
@property (nonatomic, strong) UISearchBar *search;
@property (nonatomic, strong) UISearchController *provinceSearch;
@property (nonatomic, strong) UIView *titleView, *cityView;
@property (nonatomic, strong) UIBarButtonItem *cityBtn;

@end

@implementation ScenicShowViewController

#define kAllCityArr @[@"广东",@"湖北",@"贵州",@"吉林",@"江西",@"北京",@"安徽",@"福建",@"甘肃",@"广西",@"海南",@"河北",@"河南",@"黑龙江",@"湖南",@"江苏",@"辽宁",@"内蒙古",@"宁夏",@"青海",@"山东",@"陕西",@"上海",@"四川",@"西藏",@"新疆",@"云南",@"浙江",@"重庆",@"香港",@"澳门",@"台湾"]

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setUpNavBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"";
    self.view.backgroundColor = kColorBg;
    self.definesPresentationContext = YES;
    [self cityView];
    [self titleView];
    [self tableView];
    [self topView];
    [self getAllCity];
    [self.tableView registerClass:[ScenicShowTableViewCell class] forCellReuseIdentifier:@"ScenicShowTableViewCell"];
//    [self loadUserCityScenicSpot];
    if (self.modelArray.count == 0) {
        self.tableView.tableFooterView = [[NoContentView alloc] initWithStyle:@"抱歉,你搜索的景区不存在o(︶︿︶)o"];
    }else{
        self.tableView.tableFooterView = nil;
    }
    __weak __typeof(self)weakSelf = self;
    [self.topView setChangeTypeBlock:^{
        [weakSelf loadTransView];
        [weakSelf getScenicSpotFromProvince];
        weakSelf.search.showsCancelButton = NO;
        [weakSelf.search resignFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
//加载横向滚动条
- (void)loadTransView {
    NSArray *arr = [self.allCityDic valueForKey:[NSString stringWithFormat:@"%ld", (long)self.topView.selectBaseId]];
    [self.transView removeFromSuperview];
    if (arr.count != 0) {
        TypeScrollView *transView = self.transView = [[TypeScrollView alloc] initWithFrame:CGRectMake(self.topView.width, 0, kMainScreenWidth - self.topView.width, 40)];
        transView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:transView];
        [transView layoutWithTagArray:arr];
        __weak __typeof(self)weakSelf = self;
        [transView setChangeTypeBlock:^{
            [weakSelf getScenicSpotFromCity];
        }];
    }
    if (arr.count == 0) {
        self.tableView.frame = CGRectMake(self.topView.width, 0, kMainScreenWidth - self.topView.width, kMainScreenHeight - 112);
    } else {
        self.tableView.frame = CGRectMake(self.topView.width, self.transView.height, kMainScreenWidth - self.topView.width, kMainScreenHeight - 112 - self.transView.height);
    }
}
//获取所有景点信息
- (void)getAllCity {
    //获取名称
    [RXApiServiceEngine requestWithType:RequestMethodTypeGet url:kUrl_ProvinceCity parameters:nil completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                self.allCityDic = jsonData[@"result"][@"City"];
            }
        }
    }];
    //获取景点信息
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ScenicspotsAll parameters:nil completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.modelArray removeAllObjects];
                for (NSDictionary *dic in jsonData[@"result"]) {
                    ModelScenicShowHomePage *model = [ModelScenicShowHomePage parse:dic];
                    [self.modelArray addObject:model];
                }
                if (self.modelArray.count == 0) {
                    
                    self.tableView.tableFooterView = [[NoContentView alloc] initWithStyle:@"抱歉,你搜索的景区不存在o(︶︿︶)o"];
                }else{
                    
                    self.tableView.tableFooterView = nil;
                }
                [self.tableView reloadData];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
    
}
//根据城市获取景点
- (void)getScenicSpotFromCity {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"cityid"] = [NSString stringWithFormat:@"%ld",(long)self.transView.selectBaseId];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_citygetidscenicspots parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.modelArray removeAllObjects];
                for (NSDictionary *dic in jsonData[@"result"]) {
                    ModelScenicShowHomePage *model = [ModelScenicShowHomePage parse:dic];
                    [self.modelArray addObject:model];
                }
                if (self.modelArray.count == 0) {
                    self.tableView.tableFooterView = [[NoContentView alloc] initWithStyle:@"抱歉,你搜索的景区不存在o(︶︿︶)o"];
                }else{
                    self.tableView.tableFooterView = nil;
                }
                [self.tableView reloadData];
            }
            if ([jsonData[@"resultnumber"]intValue] == 201) {
                [AlertManager alertMessage:@"输入参数为空"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 204) {
                [AlertManager alertMessage:@"未知错误"];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
//根据省份获取景点
- (void)getScenicSpotFromProvince {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"provinceid"] = [NSString stringWithFormat:@"%ld",(long)self.topView.selectBaseId];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kURl_provinceIdGetScenicspot parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.modelArray removeAllObjects];
                for (NSDictionary *dic in jsonData[@"result"]) {
                    ModelScenicShowHomePage *model = [ModelScenicShowHomePage parse:dic];
                    [self.modelArray addObject:model];
                }
                if (self.modelArray.count == 0) {
                    
                    self.tableView.tableFooterView = [[NoContentView alloc] initWithStyle:@"抱歉,你搜索的景区不存在o(︶︿︶)o"];
                }else{
                    
                    self.tableView.tableFooterView = nil;
                }
                [self.tableView reloadData];
            }
            if ([jsonData[@"resultnumber"]intValue] == 201) {
                [AlertManager alertMessage:@"输入参数为空"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 204) {
                [AlertManager alertMessage:@"未知错误"];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
//模糊查询景点和根据定位景点查询
- (void)queryScenicSpotWithParamsValue:(NSString *)value andPath:(NSString * )path andKey:(NSString *)key{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:value forKey:key];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:path parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.modelArray removeAllObjects];
                for (NSDictionary *dic in jsonData[@"result"]) {
                    ModelScenicShowHomePage *model = [ModelScenicShowHomePage parse:dic];
                    [self.modelArray addObject:model];
                }
                if (self.modelArray.count == 0) {
                    
                    self.tableView.tableFooterView = [[NoContentView alloc] initWithStyle:@"抱歉,你搜索的景区不存在o(︶︿︶)o"];
                }else{
                    
                    self.tableView.tableFooterView = nil;
                }
                [self.tableView reloadData];
            }
            if ([jsonData[@"resultnumber"]intValue] == 201) {
                [AlertManager alertMessage:@"输入参数为空"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 204) {
                [AlertManager alertMessage:@"未知错误"];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

- (void) hideKeyboard {
    [self.search resignFirstResponder];
}
#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.modelArray != nil) {
        return self.modelArray.count;
    }
    return 0;
    
//    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ScenicShowTableViewCell";
//    ScenicShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    ScenicShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
     cell = [[ScenicShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setImage:[self.modelArray[indexPath.row] img] andTitle:[self.modelArray[indexPath.row] scenicspotname] andStar:[self.modelArray[indexPath.row] starlevel] andPrice:[self.modelArray[indexPath.row] ticketprice]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PageViewController *jumpVC = [[PageViewController alloc] init];
    [AVPlayerManager shareManager].isStopPlay = YES;
    [[AVPlayerManager shareManager] avPlayerPause];
    jumpVC.model = self.modelArray[indexPath.row];
    jumpVC.hidesBottomBarWhenPushed = YES;
    self.search.showsCancelButton = NO;
    [self.search resignFirstResponder];
    [self.navigationController pushViewController:jumpVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.search.showsCancelButton = NO;
    [self.search resignFirstResponder];
}
#pragma mark - UISearchBar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.search.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.search.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [self queryScenicSpotWithParamsValue:self.search.text andPath:kUrl_scenicSpotsLike andKey:@"scenicspotname"];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.search.showsCancelButton = YES;
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancleBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    return YES;
}

#pragma mark - Lazy Load
- (TypeScrollView *)topView {
    if (!_topView) {
        _topView = [[TypeScrollView alloc] initWithFrame:CGRectMake(0, 0, 60, kMainScreenHeight - 112)];
        //测试颜色
//        _topView.backgroundColor = kColorWhite;
         _topView.backgroundColor = RGBColor(241, 241, 241);
        [_topView scrollWithArr:kAllCityArr];
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (NSMutableArray *)allCityArr {
    if (!_allCityArr) {
        _allCityArr = [NSMutableArray array];
    }
    return _allCityArr;
}

- (NSMutableArray *)allProvincesArr {
    if (!_allProvincesArr) {
        _allProvincesArr = [NSMutableArray array];
    }
    return _allProvincesArr;
}

- (ProvinceCityModel *)provinceCityModel {
    if (!_provinceCityModel) {
        _provinceCityModel = [[ProvinceCityModel alloc] init];
    }
    return _provinceCityModel;
}

- (NSMutableDictionary *)allCityDic {
    if (!_allCityDic) {
        _allCityDic = [NSMutableDictionary dictionary];
    }
    return _allCityDic;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.topView.width, 0, kMainScreenWidth - 50, kMainScreenHeight - 112)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        gestureRecognizer.numberOfTapsRequired = 1;
        gestureRecognizer.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:gestureRecognizer];
    }
    return _tableView;
}


- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth -80 , 30)];//allocate titleView
//        UIColor *color =  self.navigationController.navigationBar.backgroundColor;
        
        [_titleView setBackgroundColor:[UIColor clearColor]];
        
        
        UISearchBar *searchBar = self.search = [[UISearchBar alloc] init];
        [searchBar sizeToFit];
        searchBar.delegate = self;
        searchBar.frame = CGRectMake(0, 0, kMainScreenWidth-80 , 30);
//        searchBar.backgroundColor = color;
        searchBar.layer.cornerRadius = 6;
        searchBar.layer.masksToBounds = YES;
        [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
        [searchBar setTintColor:RGBColor(248, 117, 69)];
//        [searchBar setTintColor:kColorWhite];
        
        
        
        [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"]];
        
        searchBar.placeholder = @"请输入要搜索的景区";
        
        [_titleView addSubview:searchBar];
        _titleView.clipsToBounds = YES;
        
        //Set to titleView
        [self.navigationItem.titleView sizeToFit];
        self.navigationItem.titleView = _titleView;
    }
    return _titleView;
}
- (UIView *)cityView {
    if (!_cityView) {
        _cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        label.text = [SocketManager sharedSocket].baseModel.city;
        label.textColor = kColorWhite;
        label.textAlignment = NSTextAlignmentRight;
        [_cityView addSubview:label];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 6, 13, 16)];
        imageView.image = [UIImage imageNamed:@"dingwei"];
        [_cityView addSubview:imageView];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_cityView];
        //弹簧控件, 修复边距
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -15;
        self.navigationItem.leftBarButtonItems = @[spaceItem,leftItem];
    }
    return _cityView;
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
