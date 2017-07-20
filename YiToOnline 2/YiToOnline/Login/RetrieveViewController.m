//
//  RetrieveViewController.m
//  YiToOnline
//
//  Created by 吴迪 on 16/9/19.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "RetrieveViewController.h"
#import "LoginViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RetrieveViewController ()
@property(nonatomic, strong) UIView *phoneView, *verCodeView, *passView, *surePassView, *mainView;
@property(nonatomic, strong) UITextField *phoneField, *verCodeField, *PassField, *surePassField;
@property(nonatomic, strong) UIButton *submitBtn;
@end

@implementation RetrieveViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.layer.contents = (id)[UIImage imageNamed:@"registerBackground"].CGImage;
    self.title = @"找回密码";
    self.view.backgroundColor = kColorBg;
    
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    
//    [self phoneField];
//    [self verCodeField];
//    [self PassField];
//    [self surePassField];
    [self mainView];
    [self submitBtn];
    
//    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
//    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
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

//- (void)keyboardWillShowOrHide:(NSNotification *)notification
//{
//    //获取通知名
//    NSString *notificationName = notification.name;
//    
//    //获取通知内容
//    NSDictionary *keyboardInfo = notification.userInfo;
//    
//    
//    //键盘弹出时，让画面整体稍稍上移，并伴随动画
//    //键盘回收时反之
//    
//    //    NSLog(@"keyboardInfo: %@", keyboardInfo);
//    
//    
//    //动画结束后self.view的frame值
//    CGRect selfViewFrame = [[UIScreen mainScreen] bounds];
//    
//    
//    //通过通知名字判断弹出还是回收
//    if ([notificationName isEqualToString:UIKeyboardWillShowNotification]) {
//        selfViewFrame.origin.y = -60;
//    }
//    else {
//        selfViewFrame.origin.y = 60;
//    }
//    
//    //取出动画时长
//    NSTimeInterval duration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //使用动画更改self.view.frame
//    [UIView animateWithDuration:duration animations:^{
//        //这里填入一些view的最终状态属性设置，即会自动产生过渡动画
//        self.view.frame = selfViewFrame;
//    }];
//}

-(UIView *)addWhiteViewWithFrame:(CGRect)frame
{
    UIView *whiteView = [[UIView alloc] initWithFrame:frame];
    whiteView.backgroundColor = [UIColor blackColor];
    whiteView.alpha = 0.3;
    [whiteView setBorderColor:kColorLine width:.5 cornerRadius:8];
    [self.view addSubview:whiteView];
    return whiteView;
}

-(UITextField *)addTextFieldWithView:(UIView *)whiteView andText: (NSString *)text
{
    UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, kMainScreenWidth-50, 40)];
    passField.textColor = kColorWhite;
    
    UIColor *color = [UIColor whiteColor];
    passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
    passField.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:passField];
    return passField;
}

- (UILabel *)addLabelWithFrame:(CGRect)frame andText:(NSString *)text {
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:frame];
    phoneLab.text = text;
    phoneLab.textColor = RGBColor(66, 66, 66);
    phoneLab.adjustsFontSizeToFitWidth = YES;
    phoneLab.font = [UIFont systemFontOfSize:19];
    return phoneLab;
}

- (UITextField *)addTextFieldWithFrame:(CGRect)frame addText:(NSString *)text {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = kColorMajor;
    textField.placeholder = text;
    return textField;
}

