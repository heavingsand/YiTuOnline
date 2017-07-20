//
//  UrlPath.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/1.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#ifndef UrlPath_h
#define UrlPath_h

//服务器地址
#define HostAdress @"http://www.yituinfo.cn/Travel/mobile/"
//本地服务器地址
//#define HostAdress @"http://10.10.10.3/Travel/"
//#define HostAdress @"http://192.168.0.102/Travel/"

#define ConvertUrl(relativeUrl) [NSString stringWithFormat:@"%@%@", HostAdress, relativeUrl]

//socket通讯地址
//本地
//#define ServerSocketAdress @"192.168.0.102"
//#define ServerSocketAdress @"10.10.10.3"
//服务器
#define ServerSocketAdress @"120.76.195.81"

//接口
#define kUrl_SpotRange                       ConvertUrl(@"SpotRange.yitu?city=%@&userid=%@")             //判断用户是否在景区
#define kUrl_SetAccountNumber              ConvertUrl(@"setAccountnumber.yitu")                           //注册账号
#define kUrl_codeAccountnumber             ConvertUrl(@"codeAccountnumber.yitu")                         //验证用户是否存在
#define kUrl_updatePassword                 ConvertUrl(@"updatepassword.yitu")                            //忘记密码
#define kUrl_ModificationPassword          ConvertUrl(@"ModificationPassword.yitu")                    //修改密码
#define kUrl_ForgotPassword                 ConvertUrl(@"ForgotPassword.yitu")                            //找回密码
#define kUrl_getiprwa                         ConvertUrl(@"getiprwa.yitu?type=%@&scenicspotsid=%@")    //获取景区停车场,餐厅,售票点,厕所,景点
#define kUrl_getAccountnumber               ConvertUrl(@"getAccountnumber.yitu")                         //用户登录
#define kUrl_AutomaticLogin                  ConvertUrl(@"AutomaticLogin.yitu")                           //APP用户自动登录
#define kUrl_ProvinceCity                    ConvertUrl(@"ProvinceCity.yitu")                              //获取所有省份和市
#define kUrl_ScenicspotsAll                  ConvertUrl(@"ScenicspotsAll.yitu")                           //获取所有景点信息
#define kUrl_idgetscenicspots                ConvertUrl(@"IdGetScenicSpots.yitu")                        //根据景点id查询景点(景点详情)
#define kUrl_citygetidscenicspots           ConvertUrl(@"cityidgetscenicspot.yitu")                    //根据城市id查询所有景点
#define kURl_provinceIdGetScenicspot       ConvertUrl(@"ProvinceidGetScenicspotsid.yitu")           //根据省份id查询景点
#define kUrl_scenicSpotsLike                 ConvertUrl(@"ScenicSpotsLike.yitu")                        //模糊查询景点名称
#define kUrl_CityScenicSpotsLke             ConvertUrl(@"CityScenicSpotsLike.yitu")                   //根据定位景点显示
#define kUrl_EnterRecord                      ConvertUrl(@"EnterRecord.yitu")                             //入园记录
#define kUrl_ReadUserInformation            ConvertUrl(@"ReadUserInformation.yitu")                   //获取用户信息
#define kUrl_UploadPortraitUpdateUser      ConvertUrl(@"UploadPortraitUpdateUser.yitu")             //修改用户信息
#define kUrl_UploadStaff                      ConvertUrl(@"UploadStaff.yitu")                             //修改工作人员信息
#define kUrl_ObtainPush                       ConvertUrl(@"ObtainPush.yitu")                              //通知信息接口
#define kUrl_getComplaintsid                 ConvertUrl(@"getComplaintsid.yitu")                        //获取投诉信息
#define kUrl_setComplaintsid                 ConvertUrl(@"setComplaintsid.yitu")                        //投诉景区
#define kUrl_getCommentpage                  ConvertUrl(@"getCommentpage.yitu?&scenicspotid=%ld&page=%ld&pagecount=%ld")//获取评论
#define kUrl_setComment                       ConvertUrl(@"setComment.yitu")                              //评论景区
#define kUrl_ScIdGetShow                      ConvertUrl(@"ScIdGetShow.yitu")                            //获取表演信息
#define kUrl_ScIdGetScenicspotRim           ConvertUrl(@"ScIdGetScenicspotRim.yitu")                 //景点周边

#endif /* UrlPath_h */
