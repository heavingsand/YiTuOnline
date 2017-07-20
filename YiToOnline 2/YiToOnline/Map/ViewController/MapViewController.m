//
//  MapViewController.m
//  YiTuOnline
//
//  Created by 吴迪 on 16/8/31.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "SocketManager.h"
#import "HelpSocketManager.h"
#import "QRCodeViewController.h"
#import "SZQRCodeViewController.h"
#import "POIAnnotation.h"
#import "CustomAnnotationView.h"
#import "CustomAnnotationView2.h"
#import "CustomAnnotation.h"
#import "OverlayModel.h"
#import <UIImageView+WebCache.h>
#import "AVPlayerManager.h"
#import "SearchViewController.h"
#import "WeatherView.h"
#import "NotiViewController.h"
#import "HelpAnnotationView.h"
#import "SOSResultViewController.h"
#import "JPUSHService.h"



@interface MapViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMapSearchDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) AMapLocationManager *locationManager;
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, strong) MAGroundOverlay *groundOverlay;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) UIButton *sosBtn, *gpsButton;
@property (nonatomic, strong) UIBarButtonItem *btnItem1, *btnItem2, *btnItem3, *btnItem4;
@property (nonatomic, strong) UIBarButtonItem *fixedSpace1, *fixedSpace2;
@property (nonatomic, strong) UILabel *badgeLab;
@property (nonatomic, strong) UIView *parkingView, *menuView, *menuView2, *languageMenu;
@property (nonatomic, strong) UIButton *findBtn, *hotBtn, *guideBtn, *lineBtn, *languagesBtn;
@property (nonatomic, strong) UIButton *findCarBtn, *WCBtn, *cateringBtn, *ticketOfficeBtn, *parkingLotBtn, *canteenBtn, *sosResultBtn;
@property (nonatomic, strong) NSMutableArray *mainMenuArr, *imageViewArr, *languageArr,*annotationArr, *scenicSpotMusicArr;
@property (nonatomic, strong) NSMutableDictionary *userCarLocationDic;
@property (nonatomic, strong) NSTimer *judgeTime, *sosTime;
@property (nonatomic, strong) AMapSearchAPI *POISearch;
@property (nonatomic, assign) BOOL isFirstOverlay, isMove, isGetMusic, isPlayMusic, isGuide, isInSpot;
@property (nonatomic, strong) OverlayModel *overlayModel;
@property (nonatomic, strong) AnnotationBaseModel *annotationBaseModel, *resultBaseModel;
@property (nonatomic, strong) WeatherView *weatherView;
@property (nonatomic, strong) CustomAnnotationView *customAnnotationView;

@end

@implementation MapViewController

#define kMenuArray @[@"找车",@"卫生间",@"餐饮",@"售票处",@"停车场",@"购物点"]
#define kMenuImageNameNor @[@"zhaoche",@"WC",@"canyin",@"shoupianchu",@"tcc",@"xiaomaibu"]
#define kMenuImageNameHei @[@"zhaoche1",@"WC1",@"canyin1",@"shoupianchu1",@"tcc1",@"xiaomaibu1"]
#define kMenuType @[@"wc",@"restaurant",@"ticketoffice",@"park",@"shopping"]

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setUpNavBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"";
    self.view.backgroundColor = kColorBg;
    self.navigationItem.leftBarButtonItems = @[self.fixedSpace2, self.btnItem1, self.fixedSpace1, self.btnItem2, self.fixedSpace1, self.btnItem3, self.fixedSpace1, self.btnItem4];
    
    //监听一键求助返回
//    [kNotificationCenter addObserver:self selector:@selector(addAnnotationFromSOS:) name:kNotiSOS object:nil];
    
    //是否获取景区语音
    self.isGetMusic = YES;
    
    //UI控件
    [self locationManager];
    [self mapView];
    [self sosBtn];
    [self parkingView];
    [self menuView];
    [self menuView2];
    [self languageMenu];
    [self gpsButton];
    [self weatherView];
    
    [self performSelector:@selector(judgeUserInScenicspot) withObject:nil afterDelay:3];
    [self performSelector:@selector(searchLiveWeather) withObject:nil afterDelay:1];
//    [self searchLiveWeather];
    
//    [self sosResultBtn];
    // 显示定位
//    self.mapView.showsUserLocation = YES;
//    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    MACoordinateSpan span = MACoordinateSpanMake(0.004913, 0.003000);
    MACoordinateRegion region = MACoordinateRegionMake(_mapView.centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置通知角标
    [Common layoutBadge:self.badgeLab andCount:[UIApplication sharedApplication].applicationIconBadgeNumber];
//    if ([SocketManager sharedSocket].isAddOverlay) {
//        [self initGroundOverlay];
//    }
    [SocketManager sharedSocket].isAddOverlay = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SocketManager sharedSocket].isAddOverlay = NO;
}
#pragma mark - Method
//一键求助向地图添加标注
- (void)addAnnotationFromSOS {
    if (![SocketManager sharedSocket].isLogin) {
        return;
    }
    if (self.sosTime) {
        [self.sosTime invalidate];
        self.sosTime = nil;
    }
    self.sosTime = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(addAnnotationFromSOS) userInfo:nil repeats:YES];
    if ([HelpSocketManager sharedSocket].returnData !=nil) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        NSMutableArray *arr = [NSMutableArray new];
        id  jsonData = [NSJSONSerialization JSONObjectWithData:[HelpSocketManager sharedSocket].returnData options:NSJSONReadingAllowFragments error:nil];
        NSString *result = [[NSString alloc] initWithData:[HelpSocketManager sharedSocket].returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", [jsonData class]);
        NSLog(@"%@",result);
        if ([jsonData isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in jsonData) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue]);
                CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
                annotation.coordinate = coordinate;
                annotation.baseModel.nickName = dic[@"nickName"];
