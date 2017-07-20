//
//  NotiViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/6.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "NotiViewController.h"
#import "SocketManager.h"
#import "NotiTableViewCell.h"
#import "NotiDetailViewController.h"

@interface NotiViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notiArr;
@end

@implementation NotiViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知中心";
//    self.title = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
    self.view.backgroundColor = kColorBg;
    
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self tableView];
    [self.tableView registerClass:[NotiTableViewCell class] forCellReuseIdentifier:@"NotiTableViewCell"];
    [self getNotiContent];
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

/*  获取通知内容 */
- (void)getNotiContent {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"numberId"] = [SocketManager sharedSocket].baseModel.ID;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ObtainPush parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                self.notiArr = jsonData[@"result"];
                [self.tableView reloadData];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
#pragma mark - UITableView Delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notiArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"NotiTableViewCell";
    NotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[NotiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    NSDictionary *dic = self.notiArr[indexPath.row];
    [cell setTitle:dic[@"title"] andSubtitle:dic[@"description"] andTime:dic[@"pushDateTime"]];
    if (indexPath.row < self.notiNumber) {
        cell.redPoint.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.notiArr[indexPath.row];
    NotiDetailViewController *jumpVc = [[NotiDetailViewController alloc] init];
    jumpVc.urlString = dic[@"url"];
    [self.navigationController pushViewController:jumpVc animated:YES];
}
#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)notiArr {
    if (!_notiArr) {
        _notiArr = [NSMutableArray new];
    }
    return _notiArr;
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
