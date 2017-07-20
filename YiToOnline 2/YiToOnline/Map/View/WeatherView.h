//
//  WeatherView.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/6.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WeatherView : UIView
@property (nonatomic, strong) UIImageView *weatherView;
@property (nonatomic, strong) UILabel *weatherLab;
@property (nonatomic, strong) UILabel *temperatureLab;
@property (nonatomic, strong) UILabel *windPowerLab;
@property (nonatomic, strong) UILabel *humidityLab;

- (void)updateWeatherWithInfo:(AMapLocalWeatherLive *)liveInfo;

@end
