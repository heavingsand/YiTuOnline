//
//  ResetPassViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/13.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ResetPassViewController.h"
#import "ResetPassTableViewCell.h"
#import <SMS_SDK/SMSSDK.h>
#import "SocketManager.h"

@interface ResetPassViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton  *rightBtn;
@property (nonatomic, copy) NSString *codeStr;
@property (nonatomic, strong) ResetPassTableViewCell *cell;
@property (nonatomic, strong) ResetPassTableViewCell *passCell;
@end

@implementation ResetPassViewController
#define kMenuArr @[@[@"手机号 :",@"验证码 :"],@[@"新密码 :",@"确认密码 :"]]
#define kHeadTitle @[@"请输入手机进行短信验证",@"更改密码"]

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    self.title = @"修改密码";
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    [self tableView];
    [self.tableView registerClass:[ResetPassTableViewCell class] forCellReuseIdentifier:@"ResetPassTableViewCell"];
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
//完成修改
- (void)finishResetPass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"username"] = [SocketManager sharedSocket].baseModel.phonenumber;
    params[@"password"] = [Common getAsynchronousWithKey:@"password"];;
    params[@"newPassword"] = self.passCell.textField.text;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ModificationPassword parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
//获取验证码
- (void)getVerCode {
    if ([Common judgeMobileNumber:self.cell.textField.text]) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:[NSString stringWithFormat:@"%@", self.cell.textField.text] zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                NSLog(@"获取验证码成功");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"获取验证码成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
                
            } else {
                NSLog(@"错误信息：%@",error);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"获取验证码失败" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
                
            }
        }];
    } else {
        [AlertManager alertMessage:@"请输入正确的手机号"];
    }
}
#pragma mark - UITableView Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:tableView.frame];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.text = kHeadTitle[section];
    lable.textColor = RGBColor(133, 133, 133);
    lable.font = [UIFont systemFontOfSize:14];
    [view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 80, 30));
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ResetPassTableViewCell";
    ResetPassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[ResetPassTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setText:kMenuArr[indexPath.section][indexPath.row]];
    if (indexPath.row == 0) {
        cell.lineView.hidden = NO;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.cell = cell;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.codeBtn.hidden = NO;
//         __weak typeof(ResetPassTableViewCell) *weakCell = cell;
        [cell setCodeBtnBlock:^{
            [self getVerCode];
        }];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        self.passCell = cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tableView endEditing:YES];
}
#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _rightBtn.size = CGSizeMake(40, 40);
        [_rightBtn addTarget:self action:@selector(finishResetPass) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
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