//                annotation.baseModel.nickName = [[NSString alloc] initWithData:jsonData[@"nickName"] encoding:NSUTF8StringEncoding];
                annotation.baseModel.phoneNumber = dic[@"phonenumber"];
                annotation.baseModel.time = dic[@"helpTime"];
                annotation.baseModel.imageName = dic[@"headportrait"];
                annotation.isHelp = YES;
                annotation.baseModel.ID = [dic[@"id"] stringValue];
                [arr addObject:annotation];
            }
        }
        if ([jsonData isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = jsonData;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue]);
            CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
            annotation.coordinate = coordinate;
            annotation.baseModel.nickName = jsonData[@"nickName"];
            annotation.baseModel.phoneNumber = jsonData[@"phonenumber"];
            annotation.baseModel.time = dic[@"acceptTime"];
            annotation.baseModel.imageName = dic[@"headportrait"];
            annotation.baseModel.isStaff = YES;
            annotation.isHelp = YES;
            [arr addObject:annotation];
            NSLog(@"%@", dic);
        }
        if ([result isEqualToString:@"end"]) {
            [[HelpSocketManager sharedSocket] disconnectedSocket];
            [HelpSocketManager sharedSocket].returnData = nil;
        }
        
        if (self.userLocationAnnotationView.annotation != nil) {
            CustomAnnotation *annotation = (CustomAnnotation *)self.userLocationAnnotationView.annotation;
            [arr addObject:annotation];
        }
        [self.mapView addAnnotations:arr];
        [self.mapView showAnnotations:arr edgePadding:UIEdgeInsetsMake(150, 150, 150, 150) animated:YES];
    }
}

//实时天气查询
- (void)searchLiveWeather
{
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city = [SocketManager sharedSocket].baseModel.adCode;
    request.type = AMapWeatherTypeLive;
    
    [self.POISearch AMapWeatherSearch:request];
}

