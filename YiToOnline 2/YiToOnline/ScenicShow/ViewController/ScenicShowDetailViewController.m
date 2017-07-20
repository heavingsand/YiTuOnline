//
//  ScenicShowDetailViewController.m
//  YiToOnline
//
//  Created by 吴迪 on 16/9/3.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ScenicShowDetailViewController.h"
#import "WebViewController.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
//#import "CommentViewController.h"


@interface ScenicShowDetailViewController ()

@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) UIButton *buttonPlayer;
@property (nonatomic, retain) UIImageView *imageViewPlayerBack;
@property (nonatomic, assign) BOOL btnJudge;
@property (nonatomic, retain) UIImageView *lableBackGround;


@end

@implementation ScenicShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    NSString *httpUrl = @"http://apis.baidu.com/thinkpage/weather_api/suggestion";
    NSString *httpArg = @"location=shenzhen&language=zh-Hans&unit=c&start=0&days=3";
    [self request: httpUrl withHttpArg: httpArg];
    [self creatBackGround];
    [self creatHeadView];
    [self attractionsLabelText];
    [self creatPlayer];
    [self creatPlayerButten];
    [self playerButtenAddAnimation];
    [self btnCommentAndEvent];
}

/*返回上一级控制器*/
- (void)returnLaststageVC {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)creatPlayer{
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.model.voice]]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [self.player play];
}


- (void)creatBackGround{
    UIImageView *imageViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT * 0.4, WIDTH, HEIGHT * 0.6)];
    [imageViewBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.model.img]]];
    [self.view addSubview:imageViewBack];
    
    
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualView.frame = CGRectMake(0, imageViewBack.frame.origin.y, imageViewBack.frame.size.width, imageViewBack.frame.size.height);
    [self.view addSubview:visualView];
    
    
    self.lableBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 0.05, imageViewBack.frame.origin.y + HEIGHT * 0.02, WIDTH * 0.9, HEIGHT * 0.48)];
    self.lableBackGround.image = [UIImage imageNamed:@"lableImageViewBack"];
    // lableBackGround.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lableBackGround];
}

- (void)creatPlayerButten{
    
    self.imageViewPlayerBack = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 0.05, HEIGHT * 0.42, WIDTH * 0.2, HEIGHT * 0.11244377811094)];
    self.imageViewPlayerBack.image = [UIImage imageNamed:@"WechatIMG2"];
    self.imageViewPlayerBack.layer.masksToBounds = YES;
    self.imageViewPlayerBack.layer.cornerRadius = WIDTH * 0.2 / 2;
    [self.view addSubview:self.imageViewPlayerBack];
    
    
    self.buttonPlayer = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonPlayer.frame = CGRectMake(WIDTH * 0.05, HEIGHT * 0.42, WIDTH * 0.2, HEIGHT * 0.11244377811094);
    [_buttonPlayer setImage:[UIImage imageNamed:@"suspendKey"] forState:UIControlStateNormal];
    [self.buttonPlayer addTarget:self action:@selector(buttenAction) forControlEvents:UIControlEventTouchUpInside];
    self.btnJudge = YES;
    [self.view addSubview:self.buttonPlayer];
}

- (void)attractionsLabelText{
    UILabel *attractionsName = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 0.3, HEIGHT * 0.44, WIDTH * 0.4, HEIGHT * 0.05)];
    attractionsName.text = [NSString stringWithFormat:@"%@", self.model.scenicspotname];
    attractionsName.font = [UIFont systemFontOfSize:18];
    attractionsName.font = [UIFont boldSystemFontOfSize:21.0];
    [self.view addSubview:attractionsName];
    
    UILabel *attractionsLevel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 0.3, HEIGHT * 0.5, WIDTH * 0.4, HEIGHT * 0.03)];
    attractionsLevel.text = [NSString stringWithFormat:@"%@级景区", self.model.starlevel];
    [self.view addSubview:attractionsLevel];
    
    
    UILabel *attractionsIntroduceText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 0.7, HEIGHT * 0.23)];
    attractionsIntroduceText.text = [NSString stringWithFormat:@"%@", self.model.introduce];
    [attractionsIntroduceText setText:[NSString stringWithFormat:@"%@", self.model.introduce]];
    attractionsIntroduceText.numberOfLines = 0;
    
    UIButton *attractionsIntroduce = [UIButton buttonWithType:UIButtonTypeCustom];
    attractionsIntroduce.frame = CGRectMake(WIDTH * 0.15, HEIGHT * 0.6, WIDTH * 0.7, HEIGHT * 0.23);
    [attractionsIntroduce addTarget:self action:@selector(btnAttractionsIntroduce) forControlEvents:UIControlEventTouchUpInside];
    [attractionsIntroduce addSubview:attractionsIntroduceText];
    [self.view addSubview:attractionsIntroduce];
    
}

