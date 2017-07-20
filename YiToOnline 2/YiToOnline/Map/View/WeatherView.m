//
//  WeatherView.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/6.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "WeatherView.h"


@implementation WeatherView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.4;
        
        _weatherView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 30, 30)];
        _weatherView.image = [UIImage imageNamed:@"weather1"];
        [self addSubview:_weatherView];
        
        _weatherLab = [[UILabel alloc] initWithFrame:CGRectMake(_weatherView.right, 0, kMainScreenWidth / 4 - 40, 35)];
        _weatherLab.text = @"--";
        _weatherLab.textColor = kColorWhite;
        _weatherLab.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_weatherLab];
        
        _temperatureLab = [[UILabel alloc] initWithFrame:CGRectMake(_weatherLab.right, 0, kMainScreenWidth / 4, 35)];
        _temperatureLab.text = @"--°C";
        _temperatureLab.textColor = kColorWhite;
        _temperatureLab.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_temperatureLab];
        
        _windPowerLab = [[UILabel alloc] initWithFrame:CGRectMake(_temperatureLab.right, 0, kMainScreenWidth / 4, 35)];
        _windPowerLab.text = @"--风 --级";
        _windPowerLab.textColor = kColorWhite;
        _windPowerLab.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_windPowerLab];
        
        _humidityLab = [[UILabel alloc] initWithFrame:CGRectMake(_windPowerLab.right, 0, kMainScreenWidth / 4, 35)];
        _humidityLab.text = @"湿度--%";
        _humidityLab.textColor = kColorWhite;
        _humidityLab.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_humidityLab];
        
    }
    return self;
}


- (void)updateWeatherWithInfo:(AMapLocalWeatherLive *)liveInfo {
    
    if ([liveInfo.weather containsString:@"多云"]) {
        self.weatherView.image = [UIImage imageNamed:@"weather1"];
    }
    if ([liveInfo.weather containsString:@"雷雨"]) {
        self.weatherView.image = [UIImage imageNamed:@"weather2"];
    }
    if ([liveInfo.weather containsString:@"阵雨"]) {
        self.weatherView.image = [UIImage imageNamed:@"weather3"];
    }
    if ([liveInfo.weather containsString:@"阴"]) {
        self.weatherView.image = [UIImage imageNamed:@"weather4"];
    }
    if ([liveInfo.weather containsString:@"晴"]) {
        self.weatherView.image = [UIImage imageNamed:@"weather5"];
    }
    self.weatherLab.text = liveInfo.weather;
    self.temperatureLab.text = [NSString stringWithFormat:@"%@°C",liveInfo.temperature] ;
    self.windPowerLab.text =[NSString stringWithFormat:@"%@风 %@级",liveInfo.windDirection,liveInfo.windPower];
    self.humidityLab.text = [NSString stringWithFormat:@"湿度%@%%",liveInfo.humidity];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
