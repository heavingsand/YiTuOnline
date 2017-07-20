//
//  HelpAndFeedbackViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/31.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"

@interface HelpAndFeedbackViewController ()
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation HelpAndFeedbackViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助与反馈";
    self.view.backgroundColor = kColorBg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.commitBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
- (void)commitBtnClick {
    [AlertManager toastMessage:@"投诉成功" inView:self.view];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Lazy Load
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _commitBtn.size = CGSizeMake(40, 40);
        [_commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) textContainer:nil];
        //检测到电话,邮箱等自动高亮
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _textView;
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
