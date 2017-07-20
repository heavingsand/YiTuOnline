//
//  RegisterViewController.m
//  YiToOnline
//
//  Created by 吴迪 on 16/9/19.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import <AFNetworking.h>
#import <SMS_SDK/SMSSDK.h>

@interface RegisterViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *phoneField, *verCodeField, *passField, *surePassField, *nickNameField,*invitationCodeField;
@property(nonatomic, strong) UISwitch *isStaff;
@property (nonatomic, strong) UIView *mainView1, *mainView2;
@end

@implementation RegisterViewController

#define kLeftArr @[@"手机号 ",@"验证码 ",@"输入密码 ",@"确认密码 ",@"昵称 "]

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册账号";
    self.view.backgroundColor = kColorBg;
    
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self creatRegisterData];
}
#pragma mark - Method
/*返回上一级控制器*/
- (void)returnLaststageVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatRegisterData{
    [self mainView1];
    
    /*******************/
//    UIView *phoneView = [self addWhiteViewWithFrame:CGRectMake(25, kMainScreenHeight * 0.33, kMainScreenWidth-50, 40)];
//    UITextField *phoneField = self.phoneField = [self addTextFieldWithView:phoneView andText:@"请输入注册手机号"];
//    phoneField.keyboardType = UIKeyboardTypeNumberPad;
//    
//    UIView *verCodeView = [self addWhiteViewWithFrame:CGRectMake(25, phoneView.bottom + 16 , kMainScreenWidth-50, 40)];
//    UITextField *verCodeField = self.verCodeField = [self addTextFieldWithView:verCodeView andText:@"请输入验证码"];
//    verCodeField.keyboardType = UIKeyboardTypeNumberPad;
//    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(verCodeView.width-97, 0, 97, 40)];
//    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [codeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
//    codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [codeBtn addTarget:self action:@selector(clickVerificationBtn) forControlEvents:UIControlEventTouchUpInside];
//    [verCodeView addSubview:codeBtn];
//    [verCodeView addSubview:[Common lineViewWithFrame:CGRectMake(verCodeView.width-97, 0, 1, 40)]];
//    
//    UIView *passView = [self addWhiteViewWithFrame:CGRectMake(25, verCodeView.bottom + 16, kMainScreenWidth-50, 40)];
//    UITextField *passField = self.passField = [self addTextFieldWithView:passView andText:@"请输入密码"];
//    passField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    
//    UIView *surePassView = [self addWhiteViewWithFrame:CGRectMake(25, passView.bottom + 16, kMainScreenWidth-50, 40)];
//    UITextField *surePassField = self.surePassField = [self addTextFieldWithView:surePassView andText:@"请确认密码"];
//    surePassField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    UILabel *isStaffLb = [[UILabel alloc] initWithFrame:CGRectMake(37, self.mainView1.bottom + 10, 160, 40)];
    isStaffLb.text = @"是否为工作人员 : ";
    isStaffLb.textColor = kColorMajor;
    isStaffLb.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:isStaffLb];
    
    UISwitch *isStaff = self.isStaff = [[UISwitch alloc] initWithFrame:CGRectMake(self.mainView1.right - 60, self.mainView1.bottom + 16, 0, 0)];
    [isStaff addTarget:self action:@selector(changeEnable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:isStaff];
    
//    UIView *invitationCodeView = [self addWhiteViewWithFrame:CGRectMake(25, isStaffLb.bottom + 16, kMainScreenWidth - 50, 40)];
//    UITextField *invitationCodeField = self.invitationCodeField = [self addTextFieldWithView:invitationCodeView andText:@"工作人员请输入邀请码"];
//    invitationCodeField.keyboardType = UIKeyboardTypeNumberPad;
//    invitationCodeField.userInteractionEnabled = NO;
    [self mainView2];
    
    //键盘通知
//    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
//    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, self.mainView2.bottom + 15, kMainScreenWidth - 50, 50)];
    registerBtn.backgroundColor = RGBColor(248, 117, 69);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 6;
    [registerBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    /*******************/
    
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
        selfViewFrame.origin.y = -120;
    }
    else {
        selfViewFrame.origin.y = 64;
    }
    
    //取出动画时长
    NSTimeInterval duration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //使用动画更改self.view.frame
    [UIView animateWithDuration:duration animations:^{
        //这里填入一些view的最终状态属性设置，即会自动产生过渡动画
        self.view.frame = selfViewFrame;
    }];
}

- (void)changeEnable {
    self.invitationCodeField.userInteractionEnabled = self.isStaff.isOn;
}

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
//- (void)creatRegisterBtn{
//    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    registerBtn.frame = CGRectMake(WIDTH * 0.32, HEIGHT * 0.6, WIDTH * 0.38, HEIGHT * 0.05);
//    [registerBtn setBackgroundImage:[UIImage imageNamed:@"registerUserBtn"] forState:UIControlStateNormal];
//    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
//    registerBtn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:registerBtn];
//}

//- (void)creatVerificationBtn{
//    UIButton *verificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    verificationBtn.frame = CGRectMake(WIDTH * 0.8, HEIGHT * 0.405, WIDTH * 0.15, HEIGHT * 0.04);
//    [verificationBtn setBackgroundImage:[UIImage imageNamed:@"verificationBtn"] forState:UIControlStateNormal];
//    [verificationBtn addTarget:self action:@selector(clickVerificationBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:verificationBtn];
//}

