//
//  SOSResultViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/9.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "SOSResultViewController.h"
#import "HelpSocketManager.h"


#define kMainArr @[@"游客昵称 : ",@"游客联系方式 : ",@"受理人 : ",@"受理人电话 : ",@"求助时间 : ",@"处理完成时间 : "]

@interface SOSResultViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation SOSResultViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游客求助";
    self.view.backgroundColor = kColorBg;
    
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.

    
    for (int i = 0; i < 6; i ++) {
        if (i % 2 == 0) {
            UILabel *label = [self addLableWithFrame:CGRectMake(20, 20 + 40 * i, 0, 20) andText:kMainArr[i]];
            [self.view addSubview:label];
            UILabel *label2 = [self addLableWithFrame2:CGRectMake(label.right, 20 + 40 * i, kMainScreenWidth - label.width - 30, 20) andText:self.mainArr[i]];
            [self.view addSubview:label2];
        }else {
            UILabel *label = [self addLableWithFrame:CGRectMake(20, 20 + 40 * (i - 1)  + 25, 0, 20) andText:kMainArr[i]];
            [self.view addSubview:label];
            UILabel *label2 = [self addLableWithFrame2:CGRectMake(label.right, 20 + 40 * (i - 1)  + 25, kMainScreenWidth - label.width - 30, 20) andText:self.mainArr[i]];
            [self.view addSubview:label2];
        }
        
    }
    
    UILabel *label = [self addLableWithFrame:CGRectMake(20, 250, 100, 20) andText:@"求助原因"];
    [self.view addSubview:label];
    
    UITextView *textView = self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, label.bottom + 20, kMainScreenWidth - 40, 150)];
    textView.font = [UIFont systemFontOfSize:13];
    textView.layer.cornerRadius = 4;
    [self.view addSubview:textView];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, textView.bottom + 20, (kMainScreenWidth - 60)/2, 45)];
    submitBtn.backgroundColor = RGBColor(248, 117, 69);
    submitBtn.layer.cornerRadius = 4;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(submitBtn.right + 20, textView.bottom + 20, (kMainScreenWidth - 60)/2, 45)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:kColorMajor forState:UIControlStateNormal];
    resetBtn.layer.cornerRadius = 4;
    resetBtn.backgroundColor = kColorWhite;
    [self.view addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //键盘通知
    //    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}
#pragma mark - Method
/*返回上一级控制器*/
- (void)returnLaststageVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)addLableWithFrame:(CGRect)frame andText:(NSString *)text {
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = kColorMajor;
    lable.font = [UIFont systemFontOfSize:18];
    [lable sizeToFit];
    return lable;
}

- (UILabel *)addLableWithFrame2:(CGRect)frame andText:(NSString *)text {
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = RGBColor(248, 117, 69);
    lable.font = [UIFont systemFontOfSize:20];
    lable.adjustsFontSizeToFitWidth = YES;
    [lable sizeToFit];
    return lable;
}

- (void)resetBtnClick {
    self.textView.text = @"";
}

- (void)submitBtnClick {
    NSString *msg = @"end";
    [[HelpSocketManager sharedSocket].asyncSocket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:200];
    [self returnLaststageVC];
    if (self.SOSBtnBlock) {
        self.SOSBtnBlock();
    }
}

#pragma mark - 键盘通知回调
- (void)keyboardWillShowOrHide:(NSNotification *)notification
{
    //获取通知名
    NSString *notificationName = notification.name;
    
    //获取通知内容
    NSDictionary *keyboardInfo = notification.userInfo;
    
    
    //键盘弹出时，让画面整体稍稍上移，并伴随动画
    //键盘回收时反之
    
    //    NSLog(@"keyboardInfo: %@", keyboardInfo);
    
    
    //动画结束后self.view的frame值
    CGRect selfViewFrame = self.view.frame;
    
    
    //通过通知名字判断弹出还是回收
    if ([notificationName isEqualToString:UIKeyboardWillShowNotification]) {
        selfViewFrame.origin.y = -160;
    }
    else {
        selfViewFrame.origin.y = 0;
    }
    
    //取出动画时长
    NSTimeInterval duration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //使用动画更改self.view.frame
    [UIView animateWithDuration:duration animations:^{
        //这里填入一些view的最终状态属性设置，即会自动产生过渡动画
        self.view.frame = selfViewFrame;
    }];
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
