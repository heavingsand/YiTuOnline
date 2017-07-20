//
//  LoginViewController.m
//  YiToOnline
//
//  Created by 吴迪 on 16/9/18.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "LoginViewController.h"
#import "MapViewController.h"
#import "ScenicShowViewController.h"
#import "MineViewController.h"
#import "RetrieveViewController.h"
#import "RegisterViewController.h"
#import "SocketManager.h"
#import "YiTuBaseModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AFNetworking.h>

@interface LoginViewController ()<AMapLocationManagerDelegate>

@property (nonatomic, retain) UITextField *loginTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation LoginViewController


#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = kColorBg;
    [self judgeLoginData];
    [self creatLoginLabel];
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method

- (UITabBarController *)tabBarControllerRoot{
    
    UITabBarController *root = [[UITabBarController alloc] init];
    [root setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 地图
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.title = @"首页";
    mapVC.tabBarItem.image = [[UIImage imageNamed:@"homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mapVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"homepage-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController:mapVC];
    
    [root addChildViewController:mapNav];
    
    
    // 景区展示
    ScenicShowViewController *scenicShowVC = [[ScenicShowViewController alloc] init];
    scenicShowVC.title = @"分类";
    scenicShowVC.tabBarItem.image = [[UIImage imageNamed:@"classify"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    scenicShowVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"classify-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *scenicShowNav = [[UINavigationController alloc] initWithRootViewController:scenicShowVC];
    [root addChildViewController:scenicShowNav];
    
    
    // 我的
    MineViewController *mineVC = [[MineViewController alloc] init];
    mineVC.title = @"个人";
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"personal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"personal-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    [root addChildViewController:mineNav];
    
    return root;
    
}

- (void)creatLoginLabel{
    //////////////
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth-50, 110)];
    mainView.backgroundColor = kColorWhite;
//    [mainView setBorderColor:kColorLine width:.5 cornerRadius:6];
    mainView.layer.cornerRadius = 6;
    [self.view addSubview:mainView];
    
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 55)];
    phoneLab.text = @"手机号 ";
    phoneLab.textColor = RGBColor(66, 66, 66);
    phoneLab.adjustsFontSizeToFitWidth = YES;
    phoneLab.font = [UIFont systemFontOfSize:19];
    [mainView addSubview:phoneLab];
    
    self.loginTextField = [self addTextFieldWithFrame:CGRectMake(phoneLab.right, 0, mainView.width - phoneLab.width, 55) addText:@"请输入您的账号"];
    self.loginTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.loginTextField.text = [Common getAsynchronousWithKey:@"loginPhone"];
    self.loginTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [mainView addSubview:self.loginTextField];
    
    UILabel *passLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 80, 55)];
    passLab.text = @"密码 ";
    passLab.textColor =  RGBColor(66, 66, 66);
    passLab.adjustsFontSizeToFitWidth = YES;
    passLab.font = [UIFont systemFontOfSize:19];
    [mainView addSubview:passLab];
    
    self.passwordTextField = [self addTextFieldWithFrame:CGRectMake(passLab.right, 55, mainView.width - passLab.width, 55) addText:@"请输入您的密码"];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.text = [Common getAsynchronousWithKey:@"loginPass"];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [mainView addSubview:self.passwordTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 54, mainView.width - 20, 1)];
    lineView.backgroundColor = RGBColor(241, 241, 241);
    [mainView addSubview:lineView];
    
    UIButton *retrieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retrieveBtn.frame = CGRectMake(kMainScreenWidth * 0.75, mainView.bottom + 10, kMainScreenWidth * 0.2, kMainScreenHeight * 0.03);
    [retrieveBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [retrieveBtn setTitleColor:kColorMajor forState:UIControlStateNormal];
    retrieveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [retrieveBtn addTarget:self action:@selector(clickRetrieveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retrieveBtn];

    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, retrieveBtn.bottom + 15, kMainScreenWidth - 50, 50)];
    loginBtn.backgroundColor = RGBColor(248, 117, 69);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 6;
    [loginBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(kMainScreenWidth * 0.35, loginBtn.bottom + 16, kMainScreenWidth * 0.3, kMainScreenHeight * 0.03);
    [registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGBColor(248, 117, 69) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:registerBtn];
    
    
}

-(UIView *)addWhiteViewWithFrame:(CGRect)frame
{
    UIView *whiteView = [[UIView alloc] initWithFrame:frame];
    whiteView.backgroundColor = [UIColor blackColor];
    whiteView.alpha = 0.3;
    [whiteView setBorderColor:kColorLine width:.5 cornerRadius:6];
    [self.view addSubview:whiteView];
    return whiteView;
}
-(UITextField *)addTextFieldWithView:(UIView *)whiteView andText: (NSString *)text
{
    UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, kMainScreenWidth-50, 50)];
    passField.textColor = kColorWhite;
    passField.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:passField];
    return passField;
}

- (UITextField *)addTextFieldWithFrame:(CGRect)frame addText:(NSString *)text {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = kColorMajor;
    textField.placeholder = text;
    return textField;
}

- (void)clickRetrieveBtn{
    [self.navigationController pushViewController:[[RetrieveViewController alloc] init] animated:YES];
}