- (void)clickVerificationBtn{
    if ([self judgeMobileNumber:self.phoneField.text]) {
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

- (BOOL)judgeMobileNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

- (BOOL)judgePassword:(NSString *)password{
    if ([password length] > 4 && [password length] < 12) {
        return YES;
    } else{
        return NO;
    }
}

- (void)clickRegisterBtn{
    
    if ([self.passField.text isEqualToString:self.surePassField.text]) {
        
        [self sendData];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认密码错误" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
}

- (void)sendData{
    
    NSString *domainStr = kUrl_SetAccountNumber;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:[NSString stringWithFormat:@"%@", self.phoneField.text] forKey:@"username"];
    [parametersDic setObject:[NSString stringWithFormat:@"%@", self.passField.text] forKey:@"password"];
//    [parametersDic setObject:@"0" forKey:@"isstaff"];
    
    if (self.isStaff.isOn) {
        [parametersDic setObject:@"1" forKey:@"isstaff"];
        [parametersDic setObject:self.invitationCodeField.text forKey:@"randomnumber"];
    }else {
        [parametersDic setObject:@"0" forKey:@"isstaff"];
    }
    [parametersDic setObject:[NSString stringWithFormat:@"%@", self.nickNameField.text] forKey:@"nickName"];
    [parametersDic setObject:@"188a662a83c33" forKey:@"appkey"];
    [parametersDic setObject:[NSString stringWithFormat:@"%@", self.verCodeField.text] forKey:@"code"];
//    if (self.isStaff.isOn == YES) {
//        [parametersDic setObject:@"1" forKey:@"isstaff"];
//        [parametersDic setObject:self.invitationCodeField.text forKey:@"randomnumber"];
//    }
    
    if ([self judgeMobileNumber:[parametersDic objectForKey:@"username"]] == YES && [self judgePassword:[parametersDic objectForKey:@"password"]]) {
        [manager POST:domainStr parameters:parametersDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"成功");
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            
            if ([[response objectForKey:@"resultnumber"] integerValue] == 200) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
                
            } else if ([[response objectForKey:@"resultnumber"] integerValue] == 201){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"有参数为空" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            } else if ([[response objectForKey:@"resultnumber"] integerValue] == 202){
                NSLog(@"%@", [response objectForKey:@"result"] );
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            } else if ([[response objectForKey:@"resultnumber"] integerValue] == 203){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"此手机号码已注册" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            } else if ([[response objectForKey:@"resultnumber"] integerValue] == 204){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"未知错误" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"失败");
        }];
    } else {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"账号或密码格式错误" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [kNotificationCenter removeObserver:self];
}
#pragma mark - Lazy Load
- (UIView *)mainView1 {
    if (!_mainView1) {
        _mainView1 = [[UIView alloc] initWithFrame:CGRectMake(25, 25, kMainScreenWidth - 50, 275)];
        _mainView1.backgroundColor = kColorWhite;
        _mainView1.layer.cornerRadius = 6;
        [self.view addSubview:_mainView1];
        
        for (int i = 1; i < 5; i ++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 54 * i, _mainView1.width - 20, 1)];
            lineView.backgroundColor = RGBColor(241, 241, 241);
            [_mainView1 addSubview:lineView];
        }
        for (int i = 0; i < 5; i ++) {
            UILabel *leftLab = [self addLabelWithFrame:CGRectMake(10, 55 * i, 80, 55) andText:kLeftArr[i]];
            [_mainView1 addSubview:leftLab];
        }
        //手机号
        _phoneField = [self addTextFieldWithFrame:CGRectMake(90, 0, _mainView1.width - 100, 55) addText:@"请输入手机号"];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [_mainView1 addSubview:_phoneField];
        
        //验证码
        _verCodeField = [self addTextFieldWithFrame:CGRectMake(90, 55, _mainView1.width - 80 - 100, 55) addText:@"请输入验证码"];
        _verCodeField.keyboardType = UIKeyboardTypeNumberPad;
        [_mainView1 addSubview:_verCodeField];
        
        UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verCodeField.right, 65, 80, 35)];
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [codeBtn addTarget:self action:@selector(clickVerificationBtn) forControlEvents:UIControlEventTouchUpInside];
        codeBtn.backgroundColor = RGBColor(248, 117, 69);
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        codeBtn.layer.cornerRadius = 5;
        [_mainView1 addSubview:codeBtn];
        
        //密码
        _passField = [self addTextFieldWithFrame:CGRectMake(90, 110, _mainView1.width - 100, 55) addText:@"请输入密码"];
        [_mainView1 addSubview:_passField];
        _surePassField = [self addTextFieldWithFrame:CGRectMake(90, 165, _mainView1.width - 100, 55) addText:@"请确认密码"];
        [_mainView1 addSubview:_surePassField];
        //昵称
        _nickNameField = [self addTextFieldWithFrame:CGRectMake(90, 220, _mainView1.width - 100, 55) addText:@"请输入昵称"];
        [_mainView1 addSubview:_nickNameField];
    }
    return _mainView1;
}

- (UIView *)mainView2 {
    if (!_mainView2) {
        _mainView2 = [[UIView alloc] initWithFrame:CGRectMake(25, _isStaff.bottom + 10, kMainScreenWidth - 50, 55)];
        _mainView2.backgroundColor = kColorWhite;
        _mainView2.layer.cornerRadius = 6;
        [self.view addSubview:_mainView2];
        
        UILabel *leftLab = [self addLabelWithFrame:CGRectMake(10, 0, 80, 55) andText:@"邀请码"];
        [_mainView2 addSubview:leftLab];
        
        _invitationCodeField = [self addTextFieldWithFrame:CGRectMake(90, 0, _mainView2.width - 100, 55) addText:@"请输入邀请码"];
        _invitationCodeField.keyboardType = UIKeyboardTypeNumberPad;
        _invitationCodeField.userInteractionEnabled = NO;
        [_mainView2 addSubview:_invitationCodeField];
    }
    return _mainView2;
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
