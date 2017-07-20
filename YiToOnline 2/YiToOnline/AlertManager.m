//
//  AlertManager.m
//  HoneyLemon
//
//  Created by  on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "AlertManager.h"
#import "MBProgressHUD+Add.h"

@implementation AlertManager
{
    UIAlertView *currentAlert;
}

static AlertManager *alertManagerObj = NULL;

+ (AlertManager *)shared
{
	if (!alertManagerObj) {
		alertManagerObj = [[AlertManager alloc] init];
	}
	return alertManagerObj;
}
+ (void)alertWithTitle:(NSString *)title tag:(int)tag  message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    [[AlertManager shared] alert:title tag:tag message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
}

+ (void)alertNetworkError
{
    [[AlertManager shared] alert:@"似乎网络不太给力噢！"];
}

+ (void)alertMessage:(NSString *)message
{
    [[AlertManager shared] alert:message];
}

-(void)alert:(NSString *)message
{
    if (currentAlert && [currentAlert isKindOfClass:[UIAlertView class]]) {
        [currentAlert dismissWithClickedButtonIndex:0 animated:NO];
    }
    currentAlert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [currentAlert show];
}

- (void)alert:(NSString *)title tag:(int)tag  message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (currentAlert && [currentAlert isKindOfClass:[UIAlertView class]]) {
        [currentAlert dismissWithClickedButtonIndex:0 animated:NO];
    }
    currentAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]; 
    currentAlert.tag = tag;
    [currentAlert show];
}

-(void)alertLoadingViewWithTitle:(NSString *)title tag:(int)tag Delegate:(id)delegate
{
    if (currentAlert && [currentAlert isKindOfClass:[UIAlertView class]]) {
        [currentAlert dismissWithClickedButtonIndex:0 animated:NO];
    }
    if (!title) {
        title = @"请稍等，购彩助理正在为您处理";
    }
    currentAlert = [[UIAlertView alloc] initWithTitle:title message:@" " delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    currentAlert.tag = tag;
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(128, 45, 30, 30)];
    [currentAlert addSubview:av];
    [av startAnimating];
    [currentAlert show];
}
-(void)hideAlertWithAnimate:(BOOL)animated
{
    if (currentAlert && [currentAlert isKindOfClass:[UIAlertView class]]) {
        [currentAlert dismissWithClickedButtonIndex:0 animated:animated];
    }
}

-(void)alertLoginWithDelegate:(id)delegate TextField:(UITextField *)field
{
    currentAlert = [[UIAlertView alloc] initWithTitle:@"为了您的账户安全,请确认您的登录密码" message:@" " delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
    [currentAlert addSubview:field];
    [currentAlert show];
    [field becomeFirstResponder];
}
-(void)callPhoneNumber:(NSString *)num{
    [self alert:num tag:9999 message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫",nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 9999) {
        if (buttonIndex == 1) {
            {
                NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",alertView.title]];
                BOOL isSucess = [[UIApplication sharedApplication] openURL:phoneNumberURL];
                if (!isSucess) {
                    [AlertManager alertMessage:@"您的设备不支持拨打电话功能"];
                }
            }
        }
    }
}
+ (void)toastMessage:(NSString *)message inView:(UIView *)view{
    
    [MBProgressHUD showError:message toView:view];
}
+ (void)toastSuccessMessage:(NSString *)message inView:(UIView *)view{
    [MBProgressHUD showSuccess:message toView:view];
}

@end
