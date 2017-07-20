//
//  SearchViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/1.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "SearchViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "SocketManager.h"
#import "MapViewController.h"

typedef NS_ENUM(NSUInteger, SearchType) {
    SearchTypePOI,
    SearchTypeNear
};



@interface SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UISearchBar *search;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) AMapSearchAPI *searchApi;
@property (nonatomic, strong) NSMutableArray *tips, *historyArr;
@end

@implementation SearchViewController

#define kTypeNameArr @[@"家",@"商场",@"加油站",@"停车场",@"卫生间",@"餐饮",@"酒店",@"娱乐"]

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.searchApi = [[AMapSearchAPI alloc] init];
    self.searchApi.delegate = self;
    
    [self titleView];
    [self tableView];
    [self resultTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.search resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
/*返回上一级控制器*/
- (void)returnLaststageVC {
    [self.navigationController popViewControllerAnimated:YES];
}


/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city = [SocketManager sharedSocket].baseModel.city;
    //    tips.cityLimit = YES; 是否限制城市
    
    [self.searchApi AMapInputTipsSearch:tips];
}

/* 加载景点按钮 */
- (void)addTypeInView: (UIView *)view {
    for (int i = 0; i<8; i++) {
        UIButton *button = [[UIButton alloc] init];
        UILabel *lable = [[UILabel alloc] init];
        if (i < 4) {
            button.frame = CGRectMake((kMainScreenWidth - 40*4)/5 + ((kMainScreenWidth - 40*4)/5 + 40) * i, 10, 40, 40);
            lable.frame = CGRectMake((kMainScreenWidth - 40*4)/5 + ((kMainScreenWidth - 40*4)/5 + 40) * i, 10 + button.height, 40, 30);
        }else {
            button.frame = CGRectMake((kMainScreenWidth - 40*4)/5 + ((kMainScreenWidth - 40*4)/5 + 40) * (i-4), 80, 40, 40);
            lable.frame = CGRectMake((kMainScreenWidth - 40*4)/5 + ((kMainScreenWidth - 40*4)/5 + 40) * (i-4), 80 + button.height, 40, 30);
        }
        [button setTag:i];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"type%d", i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"type%d", i]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(findTyee:) forControlEvents:UIControlEventTouchUpInside];
        
        lable.text = kTypeNameArr[i];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = kColorMajor;
        lable.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:button];
        [view addSubview:lable];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, kMainScreenWidth, 1)];
    lineView.backgroundColor = kColorBg;
    [view addSubview:lineView];
    
    UILabel *searchLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 170, 100, 20)];
    searchLab.text = @"最近搜索";
    searchLab.textColor = RGBColor(75, 75, 75);
    searchLab.font = [UIFont systemFontOfSize:19];
    [view addSubview:searchLab];
    
    UIButton *historyBtn = [[UIButton alloc] init];
    [historyBtn setTitle:@"清除最近搜索" forState:UIControlStateNormal];
    [historyBtn setTitleColor:kColorMajor forState:UIControlStateNormal];
    historyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:historyBtn];
    [historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view.right).offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(view.top).offset(170);
    }];
    [historyBtn addTarget:self action:@selector(removeHistory) forControlEvents:UIControlEventTouchUpInside];
}

/* 景点类型的POI检索 */
- (void)findTyee:(UIButton *)sender {
    if (sender.tag == 0) {
        [AlertManager alertMessage:@"请先记录你家的位置"];
    } else {
        [self returnMapView:kTypeNameArr[sender.tag] and:SearchTypeNear];
    }
}

/* 清楚搜索记录 */
- (void)removeHistory {
    [AlertManager toastMessage:@"清除成功" inView:self.view];
    [Common clearAsynchronousWithKey:kSearchHistory];
    [self.tableView reloadData];
}
#pragma mark - AMapSearchDelegate Delegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips removeAllObjects];
    
    [self.tips setArray:response.tips];
    
    [self.resultTableView reloadData];
}

