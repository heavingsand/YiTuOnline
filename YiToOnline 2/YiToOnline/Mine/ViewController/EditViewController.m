//
//  EditViewController.m
//  YiToOnline
//
//  Created by 吴迪 on 16/9/10.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "EditViewController.h"
#import "EditTableViewCell.h"
#import "ResetPassViewController.h"
#import "UserDataViewController.h"
#import "SocketManager.h"
#import "HelpSocketManager.h"
#import "LoginViewController.h"
#import "HelpAndFeedbackViewController.h"
#import "AboutViewController.h"

@interface EditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView   *tableView;
@end

@implementation EditViewController

#define kMenuArray @[@[@"账户与安全",@"修改资料"],@[@"通用设置"],@[@"帮助与反馈",@"关于逸途"]]

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    self.title = @"设置";
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self tableView];
    [self.tableView registerClass:[EditTableViewCell class] forCellReuseIdentifier:@"EditTableViewCell"];
    
    [self loadUserData];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 20, kMainScreenWidth-32, 50)];
    loginBtn.backgroundColor = RGBColor(248, 117, 69);
    loginBtn.layer.cornerRadius = 5;
    [loginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginBtn];
    self.tableView.tableFooterView = view;
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
/* 加载个人资料 */
- (void)loadUserData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"numberId"] = [SocketManager sharedSocket].baseModel.ID;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ReadUserInformation parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [SocketManager sharedSocket].baseModel.travelmodes = [NSString stringWithFormat:@"%@",jsonData[@"result"][@"travelmodes"]];
                [SocketManager sharedSocket].baseModel.sex = [NSString stringWithFormat:@"%@",jsonData[@"result"][@"sex"]];
                [SocketManager sharedSocket].baseModel.age = [NSString stringWithFormat:@"%@",jsonData[@"result"][@"age"]];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
/* 退出登录 */
- (void)logout {
//    [self.navigationController presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
    [AlertManager toastSuccessMessage:@"退出登录成功" inView:kMainWindow];
//    [SocketManager sharedSocket].baseModel = nil;
    [[SocketManager sharedSocket] disconnectedSocket];
    [[HelpSocketManager sharedSocket] disconnectedSocket];
    [Common clearAsynchronousWithKey:@"ID"];
    [Common clearAsynchronousWithKey:@"password"];
    [SocketManager sharedSocket].isLogin = NO;
    [SocketManager sharedSocket].isNoFirst = NO;
    
    UINavigationController *selectNavVC = (UINavigationController *)self.tabBarController.selectedViewController;
    if (selectNavVC.presentedViewController) {
        selectNavVC = (UINavigationController *)selectNavVC.presentedViewController;
    }
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [Common setUpNavBar:navVC.navigationBar];
    [selectNavVC presentViewController:navVC animated:YES completion:nil];
    
}
#pragma mark - UITableView Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kMenuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[kMenuArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MineTableViewCell";
    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[EditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setText:kMenuArray[indexPath.section][indexPath.row]];
    if ((indexPath.section == 0 && indexPath.row ==0) || (indexPath.section == 2 && indexPath.row ==0)) {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //账户与安全
    if (indexPath.section == 0 && indexPath.row == 0) {
        ResetPassViewController *jumpVC = [[ResetPassViewController alloc] init];
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    //修改资料
    if (indexPath.section == 0 && indexPath.row == 1) {
        UserDataViewController *jumpVC = [[UserDataViewController alloc] init];
        jumpVC.rightArr = @[@[[SocketManager sharedSocket].baseModel.headImg,[SocketManager sharedSocket].baseModel.name,[SocketManager sharedSocket].baseModel.travelmodes],@[[SocketManager sharedSocket].baseModel.sex,[SocketManager sharedSocket].baseModel.age]];
        jumpVC.isstaff = [[SocketManager sharedSocket].baseModel.isstaff intValue];
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    //通用设置
    if (indexPath.section == 1 && indexPath.row == 0) {
        
    }
    //帮助与反馈
    if (indexPath.section == 2 && indexPath.row == 0) {
        HelpAndFeedbackViewController *jumpVc = [[HelpAndFeedbackViewController alloc] init];
        [self.navigationController pushViewController:jumpVc animated:YES];
    }
    //关于逸途
    if (indexPath.section == 2 && indexPath.row == 1) {
        AboutViewController *jumpVc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:jumpVc animated:YES];
    }
}
#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 112) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