//判断用户是否在景区
- (void)judgeUserInScenicspot {
    if (![SocketManager sharedSocket].isLogin) {
        return;
    }
    if (self.judgeTime) {
        [self.judgeTime invalidate];
        self.judgeTime = nil;
    }
    self.judgeTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(judgeUserInScenicspot) userInfo:nil repeats:YES];
    
    NSString *path = [NSString stringWithFormat:kUrl_SpotRange, [SocketManager sharedSocket].baseModel.city, [SocketManager sharedSocket].baseModel.ID];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [RXApiServiceEngine requestWithType:RequestMethodTypeGet url:path parameters:nil completionHanlder:^(id jsonData, NSError *error) {
        
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                self.overlayModel = [OverlayModel parse:jsonData[@"result"]];
                [SocketManager sharedSocket].baseModel.scenicspotsid = [jsonData[@"result"][@"scenicspotsid"] stringValue];
                self.isInSpot = YES;
                //一级导航
                if ([[SocketManager sharedSocket].baseModel.isstaff intValue] == 0) {
                    self.sosBtn.hidden = NO;
                    self.menuView.height = 250;
                    self.lineBtn.hidden = NO;
                    self.guideBtn.hidden = NO;
                    self.languagesBtn.hidden = NO;
                    //二级导航
                    self.menuView2.height = 300;
                    self.WCBtn.hidden = NO;
                    self.cateringBtn.hidden = NO;
                    self.ticketOfficeBtn.hidden = NO;
                    self.parkingLotBtn.hidden = NO;
                    self.canteenBtn.hidden = NO;

                }
                if ([[SocketManager sharedSocket].baseModel.isstaff intValue] == 1 && ![HelpSocketManager sharedSocket].asyncSocket.isConnected) {
                    [self staffConnectSocket];
                    self.menuView.hidden = YES;
                    self.parkingView.hidden = YES;
                }
                //如果是第一次,就加载导览图
                if (!self.isFirstOverlay && [[SocketManager sharedSocket].baseModel.isstaff intValue] != 1 &&[SocketManager sharedSocket].isAddOverlay) {
                    [self initGroundOverlay];
                    self.isFirstOverlay = YES;
                    //调用一次获取景区语音接口
//                    [self scenicSpotInformationFromType:@"attractions" andName:nil];
                    [self getScenicSpotMusic];
                    [self inputSpotRecord];
                }
                //是否播放语音
                self.isPlayMusic = YES;
            }
            if ([jsonData[@"resultnumber"]intValue] == 201) {
                [AlertManager alertMessage:@"输入参数为空"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 204) {
//                [AlertManager alertMessage:@"未知错误"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 208) {
//                [AlertManager alertMessage:@"没有此用户"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 211) {
//                [AlertManager alertMessage:@"未找到此城市和景区"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 212) {
//                [AlertManager alertMessage:@"没有在景区内"];
                self.sosBtn.hidden = YES;
                self.menuView.height = 100;
                self.lineBtn.hidden = YES;
                self.guideBtn.hidden = YES;
                self.languagesBtn.hidden = YES;
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
//进入景区获取景区语音接口
- (void)getScenicSpotMusic {
    NSString *path = [NSString stringWithFormat:kUrl_getiprwa, @"attractions", [SocketManager sharedSocket].baseModel.scenicspotsid];
    [RXApiServiceEngine requestWithType:RequestMethodTypeGet url:path parameters:nil completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                
                /* 把景区和语音存入数组 */
                for (NSDictionary *dic in jsonData[@"result"]) {
                    AnnotationBaseModel *model = [AnnotationBaseModel parse:dic];
                    [self.scenicSpotMusicArr addObject:model];
                }
            }
            if ([jsonData[@"resultnumber"]intValue] == 201) {
                [AlertManager alertMessage:@"输入参数为空"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 204) {
                [AlertManager alertMessage:@"未知错误"];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

//工作人员连接socket通信
- (void)staffConnectSocket {
    [[HelpSocketManager sharedSocket] connectServer];
    [HelpSocketManager sharedSocket].isStaff = YES;
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"numberid"] = [SocketManager sharedSocket].baseModel.ID;
    params[@"nickname"] = [SocketManager sharedSocket].baseModel.name;
    params[@"isstaff"] = [SocketManager sharedSocket].baseModel.isstaff;
    params[@"phonenumber"] = [SocketManager sharedSocket].baseModel.phonenumber;
    params[@"scenicspotsid"] = [SocketManager sharedSocket].baseModel.scenicspotsid;
    [[HelpSocketManager sharedSocket] sendMessageWithData:params];
    [self addAnnotationFromSOS];
}

- (UIButton *)addBtnWithFrame:(CGRect)frame andImageName:(NSString *)imageName andImageHei:(NSString *)imageNameHei andTag:(NSInteger)tag  andMethod:(SEL)method {
//    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode : UIImageRenderingModeAlwaysOriginal];
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeTile];
//    UIImage *imageHei = [[UIImage imageNamed:imageNameHei] imageWithRenderingMode : UIImageRenderingModeAlwaysOriginal];
//    imageHei = [imageHei resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeTile];
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *imageHei = [UIImage imageNamed:imageNameHei];
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:imageHei forState:UIControlStateHighlighted];
    [button setImage:imageHei forState:UIControlStateSelected];
    [button addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    if (tag > 500 && tag < 1200) {
        [self.imageViewArr addObject:button];
    }else if(tag <= 500){
        [self.mainMenuArr addObject:button];
    }else {
        [self.languageArr addObject:button];
    }
    return button;
}
//地图搜索
- (void)mapSerach {
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [[AVPlayerManager shareManager] avPlayerPause];
    [self.navigationController pushViewController:searchVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//调用相机
- (void)jumpCamera{
    UIImagePickerController *imagePick = [UIImagePickerController new];
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePick animated:YES completion:nil];
    [[AVPlayerManager shareManager] avPlayerPause];
}

//存车
- (void)userParking {
    [AlertManager alertWithTitle:@"温馨提示" tag:1000 message:@"是否覆盖上次存车位置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

//一键求助
- (void)sosBtnClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"一键求助" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *selectOne = [UIAlertAction actionWithTitle:@"紧急求助" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([HelpSocketManager sharedSocket].asyncSocket.isConnected) {
            [AlertManager alertMessage:@"您已求助,请勿重复点击!!!"];
        } else {
            MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
            pre.image = [UIImage imageNamed:@"userPosition"];
            //        pre.image = [UIImage animatedImageNamed:@"loading_" duration:0.5];
            [self.mapView updateUserLocationRepresentation:pre];
            [[HelpSocketManager sharedSocket] connectServer];
            NSMutableDictionary *params = [NSMutableDictionary new];
            params[@"numberid"] = [SocketManager sharedSocket].baseModel.ID;
            params[@"nickname"] = [SocketManager sharedSocket].baseModel.name;
            params[@"isstaff"] = [SocketManager sharedSocket].baseModel.isstaff;
            params[@"phonenumber"] = [SocketManager sharedSocket].baseModel.phonenumber;
            params[@"scenicspotsid"] = [SocketManager sharedSocket].baseModel.scenicspotsid;
            params[@"helpTime"] = [Common formatWithDate];
            params[@"headportrait"] = [SocketManager sharedSocket].baseModel.headImg;
            [[HelpSocketManager sharedSocket] sendMessageWithData:params];
            [self addAnnotationFromSOS];
        }
    }];
    UIAlertAction *selectTwo = [UIAlertAction actionWithTitle:@"拨打管理电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:selectOne];
    [alertController addAction:selectTwo];
    [alertController addAction:cancel];
    alertController.view.layer.cornerRadius = 6;
    [self presentViewController:alertController animated:YES completion:nil];
}

//处理完成
- (void)sosResultBtnClick {
    SOSResultViewController *sosVc = [[SOSResultViewController alloc] init];
    [sosVc setSOSBtnBlock:^{
        self.sosResultBtn.hidden = YES;
        [HelpSocketManager sharedSocket].returnData = nil;
        [self.mapView removeAnnotations:self.mapView.annotations];
    }];
    sosVc.mainArr = @[self.resultBaseModel.nickName,self.resultBaseModel.phoneNumber,[SocketManager sharedSocket].baseModel.name,[SocketManager sharedSocket].baseModel.phonenumber,self.resultBaseModel.time,[Common formatWithDate]];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sosVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//定位自己
- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
}

// 点击热力图
- (void)clickHotMapBtn{
    
    //构造热力图图层对象
    MAHeatMapTileOverlay  *heatMapTileOverlay = [[MAHeatMapTileOverlay alloc] init];
    
    //构造热力图数据，从locations.json中读取经纬度
    NSMutableArray* data = [NSMutableArray array];
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heatMapData" ofType:@"json"]];
    
    @autoreleasepool {
        
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            
            for (NSDictionary *dic in dicArray)
            {
                MAHeatMapNode *node = [[MAHeatMapNode alloc] init];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [dic[@"lat"] doubleValue];
                coordinate.longitude = [dic[@"lng"] doubleValue];
                node.coordinate = coordinate;
                
                node.intensity = 1;//设置权重
                [data addObject:node];
            }
        }
        heatMapTileOverlay.data = data;
        
        //构造渐变色对象
        MAHeatMapGradient *gradient = [[MAHeatMapGradient alloc] initWithColor:@[[UIColor blueColor],[UIColor greenColor], [UIColor redColor]] andWithStartPoints:@[@(0.2),@(0.5),@(0.9)]];
        heatMapTileOverlay.gradient = gradient;
        
        //将热力图添加到地图上
        [self.mapView addOverlay: heatMapTileOverlay];
    }
}

//查找功能
- (void)findBtnClick {
    if (self.menuView2.hidden) {
        self.menuView2.hidden = NO;
    }else {
        self.menuView2.hidden = YES;
    }
}
//构造热力图
- (void)hotBtnClick {
    [AlertManager alertMessage:@"努力开发中~~~~(>_<)~~~~"];
}
//导游功能
- (void)guideBtnClick {
    if (self.isGuide) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.isGuide = NO;
        return;
    }else {
        [self.annotationArr removeAllObjects];
        //是否处于导游状态
        self.isGuide = YES;
        [[AVPlayerManager shareManager] avPlayerPause];
        [self scenicSpotInformationFromType:@"attractions" andName:nil];
    }
}
//路线功能
- (void)lineBtnClick {
    [AlertManager alertMessage:@"努力开发中~~~~(>_<)~~~~"];
}
//语种
- (void)LanguagesBtnClick {
    if (self.languageMenu.hidden) {
        self.languageMenu.hidden = NO;
    }else {
        self.languageMenu.hidden = YES;
    }
}
//扫一扫功能
- (void)saoyisao {
    SZQRCodeViewController *QRCodeVc = [[SZQRCodeViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:QRCodeVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    [[AVPlayerManager shareManager] avPlayerPause];
}

//通知中心
- (void)notiCenter {
    NotiViewController *notiVc = [[NotiViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    notiVc.notiNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    [[AVPlayerManager shareManager] avPlayerPause];
    [self.navigationController pushViewController:notiVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//主菜单功能
- (void)mainMenu:(UIButton *)sender {
    for (UIButton *button in self.mainMenuArr ) {
        if (button == sender) {
            [button setSelected:YES];
        }else {
            [button setSelected:NO];
        }
    }
    if (self.findBtn == sender) {
        [self findBtnClick];
    }
    if (self.hotBtn == sender) {
        [self hotBtnClick];
    }
    if (self.guideBtn == sender) {
        [self guideBtnClick];
    }
    if (self.lineBtn == sender) {
        [self lineBtnClick];
    }
    if (self.languagesBtn == sender) {
        [self LanguagesBtnClick];
    }
    if (sender != self.findBtn) {
        self.menuView2.hidden = YES;
    }
    if (sender != self.languagesBtn) {
        self.languageMenu.hidden = YES;
    }
}

//查找菜单功能
- (void)findMenu:(UIButton *)sender {
    
    
    [self.findBtn setImage:[UIImage imageNamed:kMenuImageNameNor[sender.tag/100 - 6]] forState:UIControlStateNormal];
    [self.findBtn setImage:[UIImage imageNamed:kMenuImageNameHei[sender.tag/100 - 6]] forState:UIControlStateSelected];
    self.menuView2.hidden = YES;
    
    for (UIButton *button in self.imageViewArr ) {
        if (button == sender) {
            [button setSelected:YES];
        }else {
            [button setSelected:NO];
        }
    }
    self.menuView2.hidden = YES;
    
    if (self.findCarBtn == sender) {
        NSDictionary *coorDic = [Common getAsynchronousWithKey:@"userCarLocation"];
        NSString *appName = @"YiToOnline";
        float latitude = [coorDic[@"latitude"] floatValue];
        float longitude = [coorDic[@"longitude"] floatValue];
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=2",appName, latitude, longitude,@"我的位置", 22.727814, 114.270003, @"我的车"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else {
        [self scenicSpotInformationFromType:kMenuType[sender.tag/100-7] andName:kMenuArray[sender.tag/100 -6]];
    }
}
//语种切换
- (void)changeLanguage :(UIButton *)sender {
    
    [self.languagesBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"language%ld",(long)sender.tag / 100 - 12]] forState:UIControlStateNormal];
    [self.languagesBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"languageHei%ld",(long)sender.tag / 100 - 12]] forState:UIControlStateSelected];
    
    self.languageMenu.hidden = YES;
    for (UIButton *button in self.languageArr ) {
        if (button == sender) {
            [button setSelected:YES];
        }else {
            [button setSelected:NO];
        }
    }
    NSString *languageid = [NSString stringWithFormat:@"%ld", (sender.tag/100) - 11];
    [Common setAsynchronous:languageid WithKey:kLanguageType];
    //语音切换
    for (int i = 0; i < self.annotationArr.count; i ++) {
        AnnotationBaseModel *model = self.scenicSpotMusicArr[i];
        CustomAnnotationView *customView = self.annotationArr[i];
        for (NSDictionary *dic in model.music) {
            MusicModel *music = [MusicModel parse:dic];
            if (music.languageid == (sender.tag/100) - 11) {
                customView.music = music;
            }
            if (customView == self.customAnnotationView) {
                [customView changeMusic];
            }
        }
    }
}
/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    request.city = [SocketManager sharedSocket].baseModel.city;
    //    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    
    [self.POISearch AMapPOIKeywordsSearch:request];

}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate:(NSString *)keyword
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
    request.keywords            = keyword;
    request.radius = 2000;
    request.offset = 5;
    /* 按照距离排序. */
    request.sortrule            = 0;
//    request.requireExtension    = YES;
    
    [self.POISearch AMapPOIAroundSearch:request];
}

/* 入园记录 */
- (void)inputSpotRecord {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"numberId"] = [SocketManager sharedSocket].baseModel.ID;;
    params[@"scenicspotsid"] = [SocketManager sharedSocket].baseModel.scenicspotsid;
    params[@"intotime"] = [Common formatWithDate];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_EnterRecord parameters:params completionHanlder:nil];
}

/* 获取景点停车场, 餐厅, 售票点, 厕所, 商店 */
- (void)scenicSpotInformationFromType:(NSString *)type andName:(NSString *)name{
    NSString *path = [NSString stringWithFormat:kUrl_getiprwa, type, [SocketManager sharedSocket].baseModel.scenicspotsid];
    [RXApiServiceEngine requestWithType:RequestMethodTypeGet url:path parameters:nil completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.mapView removeAnnotations:self.mapView.annotations];
                
                NSMutableArray *arr = [NSMutableArray new];
                
                for (NSDictionary *dic in jsonData[@"result"]) {
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue]);
                    CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
                    annotation.coordinate = coordinate;
                    annotation.baseModel.attractionsname = name;
                    annotation.imageName = type;
                    if ([type isEqualToString:@"attractions"]) {
                        annotation.baseModel = [AnnotationBaseModel parse:dic];
                        annotation.isGuide = YES;
                    }
                    [arr addObject:annotation];
                }
                if (self.userLocationAnnotationView.annotation != nil) {
                    CustomAnnotation *annotation = (CustomAnnotation *)self.userLocationAnnotationView.annotation;
                    [arr addObject:annotation];
                }
                
                [self.mapView addAnnotations:arr];
                
                /* 如果只有一个结果，设置其为中心点. */
                if (arr.count == 1)
                {
                    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
                }
                /* 如果有多个结果, 设置地图使所有的annotation都可见. */
                else
                {
                    [self.mapView showAnnotations:arr edgePadding:UIEdgeInsetsMake(150, 150, 150, 150) animated:YES];
                    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
                    
                }
            }
            if ([jsonData[@"resultnumber"]intValue] == 201) {
                [AlertManager alertMessage:@"输入参数为空"];
            }
            if ([jsonData[@"resultnumber"]intValue] == 204) {
                [AlertManager alertMessage:@"未知错误"];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
#pragma mark - AlerView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        [self.userCarLocationDic removeAllObjects];
        self.userCarLocationDic[@"latitude"] = [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.latitude];
        self.userCarLocationDic[@"longitude"] = [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.longitude];
        [Common setAsynchronous:self.userCarLocationDic WithKey:@"userCarLocation"];
        [AlertManager alertMessage:@"存车成功(づ｡◕‿‿◕｡)づ"];
    }
}