//获取验证码
- (void)getVerCode {
    if ([Common judgeMobileNumber:self.phoneField.text]) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:[NSString stringWithFormat:@"%@", self.phoneField.text] zone:@"86" customIdentifier:nil result:^(NSError *error) {
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

//提交
- (void)submit {
    if (self.phoneField.text.length == 0) {
        [AlertManager alertMessage:@"请输入手机号"];
        return;
    }
    if (self.verCodeField.text.length == 0) {
        [AlertManager alertMessage:@"请输入验证码"];
        return;
    }
    if (![self judgePassword:self.PassField.text]) {
        [AlertManager alertMessage:@"请输入5-11位密码"];
        return;
    }
    if (![self.PassField.text isEqualToString:self.surePassField.text]) {
        [AlertManager alertMessage:@"两次密码输入不一致"];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appkey"] = kMOBApp;
    params[@"code"] = self.verCodeField.text;
    params[@"username"] = self.phoneField.text;
    params[@"password"] = self.PassField.text;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ForgotPassword parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [AlertManager toastSuccessMessage:@"修改成功" inView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if ([jsonData[@"resultnumber"]intValue] == 202) {
                [AlertManager alertMessage:@"验证码错误"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 208) {
                [AlertManager alertMessage:@"没有此用户"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 209) {
                [AlertManager alertMessage:@"修改密码失败"];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

//密码长度验证
- (BOOL)judgePassword:(NSString *)password{
    if ([password length] > 4 && [password length] < 12) {
        return YES;
    } else{
        return NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - Lazy Load
//- (UITextField *)phoneField {
//    if (!_phoneField) {
//        _phoneView = [self addWhiteViewWithFrame:CGRectMake(25, kMainScreenHeight * 0.33, kMainScreenWidth - 50, 40)];
//        _phoneField = [self addTextFieldWithView:_phoneView andText:@"请输入手机号"];
//        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
//    }
//    return  _phoneField;
//}
//
//
//- (UITextField *)verCodeField {
//    if (!_verCodeField) {
//        _verCodeView = [self addWhiteViewWithFrame:CGRectMake(25, _phoneView.bottom + 16, kMainScreenWidth - 50, 40)];
//        _verCodeField = [self addTextFieldWithView:_verCodeView andText:@"请输入验证码"];
//        _verCodeField.keyboardType = UIKeyboardTypeNumberPad;
//        UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verCodeView.width-97, 0, 97, 40)];
//        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [codeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
//        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [codeBtn addTarget:self action:@selector(getVerCode) forControlEvents:UIControlEventTouchUpInside];
//        [_verCodeView addSubview:codeBtn];
//        [_verCodeView addSubview:[Common lineViewWithFrame:CGRectMake(_verCodeView.width-97, 0, 1, 40)]];
//    }
//    return _verCodeField;
//}
//
//- (UITextField *)PassField {
//    if (!_PassField) {
//        _passView = [self addWhiteViewWithFrame:CGRectMake(25, _verCodeView.bottom + 16, kMainScreenWidth - 50, 40)];
//        _PassField = [self addTextFieldWithView:_passView andText:@"请输入新密码"];
//    }
//    return _PassField;
//}
//
//- (UITextField *)surePassField {
//    if (!_surePassField) {
//        _surePassView = [self addWhiteViewWithFrame:CGRectMake(25, _passView.bottom + 16, kMainScreenWidth - 50, 40)];
//        _surePassField = [self addTextFieldWithView:_surePassView andText:@"请确认密码"];
//    }
//    return _surePassField;
//}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, _mainView.bottom + 20, kMainScreenWidth - 50, 50)];
        _submitBtn.backgroundColor = RGBColor(248, 117, 69);
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.layer.cornerRadius = 6;
        [_submitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 220)];
        _mainView.backgroundColor = kColorWhite;
        _mainView.layer.cornerRadius = 6;
        [self.view addSubview:_mainView];
        //手机号
        UILabel *phoneLab = [self addLabelWithFrame:CGRectMake(10, 0, 80, 55) andText:@"手机号 "];
        [_mainView addSubview:phoneLab];
        _phoneField = [self addTextFieldWithFrame:CGRectMake(phoneLab.right, 0, _mainView.width - phoneLab.width, 55) addText:@"请输入手机号"];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [_mainView addSubview:_phoneField];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 54, _mainView.width - 20, 1)];
        lineView.backgroundColor = RGBColor(241, 241, 241);
        [_mainView addSubview:lineView];
        
        //验证码
        UILabel *verCodeLab = [self addLabelWithFrame:CGRectMake(10, 55, 80, 55) andText:@"验证码 "];
        [_mainView addSubview:verCodeLab];
        _verCodeField = [self addTextFieldWithFrame:CGRectMake(verCodeLab.right, 55, _mainView.width - verCodeLab.width - 100, 55) addText:@"请输入验证码"];
        _verCodeField.keyboardType = UIKeyboardTypeNumberPad;
        [_mainView addSubview:_verCodeField];
        UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verCodeField.right, 65, 80, 35)];
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [codeBtn addTarget:self action:@selector(getVerCode) forControlEvents:UIControlEventTouchUpInside];
        codeBtn.backgroundColor = RGBColor(248, 117, 69);
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        codeBtn.layer.cornerRadius = 5;
        [_mainView addSubview:codeBtn];
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 109, _mainView.width - 20, 1)];
        lineView1.backgroundColor = RGBColor(241, 241, 241);
        [_mainView addSubview:lineView1];
        
        //密码
        UILabel *PassLab = [self addLabelWithFrame:CGRectMake(10, 110, 80, 55) andText:@"输入密码 "];
        [_mainView addSubview:PassLab];
        _PassField = [self addTextFieldWithFrame:CGRectMake(PassLab.right, 110, _mainView.width - PassLab.width, 55) addText:@"请输入新密码"];
        [_mainView addSubview:_PassField];
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, 164, _mainView.width - 20, 1)];
        lineView2.backgroundColor = RGBColor(241, 241, 241);
        [_mainView addSubview:lineView2];
        //确认密码
        UILabel *surePassLab = [self addLabelWithFrame:CGRectMake(10, 165, 80, 55) andText:@"确认密码 "];
        [_mainView addSubview:surePassLab];
        _surePassField = [self addTextFieldWithFrame:CGRectMake(surePassLab.right, 165, _mainView.width - surePassLab.width, 55) addText:@"请确认密码"];
        [_mainView addSubview:_surePassField];
        
    }
    return _mainView;
}

//- (void)dealloc {
//    [kNotificationCenter removeObserver:self];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
