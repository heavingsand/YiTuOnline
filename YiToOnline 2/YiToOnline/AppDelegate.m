//
//  AppDelegate.m
//  YiToOnline
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <SMS_SDK/SMSSDK.h>
#import <MAMapKit/MAMapKit.h>
#import "JPUSHService.h"//极光推送

#import "LoginViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "SocketManager.h"
#import "YiTuBaseModel.h"
#import "MapViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"
#endif

@interface AppDelegate ()<AMapLocationManagerDelegate, JPUSHRegisterDelegate>
@end

//注册函数, 崩溃日志
void uncaughtExceptionHandler(NSException* exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
    [Common catchEexceptionMailToDeveloperWithNSException:exception];
}

@implementation AppDelegate
/* 需要更改 高德地图 的APIKEY 和 MOB的SMSSDK的APIKEY
 * MOB一天20限量发送 里面有不限量的审查 请提交
 * 留了几个轮子#import "WDNetworkHandler.h" 这个是网络请求的二次封装 直接 WDNetworkHandler GET就行
 * CYCLE是轮播图 
 * 登录和注册页的逻辑都完成了 除非接口或者逻辑有变动否则不用改了
 *
 * 天气预报用的是中国和世界天气预报 注册百度账号 换APIKEY
 * web页统一调用webViewController
 * 
 */

/*** 欢迎页 ****/
- (void)changeRootVC {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNumber =infoDic[@"CFBundleShortVersionString"];
    NSLog(@"versionNumber %@", versionNumber);
//    NSString *runVersionNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kRunVersion];
    NSString *runVersionNumber = [Common getAsynchronousWithKey:kRunVersion];
    NSLog(@"runVersion %@", runVersionNumber);
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if (runVersionNumber == nil || ![runVersionNumber isEqualToString:versionNumber]) {
        ViewController *welcomeVc = [[ViewController alloc] init];
        self.window.rootViewController = welcomeVc;
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = loginNav;
        [self.window makeKeyAndVisible];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 注册异常监听
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //欢迎页显示
    [self changeRootVC];
    
    //启动高德, Mob第三方服务
    [AMapServices sharedServices].apiKey = kAMPApikey;
    [SMSSDK registerApp:kMOBApp withSecret:kMOBSecret];
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    self.window.rootViewController = loginNav;
    
//    [self loadUserCityScenicSpot];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
//    }];
    
    //全局配置
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [UITabBar appearance].translucent = NO;
    [[UITableView appearance] setTableFooterView:[UIView new]];
    [UITableView appearance].separatorStyle = UITableViewCellSeparatorStyleNone;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBColor(248, 117, 69)} forState:UIControlStateSelected];
    //设置标题栏颜色
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barTintColor = RGBColor(248, 117, 69);
    [UINavigationBar appearance].tintColor = kColorWhite;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UIBarButtonItem appearance].tintColor = kColorWhite;
    
    [self.window makeKeyAndVisible];
    
    /****************  极光推送 *****************/
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppkey
                          channel:@"YiTu channel"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [SocketManager sharedSocket].baseModel.channelid = registrationID;
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    /******************************************/
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If   the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 极光推送 Method
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