#pragma mark - MapView Delegate

/* 位置或者设备方向更新后调用此接口 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
    
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {

}
#pragma mark - MapViewOverlay Delegate
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
//    if ([overlay isKindOfClass:[MATileOverlay class]])
//    {
//        MATileOverlayView *tileOverlayView = [[MATileOverlayView alloc] initWithTileOverlay:overlay];
//        
//        return tileOverlayView;
//    }
//    
//    return nil;
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc]
                                                  initWithGroundOverlay:overlay];
        
        return groundOverlayView;
    }
    return nil;
}




- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    // 热力图和切片位置
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayRenderer *groundOverlayRenderer = [[MAGroundOverlayRenderer alloc] initWithGroundOverlay:overlay];
        [groundOverlayRenderer setAlpha:0.9];
        
        return groundOverlayRenderer;
    }
    
    
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *render = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return render;
    }
    
    
    return nil;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

/* 连续定位回调函数 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);

    [SocketManager sharedSocket].baseModel.lat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    [SocketManager sharedSocket].baseModel.lng = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
//    if (reGeocode.city != nil) {
//        NSLog(@"reGeocode:%@", reGeocode.city);
//        NSMutableString *cityName = [NSMutableString stringWithString:reGeocode.city];
//        NSRange r1 = [reGeocode.city rangeOfString:@"市"];
//        [cityName deleteCharactersInRange:r1];
//        [SocketManager sharedSocket].baseModel.city = cityName;
//        [SocketManager sharedSocket].baseModel.adCode = reGeocode.adcode;
//    }
    
    //景区语音的自动播报
    if (self.isPlayMusic && !self.isGuide &&self.isInSpot) {
        CLLocationCoordinate2D loc1 = location.coordinate;
        for (AnnotationBaseModel *model in self.scenicSpotMusicArr) {
            //计算景区和自身的距离
            CLLocationCoordinate2D loc2 = CLLocationCoordinate2DMake([model.lat floatValue], [model.lng floatValue]);
            MAMapPoint p1 = MAMapPointForCoordinate(loc1);
            MAMapPoint p2 = MAMapPointForCoordinate(loc2);
            CLLocationDistance distance =  MAMetersBetweenMapPoints(p1, p2);
            if (distance <=  100 && (self.annotationBaseModel.attractionsname != model.attractionsname)) {
                self.annotationBaseModel.attractionsname = model.attractionsname;
                for (NSDictionary *dic in model.music) {
                    MusicModel *music = [MusicModel parse:dic];
                    //根据本地语种判断
                    NSInteger languageid;
                    if ([Common getAsynchronousWithKey:kLanguageType] == nil) {
                        languageid = [AVPlayerManager shareManager].languageid;
                    } else {
                        languageid = [[Common getAsynchronousWithKey:kLanguageType] integerValue];
                    }
                    if (music.languageid == languageid) {
                        if (music.musicurl == nil) {
                            [AlertManager toastMessage:@"抱歉,没有该国语音ε(┬┬﹏┬┬)3" inView:self.view];
                        }else {
                            [[AVPlayerManager shareManager] setAVPlayerUrl:music.musicurl];
                            [[AVPlayerManager shareManager] avPlayerPlay];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - MapViewAnnotation Delegate


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomAnnotation class]])
    {
         CustomAnnotation *customAnnotation = (CustomAnnotation*)annotation;
        if (customAnnotation.isHelp) {
            //一键求助标注
            static NSString *helpReuseIndetifier = @"helpReuseIndetifier";
            
            HelpAnnotationView *annotationView = (HelpAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:helpReuseIndetifier];
            
            if (annotationView == nil) {
                annotationView = [[HelpAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:helpReuseIndetifier];
                // must set to NO, so we can show the custom callout view.
                annotationView.canShowCallout = NO;
                annotationView.calloutOffset = CGPointMake(0, -5);
            }
            annotationView.userLocation = self.mapView.userLocation.location;
            annotationView.baseModel = customAnnotation.baseModel;
            if (customAnnotation.baseModel.isStaff) {
                annotationView.image = [UIImage imageNamed:@"Personnel"];
            }else {
                annotationView.image = [UIImage imageNamed:@"Tourist"];
            }
            
            __weak typeof(HelpAnnotationView) *weakAnnotationView = annotationView;
            [annotationView setAddSOSBtnBlock:^{
                self.sosResultBtn.hidden = NO;
                if (weakAnnotationView.isHandle) {
                    [AlertManager alertMessage:@"正在处理o(￣▽￣)ｄ"];
                }
                self.resultBaseModel = weakAnnotationView.baseModel;
                weakAnnotationView.isHandle = YES;
            }];
            
            return annotationView;
        } else {
            //首页景区接口查找标注
            static NSString *customReuseIndetifier = @"customReuseIndetifier";
            
            CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
            
            if (annotationView == nil)
            {
                annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
                // must set to NO, so we can show the custom callout view.
                annotationView.canShowCallout = NO;
                annotationView.calloutOffset = CGPointMake(0, -5);
                
            }
            annotationView.userLocation = self.mapView.userLocation.location;
            for (NSDictionary *dic in customAnnotation.baseModel.music) {
                MusicModel *music = [MusicModel parse:dic];
                //根据本地语种判断
                NSInteger languageid;
                if ([Common getAsynchronousWithKey:kLanguageType] == nil) {
                    languageid = [AVPlayerManager shareManager].languageid;
                } else {
                    languageid = [[Common getAsynchronousWithKey:kLanguageType] integerValue];
                }
                
                if (music.languageid == languageid) {
                    annotationView.music = music;
                }
            }
            annotationView.baseModel = customAnnotation.baseModel;
            annotationView.isGuide = customAnnotation.isGuide;
            annotationView.image = [UIImage imageNamed:customAnnotation.imageName];
            
            //如果是导游状态,存入数组
            if (customAnnotation.isGuide == YES) {
                [self.annotationArr addObject:annotationView];
            }
            return annotationView;
        }
        
    }
    //POI检索标注
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.calloutOffset = CGPointMake(0, -5);
            
        }
        annotationView.userLocation = self.mapView.userLocation.location;
        
        annotationView.baseModel.attractionsname = poiAnnotation.poi.name;
        annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"biaozhu%ld", (long)poiAnnotation.annotationIndex]];
        
        return annotationView;
    }

    
    return nil;
}

//当mapView新添加annotation views时调用此接口
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"myAnnotation"];
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-8, -8, -8, -8));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [Common offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        for (CustomAnnotationView *customView in self.annotationArr) {
            if (customView == cusView) {
                customView.isChangeMusicurl = NO;
                self.customAnnotationView = cusView;
            }else {
                customView.isChangeMusicurl = YES;
            }
        }
        
    }
}


#pragma mark - MapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSDictionary *dic = error.userInfo;
    NSLog(@"userinfo %@", dic);
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        POIAnnotation *poi = [[POIAnnotation alloc] initWithPOI:obj];
        poi.annotationIndex = idx;
        [poiAnnotations addObject:poi];
        
    }];
//    POIAnnotation *userLoc = (POIAnnotation *)self.userLocationAnnotationView.annotation;
//    [poiAnnotations addObject:userLoc];
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations edgePadding:UIEdgeInsetsMake(100, 100, 100, 100) animated:YES];
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    }
}
//天气查询回调
- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response
{
    if (request.type == AMapWeatherTypeLive)
    {
        if (response.lives.count == 0)
        {
            return;
        }
        
        AMapLocalWeatherLive *liveWeather = [response.lives firstObject];
        if (liveWeather != nil)
        {
            [self.weatherView updateWeatherWithInfo:liveWeather];
        }
    }
}

#pragma mark - Initialization

- (void)initGroundOverlay
{
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake([self.overlayModel.daolanlatlng.late floatValue], [self.overlayModel.daolanlatlng.lnge floatValue]),CLLocationCoordinate2DMake([self.overlayModel.daolanlatlng.lat floatValue], [self.overlayModel.daolanlatlng.lng floatValue]));
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.overlayModel.daolanpngurl]]];
    
    self.groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:image];
    
    [self.mapView addOverlay:self.groundOverlay];
    self.mapView.visibleMapRect = self.groundOverlay.boundingMapRect;
    
}

#pragma mark - Life Cycle

- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Load
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        //开始定位
        [_locationManager startUpdatingLocation];
        
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

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
//        [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
        // 开启定位
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
        
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (UIButton *)sosBtn {
    if (!_sosBtn) {
        _sosBtn = [[UIButton alloc] init];
        [self.view addSubview:_sosBtn];
        [_sosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(75);
            make.right.mas_equalTo(self.view).offset(-10);
            make.top.mas_equalTo(self.view).offset(50);
        }];
        [_sosBtn setImage:[UIImage imageNamed:@"sos"] forState:UIControlStateNormal];
        [_sosBtn addTarget:self action:@selector(sosBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _sosBtn.hidden = YES;
    }
    return _sosBtn;
}

- (UIButton *)sosResultBtn {
    if (!_sosResultBtn) {
        _sosResultBtn = [[UIButton alloc] init];
        [self.view addSubview:_sosResultBtn];
        [_sosResultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(50);
            make.right.mas_equalTo(self.view).offset(-10);
            make.top.mas_equalTo(self.view).offset(50);
        }];
        _sosResultBtn.backgroundColor = RGBColor(248, 117, 69);
        [_sosResultBtn setTitle:@"处理完成" forState:UIControlStateNormal];
        [_sosResultBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _sosResultBtn.layer.cornerRadius = 4;
        _sosResultBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _sosResultBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _sosResultBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _sosResultBtn.layer.shadowRadius = 2;//阴影半径，默认3
        _sosResultBtn.hidden = YES;
        
        [_sosResultBtn addTarget:self action:@selector(sosResultBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sosResultBtn;
}
- (UIBarButtonItem *)fixedSpace1 {
    if (!_fixedSpace1) {
        _fixedSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _fixedSpace1.width = (kMainScreenWidth - 4 * 28) / 5;
    }
    return _fixedSpace1;
}

- (UIBarButtonItem *)fixedSpace2 {
    if (!_fixedSpace2) {
        _fixedSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _fixedSpace2.width = (kMainScreenWidth - 4 * 28) / 5 - 16;
    }
    return _fixedSpace2;
}

- (UIBarButtonItem *)btnItem1 {
    if (!_btnItem1) {
        UIButton *button = [Common addBtnWithImage:@"search"];
        [button addTarget:self action:@selector(mapSerach) forControlEvents:UIControlEventTouchUpInside];
        _btnItem1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _btnItem1;
}

- (UIBarButtonItem *)btnItem2 {
    if (!_btnItem2) {
        UIButton *button = [Common addBtnWithImage:@"camera"];
        [button addTarget:self action:@selector(jumpCamera) forControlEvents:UIControlEventTouchUpInside];
        _btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:button];

    }
    return _btnItem2;
}

- (UIBarButtonItem *)btnItem3 {
    if (!_btnItem3) {
        UIButton *button = [Common addBtnWithImage:@"shao-yi-shao"];
        [button addTarget:self action:@selector(saoyisao) forControlEvents:UIControlEventTouchUpInside];
        _btnItem3 = [[UIBarButtonItem alloc] initWithCustomView:button];

    }
    return _btnItem3;
}

- (UIBarButtonItem *)btnItem4 {
    if (!_btnItem4) {
        UIButton *button = [Common addBtnWithImage:@"notifications-1"];
        [button addTarget:self action:@selector(notiCenter) forControlEvents:UIControlEventTouchUpInside];
        _btnItem4 = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        _badgeLab = [Common badgeNumLabWithFrame:CGRectMake(18, -5, 20, 20)];
        [button addSubview:_badgeLab];

    }
    return _btnItem4;
}

- (UIView * )parkingView {
    if (!_parkingView) {
        _parkingView = [Common addViewWithFrame:CGRectMake(15, 50, 70, 40)];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [button setImage:[UIImage imageNamed:@"saveCar"] forState:UIControlStateNormal];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(button.right , 0, 40, 40)];
        lable.text = @"存车";
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = kColorMajor;
        
        UIButton *parkingBtn = [[UIButton alloc] initWithFrame:_parkingView.bounds];
        [parkingBtn addTarget:self action:@selector(userParking) forControlEvents:UIControlEventTouchUpInside];
        
        [_parkingView addSubview:button];
        [_parkingView addSubview:lable];
        [_parkingView addSubview:parkingBtn];
        
        [self.view addSubview:_parkingView];
    }
    return _parkingView;
}

- (UIButton *)gpsButton {
    if (!_gpsButton) {
        _gpsButton = [[UIButton alloc] init];
        [self.view addSubview:_gpsButton];
        
        [_gpsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.left.mas_equalTo(self.view).offset(15);
            make.bottom.mas_equalTo(self.view).offset(-25);
        }];
        _gpsButton.backgroundColor = [UIColor whiteColor];
        _gpsButton.layer.cornerRadius = 4;
        _gpsButton.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _gpsButton.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _gpsButton.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _gpsButton.layer.shadowRadius = 2;//阴影半径，默认3
        
        [_gpsButton setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
        [_gpsButton addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _gpsButton;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [Common addViewWithFrame:CGRectMake(15, kMainScreenHeight * 0.2, 45, 100)];
        
        _findBtn = [self addBtnWithFrame:CGRectMake(0, 0, 45, 50) andImageName:@"chazhao"  andImageHei:@"chazhao2" andTag:100 andMethod:@selector(mainMenu:)];
        _hotBtn = [self addBtnWithFrame:CGRectMake(0, 50, 45, 50) andImageName:@"hotView" andImageHei:@"hotView2" andTag:200 andMethod:@selector(mainMenu:)];
        _guideBtn = [self addBtnWithFrame:CGRectMake(0, 100, 45, 50) andImageName:@"daoyou" andImageHei:@"daoyou2" andTag:300 andMethod:@selector(mainMenu:)];
         _languagesBtn = [self addBtnWithFrame:CGRectMake(0, 150, 45, 50) andImageName:@"languege" andImageHei:@"languege2" andTag:400 andMethod:@selector(mainMenu:)];
        _lineBtn = [self addBtnWithFrame:CGRectMake(0, 200, 45, 50) andImageName:@"xianlu" andImageHei:@"xianlu2" andTag:500 andMethod:@selector(mainMenu:)];
        
        _guideBtn.hidden = YES;
        _languagesBtn.hidden = YES;
        _lineBtn.hidden = YES;
        
        [_menuView addSubview:_findBtn];
        [_menuView addSubview:_hotBtn];
        [_menuView addSubview:_guideBtn];
        [_menuView addSubview:_lineBtn];
        [_menuView addSubview:_languagesBtn];
        
        [self.view addSubview:_menuView];
    }
    return _menuView;
}

- (UIView *)menuView2 {
    if (!_menuView2) {
        _menuView2 = [Common addViewWithFrame:CGRectMake(62, kMainScreenHeight * 0.2, 45, 50)];
        
        _findCarBtn = [self addBtnWithFrame:CGRectMake(0, 0, 45, 50) andImageName:@"zhaoche" andImageHei:@"zhaoche1" andTag:600 andMethod:@selector(findMenu:)];
        _WCBtn = [self addBtnWithFrame:CGRectMake(0, 50, 45, 50) andImageName:@"WC" andImageHei:@"WC1" andTag:700 andMethod:@selector(findMenu:)];
        _cateringBtn = [self addBtnWithFrame:CGRectMake(0, 100, 45, 50) andImageName:@"canyin" andImageHei:@"canyin1" andTag:800 andMethod:@selector(findMenu:)];
        _ticketOfficeBtn = [self addBtnWithFrame:CGRectMake(0, 150, 45, 50) andImageName:@"shoupianchu" andImageHei:@"shoupianchu1" andTag:900 andMethod:@selector(findMenu:)];
        _parkingLotBtn = [self addBtnWithFrame:CGRectMake(0, 200, 45, 50) andImageName:@"tcc" andImageHei:@"tcc1" andTag:1000 andMethod:@selector(findMenu:)];
        _canteenBtn = [self addBtnWithFrame:CGRectMake(0, 250, 45, 50) andImageName:@"xiaomaibu" andImageHei:@"xiaomaibu1" andTag:1100 andMethod:@selector(findMenu:)];
        
        _WCBtn.hidden = YES;
        _cateringBtn.hidden = YES;
        _ticketOfficeBtn.hidden = YES;
        _parkingLotBtn.hidden = YES;
        _canteenBtn.hidden = YES;
        
        [_menuView2 addSubview:_findCarBtn];
        [_menuView2 addSubview:_WCBtn];
        [_menuView2 addSubview:_cateringBtn];
        [_menuView2 addSubview:_ticketOfficeBtn];
        [_menuView2 addSubview:_parkingLotBtn];
        [_menuView2 addSubview:_canteenBtn];
        
        _menuView2.hidden = YES;
        
        [self.view addSubview:_menuView2];
        
    }
    return  _menuView2;
}

- (UIView *)languageMenu {
    if (!_languageMenu) {
        _languageMenu = [Common addViewWithFrame:CGRectMake(62, kMainScreenHeight * 0.2, 45, 200)];
        for (int i = 0; i < 4; i ++) {
            UIButton *button = [self addBtnWithFrame:CGRectMake(0, i * 50, 45, 50) andImageName:[NSString stringWithFormat:@"language%d",i] andImageHei:[NSString stringWithFormat:@"languageHei%d",i] andTag:1200 + i * 100 andMethod:@selector(changeLanguage:)];
            [_languageMenu addSubview:button];
        }
        _languageMenu.hidden = YES;
        [self.view addSubview:_languageMenu];
    }
    return _languageMenu;
}

- (NSMutableArray *)mainMenuArr {
    if (!_mainMenuArr) {
        _mainMenuArr = [NSMutableArray new];
    }
    return _mainMenuArr;
}

- (NSMutableArray *)imageViewArr {
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray new];
    }
    return _imageViewArr;
}

- (NSMutableDictionary *)userCarLocationDic {
    if (!_userCarLocationDic) {
        _userCarLocationDic = [NSMutableDictionary new];
    }
    return _userCarLocationDic;
}

- (AMapSearchAPI * )POISearch {
    if (!_POISearch) {
        _POISearch = [[AMapSearchAPI alloc] init];
        _POISearch.delegate = self;
    }
    return _POISearch;
}

- (OverlayModel *)overlayModel {
    if (!_overlayModel) {
        _overlayModel = [[OverlayModel alloc] init];
    }
    return _overlayModel;
}

- (NSMutableArray *)annotationArr {
    if (!_annotationArr) {
        _annotationArr = [[NSMutableArray alloc] init];
    }
    return _annotationArr;
}

- (NSMutableArray *)scenicSpotMusicArr {
    if (!_scenicSpotMusicArr) {
        _scenicSpotMusicArr = [[NSMutableArray alloc] init];
    }
    return _scenicSpotMusicArr;
}

- (AnnotationBaseModel *)annotationBaseModel {
    if (!_annotationBaseModel) {
        _annotationBaseModel = [[AnnotationBaseModel alloc] init];
    }
    return _annotationBaseModel;
}

- (AnnotationBaseModel *)resultBaseModel {
    if (!_resultBaseModel) {
        _resultBaseModel = [[AnnotationBaseModel alloc] init];
    }
    return _resultBaseModel;
}

- (NSMutableArray *)languageArr {
    if (!_languageArr) {
        _languageArr = [[NSMutableArray alloc] init];
    }
    return _languageArr;
}

- (WeatherView *)weatherView {
    if (!_weatherView) {
        _weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 35)];
        [_weatherView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchLiveWeather)]];
        [self.view addSubview:_weatherView];
    }
    return _weatherView;
}

- (CustomAnnotationView *)customAnnotationView {
    if (!_customAnnotationView) {
        _customAnnotationView = [[CustomAnnotationView alloc] init];
    }
    return _customAnnotationView;
}
@end
