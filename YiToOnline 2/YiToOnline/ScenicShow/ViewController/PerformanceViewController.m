//
//  PerformanceViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "PerformanceViewController.h"
#import "PreformanceTableViewCell.h"

@interface PerformanceViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *performanceArr;
@end

@implementation PerformanceViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"PreformanceTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"PreformanceTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPerformance];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
- (void)loadPerformance {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"scenicspotsid"] = [NSString stringWithFormat:@"%ld",self.scenicspotsid];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ScIdGetShow parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.performanceArr removeAllObjects];
                for (NSDictionary *dic in jsonData[@"result"]) {
                    PerformanceModel *model = [PerformanceModel parse:dic];
                    [self.performanceArr addObject:model];
                }
                [self.tableView reloadData];
            }
            [self.tableView.mj_header endRefreshing];
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.performanceArr != nil) {
        return self.performanceArr.count;
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
    static NSString *identifier = @"PreformanceTableViewCell";
    PreformanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setCellContent:self.performanceArr[indexPath.row]];
    return cell;
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)performanceArr {
    if (!_performanceArr) {
        _performanceArr = [NSMutableArray new];
    }
    return _performanceArr;
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