/* 搜索回跳主页地图 */
- (void)returnMapView:(NSString *)keywrod and:(SearchType )type{
    MapViewController *mapViewVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    switch (type ) {
        case SearchTypePOI:
            [mapViewVC searchPoiByKeyword:keywrod];
            break;
        case SearchTypeNear:
            [mapViewVC searchPoiByCenterCoordinate:keywrod];
            break;
        default:
            break;
    }
    [self.navigationController popToViewController:mapViewVC animated:YES];
}
#pragma mark -  UISearchResultsUpdating Delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"Entering:%@",searchController.searchBar.text);
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        if (self.tips.count > 0) {
            AMapTip *tip = self.tips[0];
            if (tip.location == nil)
            {
                [self.tips removeObjectAtIndex:0];
            }
        }
        return self.tips.count;
    }else {
        NSArray *arr = [Common getAsynchronousWithKey:kSearchHistory];
        self.historyArr = [NSMutableArray arrayWithArray:arr];
        self.historyArr = (NSMutableArray *)[[self.historyArr reverseObjectEnumerator] allObjects];
        return self.historyArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"POICell";
    NSString *identifier = self.tableView == self.resultTableView ? @"Cell" : @"ResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    if (tableView == self.resultTableView) {
        //            cell.textLabel.text = @"龙城广场";
        AMapTip *tip = self.tips[indexPath.row];
        if (tip.location == nil)
        {
            cell.textLabel.text = @"没有此地";
        } else {
            cell.textLabel.text = tip.name;
            
        }
        cell.detailTextLabel.text = tip.address;
        
    } else {
        NSDictionary *dic = [NSDictionary new];
        dic = self.historyArr[indexPath.row];
        
        
        cell.textLabel.text = dic[@"name"];
    }
    cell.textLabel.textColor = kColorMajor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.resultTableView) {
        AMapTip *tip = self.tips[indexPath.row];
//        [self returnMapView:tip.name and:SearchTypePOI];
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%@&slon=%@&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=2",@"YiToOnline", [SocketManager sharedSocket].baseModel.lat , [SocketManager sharedSocket].baseModel.lng,@"我的位置", tip.location.latitude, tip.location.longitude, tip.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
        NSArray *arr= [Common getAsynchronousWithKey:kSearchHistory];
        NSMutableArray *historyArr = [NSMutableArray arrayWithArray:arr];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"name"] = tip.name;
        dic[@"lat"] = [NSString stringWithFormat:@"%f", tip.location.latitude];
        dic[@"lng"] = [NSString stringWithFormat:@"%f", tip.location.longitude];
        [historyArr addObject:dic];
        [Common setAsynchronous:historyArr WithKey:kSearchHistory];
        
    } else {
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic = self.historyArr[indexPath.row];
        
        
        if (dic[@"lat"] !=nil && dic[@"lng"] != nil) {
            float lat = [[dic valueForKey:@"lat"] floatValue];
            float lng = [[dic valueForKey:@"lng"] floatValue];
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%@&slon=%@&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=2",@"YiToOnline", [SocketManager sharedSocket].baseModel.lat , [SocketManager sharedSocket].baseModel.lng,@"我的位置", lat , lng, dic[@"name"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        else {
            [self returnMapView:dic[@"name"] and:SearchTypeNear];
        }
        
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.search.showsCancelButton = NO;
    [self.search resignFirstResponder];
}
#pragma mark - UISearchBar Delegate
/* 取消按钮点击 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.search.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    self.tableView.hidden = NO;
    self.resultTableView.hidden = YES;
}
/* 搜索按钮点击 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.search.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [self returnMapView:searchBar.text and:SearchTypeNear];
    
    NSArray *arr= [Common getAsynchronousWithKey:kSearchHistory];
    NSMutableArray *historyArr = [NSMutableArray arrayWithArray:arr];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"name"] = searchBar.text;
    [historyArr addObject:dic];
    [Common setAsynchronous:historyArr WithKey:kSearchHistory];
}
/* 开始编辑 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.search.showsCancelButton = YES;
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancleBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    return YES;
}

//搜索框内容发生改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.tableView.hidden = NO;
        self.resultTableView.hidden = YES;
    }else {
        self.tableView.hidden = YES;
        self.resultTableView.hidden = NO;
        [self searchTipsWithKey:searchText];
    }
}
#pragma mark - Lazy Load

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 80, 30)];//allocate titleView
        
        [_titleView setBackgroundColor:[UIColor clearColor]];
        
        _search = [[UISearchBar alloc] init];
        _search.delegate = self;
        _search.frame = CGRectMake(0, 0, kMainScreenWidth - 80, 30);
        _search.layer.cornerRadius = 6;
        _search.layer.masksToBounds = YES;
        [_search.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
        [_search setTintColor:RGBColor(248, 117, 69)];
        
        [_search setBackgroundImage:[UIImage imageNamed:@"bg_nav"]];
        _search.placeholder = @"请输入要搜索的景区";
        
        
        
        [_titleView addSubview:_search];
        _titleView.clipsToBounds = YES;
        
        //Set to titleView
        self.navigationItem.titleView = _titleView;
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 200)];
        topView.backgroundColor = kColorWhite;
        
        [self addTypeInView:topView];
        
        
        _tableView.tableHeaderView = topView;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UITableView *)resultTableView {
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        
        [self.view addSubview:_resultTableView];
        _resultTableView.hidden = YES;
    }
    return _resultTableView;
}

- (NSMutableArray *)tips {
    if (!_tips) {
        _tips = [[NSMutableArray alloc] init];
    }
    return _tips;
}

- (NSMutableArray *)historyArr {
    if (!_historyArr) {
        _historyArr = [[NSMutableArray alloc] init];
    }
    return _historyArr;
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
