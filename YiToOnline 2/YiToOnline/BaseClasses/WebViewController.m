//
//  WebViewController.m
//  YiToOnline
//
//  Created by 吴迪 on 16/9/5.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property(nonatomic, retain) UIWebView *webView;

@property(nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, retain) UIView *opaqueView;

@end

@implementation WebViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.webView setUserInteractionEnabled:YES];//是否支持交互
    //[webView setDelegate:self];
    self.webView.delegate=self;
    [self.webView setOpaque:NO];//opaque是不透明的意思
    [self.webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:self.webView];
    
    //加载网页的方式
    //1.创建并加载远程网页
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.webUrl]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    //2.加载本地文件资源
    /* NSURL *url = [NSURL fileURLWithPath:filePath];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     [webView loadRequest:request];*/
    //3.读入一个HTML，直接写入一个HTML代码
    //NSString *htmlPath = [[[NSBundle mainBundle]bundlePath]stringByAppendingString:@"webapp/loadar.html"];
    //NSString *htmlString = [NSString stringWithContentsOfURL:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    //[webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:htmlPath]];
    
    self.opaqueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.activityIndicatorView setCenter:self.opaqueView.center];
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.opaqueView setBackgroundColor:[UIColor blackColor]];
    [self.opaqueView setAlpha:0.6];
    [self.view addSubview:self.opaqueView];
    [self.opaqueView addSubview:self.activityIndicatorView];
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicatorView startAnimating];
    self.opaqueView.hidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicatorView startAnimating];
    self.opaqueView.hidden = YES;
}

//UIWebView如何判断 HTTP 404 等错误
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2)) {
        // self.earthquakeData = [NSMutableData data];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [self.webView loadRequest:[ NSURLRequest requestWithURL: url]];
        self.webView.delegate = self;
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        
        if ([error code] == 404) {
            NSLog(@"xx");
            self.webView.hidden = YES;
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
