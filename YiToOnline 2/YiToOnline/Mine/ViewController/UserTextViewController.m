//
//  UserTextViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/14.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "UserTextViewController.h"

@interface UserTextViewController ()
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation UserTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBg;
    self.title = @"个人资料";
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, kMainScreenWidth - 40, 40)];
    self.textField.backgroundColor = kColorWhite;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.textColor = kColorMajor;
    self.textField.layer.cornerRadius = 5;
    [self.view addSubview:self.textField];
    self.textField.text = self.userString;
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
/*返回信息*/
- (void)returnUserDate {
    if (self.textFieldBlock) {
        self.textFieldBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Lazy Load
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _rightBtn.size = CGSizeMake(40, 40);
        [_rightBtn addTarget:self action:@selector(returnUserDate) forControlEvents:UIControlEventTouchUpInside];
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
