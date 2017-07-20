//
//  ComplainViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/22.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ComplainViewController.h"
#import "SocketManager.h"
#import "ComplainTableViewCell.h"
#import "ComplainModel.h"
#import "CompTableViewCell.h"
#import "NoReplyTableViewCell.h"

@interface ComplainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *complainArr;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageCount;
@end

@implementation ComplainViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的投诉";
    self.view.backgroundColor = RGBColor(222, 222, 222);
    
    [self tableView];
    [self headView];
    [self loadComplain];
//    [self.tableView registerClass:[ComplainTableViewCell class] forCellReuseIdentifier:@"ComplainTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CompTableViewCell" bundle:nil] forCellReuseIdentifier:@"CompTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoReplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoReplyTableViewCell"];
    // Do any additional setup after loading the view.
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadComplainMore];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - Method
//获取投诉信息
- (void)loadComplain {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"numberId"] = [SocketManager sharedSocket].baseModel.ID;
    self.page = 1;
    self.pageCount = 10;
    [params setObject:@(self.page) forKey:@"page"];
    [params setObject:@(self.pageCount) forKey:@"pagecount"];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_getComplaintsid parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.complainArr removeAllObjects];
                for (NSDictionary *dic in jsonData[@"result"]) {
                    ComplainModel *model = [ComplainModel parse:dic];
                    [self.complainArr addObject:model];
                }
                [self.tableView reloadData];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

- (void)loadComplainMore {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"numberId"] = [SocketManager sharedSocket].baseModel.ID;
    self.page += 1;
    [params setObject:@(self.page) forKey:@"page"];
    [params setObject:@(self.pageCount) forKey:@"pagecount"];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_getComplaintsid parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
//                [self.complainArr removeAllObjects];
                for (NSDictionary *dic in jsonData[@"result"]) {
                    ComplainModel *model = [ComplainModel parse:dic];
                    [self.complainArr addObject:model];
                }
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing]; 
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

//提交投诉
- (void)commitComplain {
    if ([Common content:self.textView.text] > 60) {
        [AlertManager alertMessage:@"请输入少于60字"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"complaints"] = self.textView.text;
    params[@"userid"] = [SocketManager sharedSocket].baseModel.ID;
    params[@"complaintstime"] = [Common formatWithDate];
//    params[@"scenicspotid"] = [SocketManager sharedSocket].baseModel.scenicspotsid;
    params[@"scenicspotid"] = [NSString stringWithFormat:@"%ld", (long)self.scenicspotid];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_setComplaintsid parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [AlertManager toastMessage:@"投诉成功" inView:self.view];
                [self loadComplain];
                [self.view endEditing:YES];
                self.textView.text = @"";
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

- (void)hiddenBoard {
    [self.textView resignFirstResponder];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 200;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.complainArr != nil) {
        return self.complainArr.count;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.complainArr != nil) {
//        return self.complainArr.count;
//    }
//    return 0;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComplainModel *model = self.complainArr[indexPath.section];
    if (model.state) {
        static NSString *identifier = @"CompTableViewCell";
        CompTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [cell setCellContent:self.complainArr[indexPath.section]];
        return cell;
    }else {
        static NSString *identifier = @"NoReplyTableViewCell";
        NoReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [cell setCellContent:self.complainArr[indexPath.section]];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 30, 10)];
//    myView.backgroundColor = RGBColor(222, 222, 222);
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma mark - Lazy Load
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 30, 360)];
        _headView.backgroundColor = RGBColor(222, 222, 222);
        
        UILabel *titleLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 120, 20)];
        titleLab1.text = @"投诉描述";
        titleLab1.textColor = RGBColor(120, 120, 120);
        [_headView addSubview:titleLab1];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0,titleLab1.bottom + 10, kMainScreenWidth - 30, 200)];
        _textView.backgroundColor = kColorWhite;
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textColor = kColorMajor;
        _textView.layer.cornerRadius = 10;
        [_headView addSubview:_textView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,_textView.bottom +  20, kMainScreenWidth - 30, 50)];
        button.backgroundColor = kColorWhite;
        button.layer.cornerRadius = 10;
        [button setTitle:@"提交投诉" forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(248, 117, 69) forState:UIControlStateNormal];
        [_headView addSubview:button];
        [button addTarget:self action:@selector(commitComplain) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, button.bottom + 15, 120, 20)];
        titleLab2.text = @"历史投诉";
        titleLab2.textColor = RGBColor(120, 120, 120);
        [_headView addSubview:titleLab2];
        
//        [self.view addSubview:_headView];
        _tableView.tableHeaderView = _headView;
    }
    return _headView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 0, kMainScreenWidth - 30, kMainScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBoard)]];
        
        [self.view addSubview: _tableView];
    }
    return _tableView;
}

- (NSMutableArray *)complainArr {
    if (!_complainArr) {
        _complainArr = [NSMutableArray new];
    }
    return _complainArr;
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