/*用户自动登录*/
- (void)judgeLoginData{
    [self loadUserCityScenicSpot];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"id"] = [Common getAsynchronousWithKey:@"ID"];
    parame[@"password"] = [Common getAsynchronousWithKey:@"password"];
    
    if (![parame[@"id"] isEqualToString:@""] && ![parame[@"password"] isEqualToString:@""] && parame[@"id"] != nil && parame[@"password"] != nil) {
        [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_AutomaticLogin parameters:parame completionHanlder:^(id jsonData, NSError *error) {
            if (jsonData) {
                if ([jsonData[@"resultnumber"] intValue] == 200) {
                    [self jumpHomePage];
                    [[SocketManager sharedSocket] connectServerWithAdress:ServerSocketAdress andPort:8081];
                    [SocketManager sharedSocket].baseModel.type = @"android";
                    [SocketManager sharedSocket].baseModel.ID = jsonData[@"result"][@"id"];
                    [SocketManager sharedSocket].baseModel.name = jsonData[@"result"][@"nickName"];
                    [SocketManager sharedSocket].baseModel.phonenumber = jsonData[@"result"][@"username"];
                    [SocketManager sharedSocket].baseModel.isstaff = jsonData[@"result"][@"isstaff"];
                    [SocketManager sharedSocket].baseModel.headImg = [NSString stringWithFormat:@"%@",jsonData[@"result"][@"headportrait"]];
                    [SocketManager sharedSocket].isLogin = YES;
                    [self openSocket];
                }else if([jsonData[@"resultnumber"] intValue] == 217){
                    [AlertManager alertMessage:@"用户登录过期,请重新登录"];
                }
            }else {
                [AlertManager toastMessage:error.domain inView:self.view];
            }
        }];
    }
}

/*用户登录*/
- (void)clickLoginBtn{
    if (self.loginTextField.text.length == 0) {
        [AlertManager alertMessage:@"请输入手机号"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [AlertManager alertMessage:@"请输入密码"];
        return;
    }
    [self loadUserCityScenicSpot];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:[NSString stringWithFormat:@"%@", self.loginTextField.text] forKey:@"username"];
    [parametersDic setObject:[NSString stringWithFormat:@"%@", self.passwordTextField.text] forKey:@"password"];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_getAccountnumber parameters:parametersDic completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [Common setAsynchronous:parametersDic[@"username"] WithKey:@"username"];
                [Common setAsynchronous:parametersDic[@"password"] WithKey:@"password"];
                NSString *pass = [NSString stringWithFormat:@"%@", jsonData[@"result"][@"id"]];
                [Common setAsynchronous:pass WithKey:@"ID"];
                [Common setAsynchronous:self.loginTextField.text WithKey:@"loginPhone"];
                [Common setAsynchronous:self.passwordTextField.text WithKey:@"loginPass"];
                [Common setAsynchronous:[NSString stringWithFormat:@"%@",jsonData[@"result"][@"isstaff"]] WithKey:@"isstaff"];
                [self jumpHomePage];
                [[SocketManager sharedSocket] connectServerWithAdress:ServerSocketAdress andPort:8081];
                [SocketManager sharedSocket].baseModel.isstaff = jsonData[@"result"][@"isstaff"];
                [SocketManager sharedSocket].baseModel.type = @"android";
                [SocketManager sharedSocket].baseModel.ID = jsonData[@"result"][@"id"];
                [SocketManager sharedSocket].baseModel.name = jsonData[@"result"][@"nickName"];
                [SocketManager sharedSocket].baseModel.phonenumber = jsonData[@"result"][@"username"];
                [SocketManager sharedSocket].baseModel.headImg = [NSString stringWithFormat:@"%@",jsonData[@"result"][@"headportrait"]];
                [SocketManager sharedSocket].isLogin = YES;
                [self openSocket];
            }else if([jsonData[@"resultnumber"] intValue] == 214){
                [AlertManager alertMessage:@"账号密码错误"];
            }
        }else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

//开启socket通信
- (void)openSocket {
    [[SocketManager sharedSocket] sendMessageWithData];
}

- (void)jumpHomePage{
    [self presentViewController:[self tabBarControllerRoot] animated:YES completion:^{
        
    }];
}

- (void)clickRegisterBtn{
    [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
}

//单次定位
- (void)loadUserCityScenicSpot {
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            if (regeocode.city != nil) {
                NSLog(@"reGeocode:%@", regeocode.city);
                NSMutableString *cityName = [NSMutableString stringWithString:regeocode.city];
                NSRange r1 = [regeocode.city rangeOfString:@"市"];
                [cityName deleteCharactersInRange:r1];
                [SocketManager sharedSocket].baseModel.city = cityName;
                [SocketManager sharedSocket].baseModel.adCode = regeocode.adcode;
            }
        }
    }];
}
#pragma mark - AMapLocationManager Delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
}

#pragma mark - Lazy Load
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDelegate:self];
        //设置多少米定位一次
        [_locationManager setDistanceFilter:20];
        
        //设置期望定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        //设置不允许系统暂停定位
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        
        //设置允许在后台定位
        //        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        
        //设置定位超时时间
        [_locationManager setLocationTimeout:5];
        
        //设置逆地理超时时间
        [_locationManager setReGeocodeTimeout:5];
        
    }
    return _locationManager;
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