- (void)btnAttractionsIntroduce{
    WebViewController *jumpVC = [[WebViewController alloc] init];
    jumpVC.webUrl = self.model.link;
    [self.navigationController pushViewController:jumpVC animated:YES];
    
}

- (void)buttenAction{
    if (self.btnJudge == YES) {
        [self.buttonPlayer setImage:[UIImage imageNamed:@"playKey"] forState:UIControlStateNormal];
        self.imageViewPlayerBack.layer.speed = 0;
        [self.player pause];
    } else {
        [self.buttonPlayer setImage:[UIImage imageNamed:@"suspendKey"] forState:UIControlStateNormal];
        self.imageViewPlayerBack.layer.speed = 1;
        [self.player play];
    }
    self.btnJudge = !self.btnJudge;
}

- (void)playerButtenAddAnimation{
#pragma mark - 旋转动画
    //改变view Z轴
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //旋转的起始值 从零开始转
    animation.fromValue = [NSNumber numberWithInt:0];
    
    //最终旋转的角度是360°
    animation.toValue = [NSNumber numberWithInt:M_PI * 2];
    
    //旋转时长
    animation.duration = 5;
    
    //重复次数 0 为无限次
    animation.repeatCount = NSIntegerMax;
    
    //旋转结束后是否要逆向返回原位置
    animation.autoreverses = NO;
    
    //是否按照结束位置继续旋转
    animation.cumulative = YES;
    
    //给view的layer层添加动画,key是标记
    [self.imageViewPlayerBack.layer addAnimation:animation forKey:@"circle"];
    
    self.imageViewPlayerBack.layer.speed = 1.0;

}



-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"0558bee91d3cfe5f9bcb84107f8ebc9f" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                               } else {
                                   //NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   //NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   //NSLog(@"HttpResponseBody %@",responseString);
                                   [self creatWeatherForecast:data];
                               }
                           }];
}


- (void)creatWeatherForecast:(NSData *)data{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *resultsArr = [dic objectForKey:@"results"];
    NSDictionary *resultsDic = [resultsArr objectAtIndex:0];
    NSArray *dailyArr = [resultsDic objectForKey:@"daily"];
    NSDictionary *daliyDic = [dailyArr objectAtIndex:0];
    
    UILabel *labelweather = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT * 0.095, WIDTH, HEIGHT * 0.03)];
    labelweather.text = [NSString stringWithFormat:@"白天天气多云%@, 夜晚%@, 气温%@到%@度, 风力%@级", [daliyDic objectForKey:@"text_day"], [daliyDic objectForKey:@"text_night"], [daliyDic objectForKey:@"low"], [daliyDic objectForKey:@"high"], [daliyDic objectForKey:@"wind_scale"]];
    labelweather.font = [UIFont systemFontOfSize:12];
    labelweather.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:labelweather];
    
}


- (void)creatHeadView{
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT * 0.125)];
    grayView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:grayView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT * 0.125, WIDTH, HEIGHT * 0.275)];
    imageView.backgroundColor = [UIColor redColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.model.img]]];
    [self.view addSubview:imageView];
    
    UIImageView *imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 0.05, HEIGHT * 0.3, WIDTH * 0.17, HEIGHT * 0.1)];
    // imageViewLogo.backgroundColor = [UIColor blackColor];
    imageViewLogo.image = [UIImage imageNamed:@"WechatIMG2"];
    imageViewLogo.layer.masksToBounds = YES;
    imageViewLogo.layer.cornerRadius = (WIDTH * 0.17 + HEIGHT * 0.1) / 3.45;
   //  [self.view addSubview:imageViewLogo];

}


- (void)btnCommentAndEvent{
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(WIDTH * 0.25, HEIGHT * 0.83, WIDTH * 0.22, HEIGHT * 0.06);
    [commentBtn setTitle:@"评价" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // commentBtn.backgroundColor = [UIColor redColor];
    [commentBtn addTarget:self action:@selector(btnComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentBtn];
    
    
    UIButton *EventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    EventBtn.frame = CGRectMake(WIDTH * 0.53, HEIGHT * 0.83, WIDTH * 0.22, HEIGHT * 0.06);
    [EventBtn setTitle:@"活动" forState:UIControlStateNormal];
    [EventBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // EventBtn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:EventBtn];
}

- (void)btnComment{
//    CommentViewController *jumpVC = [[CommentViewController alloc] init];
//    jumpVC.scenicID = self.model.scenicspotid;
//    [self.navigationController pushViewController:jumpVC animated:YES];
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
