//
//  NotiDetailViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/20.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "NotiDetailViewController.h"
#import <WebKit/WebKit.h>


@interface NotiDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CALayer *progresslayer;
@end

@implementation NotiDetailViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    // Do any additional setup after loading the view.
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = RGBColor(136, 217, 81).CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark - Method
/*返回上一级控制器*/
- (void)returnLaststageVC {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - WebView Delegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *pCreateJSStr = @"style = \"font-size:20px\"";
//    [self.webView evaluateJavaScript:pCreateJSStr completionHandler:nil];
//}
#pragma mark - Lazy Load
- (WKWebView *)webView {
    if (!_webView) {
//        NSString *js = @"style = font-size:90px";
//        // 根据JS字符串初始化WKUserScript对象
//        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        [config.userContentController addUserScript:script];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        [self.view addSubview:_webView];
        
    }
    return _webView;
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
