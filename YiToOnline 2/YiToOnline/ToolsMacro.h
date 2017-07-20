//
//  ToolsMacro.h
//  CarHelper
//
//  Created by linyingbin on 15/4/23.
//  Copyright (c) 2015年 林 英彬. All rights reserved.
//

#ifndef CarHelper_ToolsMacro_h
#define CarHelper_ToolsMacro_h

// 10进制与16进制颜色值设置
#define UIColorFromRGB_10(r,g,b) \
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorFromRGB_16(rgbValue) \
([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])


#define kColorMajor     UIColorFromRGB_16(0x666666)
#define kColorMin       UIColorFromRGB_16(0x999999)
#define kColorMin2      UIColorFromRGB_16(0xaeaeae)
#define kColorMin3      UIColorFromRGB_16(0xc8c8c8)

#define kColorBg        UIColorFromRGB_16(0xefeff4)
#define kColorBg2       UIColorFromRGB_16(0xf6f6f6)
#define kColorBlue      UIColorFromRGB_16(0x1c95d1)
#define kColorYellow    UIColorFromRGB_16(0xfdd922)
#define kColorPink      UIColorFromRGB_16(0xfb528e)
#define kColorBgBlue    UIColorFromRGB_16(0xc4e0ee)
#define kColorGreen     UIColorFromRGB_16(0x00ba3e)
#define kColorLightBlue UIColorFromRGB_16(0x00b4ff)
#define kColorLightRed  UIColorFromRGB_16(0xff5b45)

#define KcolorHightGray UIColorFromRGB_16(0xbfbfbf)
#define KcoloGray       UIColorFromRGB_16(0xafafaf)
#define KcolorWite      UIColorFromRGB_16(0xffffff)
#define KcoloGreen      UIColorFromRGB_16(0x29b624)
#define KcolorRed       UIColorFromRGB_16(0xfe4747)
#define kColorTitle     UIColorFromRGB_16(0x0096ff)

#define kColorChartLow  UIColorFromRGB_16(0x04ccd3)
#define kColorChartNomal UIColorFromRGB_16(0x888888)
#define kColorLine      UIColorFromRGB_16(0xd9d9d9)
#define kColorOrange    UIColorFromRGB_10(237,103,49)
#define kColorBgNew     UIColorFromRGB_16(0x0b3860)




#define RGBColor(x,y,z)         [UIColor colorWithRed:x/255. green:y/255. blue:z/255. alpha:1]

#define KcolorAppTitle           RGBColor(248,178,13)
#define kColoeLineColor          RGBColor(152,152,152)
#define kColorDarkGray          RGBColor(218,218,218)
#define kColorLightGray         RGBColor(233,233,233)
#define kColorLightGray         RGBColor(233,233,233)

#define kColorWhite             [UIColor whiteColor]

#define kLineHeight     .5

#define KTextAdd            @"Helvetica"

#define kBtnImage [[UIImage imageNamed:@"login_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)]
#define kBtnImage2 [[UIImage imageNamed:@"login_btnclick"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)]

#define kMainScreenFrame [[UIScreen mainScreen] bounds]
#define kMainScreenWidth kMainScreenFrame.size.width
#define kMainScreenHeight kMainScreenFrame.size.height

#define iPhone5   kMainScreenWidth  == 320
#define iPhone6   kMainScreenWidth  == 375
#define iPhone6p  kMainScreenWidth  == 414

#define login_btn_W    200
#define login_btn_H    40
#define login_Btn_X         (kMainScreenWidth - 200)/2

//#define telephoneStr    @"65857532"

#define iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

//主窗口
#define kMainWindow [[[UIApplication sharedApplication] delegate] window]
// NSUserDefaults 实例化
#define kNSUserDefault [NSUserDefaults standardUserDefaults]
#define kRunVersion     @"runVersion"
#define kSearchHistory      @"searchHistory"
#define kLanguageType  @"languageType"
#define kSavedUserPass  @"savedUserPass"
#define kTagsArray      @"tagsArray"
#define kBlackArray     @"blacklist"

//第三方接口appkey
//高德地图
#define kAMPApikey @"20a90364e637820bd645b7b92dd19f8d"
//MOB
#define kMOBApp @"188a662a83c33"
#define kMOBSecret @"a732a05be8346047e80008bbd29087a0"
//百度云推送
#define kBaiduAppID @"8895936"
#define kBaiApiKey @"8M4nzZvOL3IFienrQRgCc9BR"
#define kBaiduSecretKey @"i95w46nIMQLR9FYGeCgfZqyClLTCkscn"
//极光推送
#define kJPushAppkey @"7c23179e63bac2fa6e3fa8ed"
#define kJPushSecret @"0900404b2b9264b9d7e911fe"
//
#define kNotificationCenter         [NSNotificationCenter defaultCenter]
#define kNotifLogout                @"logout"
#define kNotiSOS                @"sosAnnotation"
#define kReloadHead                 @"reloadHead"

/****/
#define kNotifPopVC                 @"popVC"
/****/

#ifdef DEBUG
#define CLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define CLog(format, ...)
#define NSLog(FORMAT, ...) nil
#endif

#endif
