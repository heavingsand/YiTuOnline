//
//  Common.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/2.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "Common.h"

@implementation Common

#pragma 数据持久化
+ (void)setAsynchronous:(id)object WithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearAsynchronousWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getAsynchronousWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+(CGSize)sizeWithString:(NSString *)string width:(float)width font:(float)font{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    CGRect detailsSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                          
                                              options:NSStringDrawingUsesLineFragmentOrigin
                          
                                           attributes:attributes
                          
                                              context:nil];
    
    return detailsSize.size;
}

#pragma mark 共通说明Label
+(UILabel *)labelExplainedWithFrame:(CGRect)frame
{
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:frame];
    explainLabel.backgroundColor = [UIColor clearColor];
    [explainLabel setFont:[UIFont systemFontOfSize:13]];
    explainLabel.textColor = kColorMajor;
    explainLabel.numberOfLines = 4;
    return explainLabel;
}

#pragma 字符串遍历
+ (CGFloat)content:(NSString *)s {
    int i;CGFloat n=[s length],l=0,a=0,b=0;
    CGFloat wLen=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];//按顺序取出单个字符
        if(isblank(c)){//判断字符串为空或为空格
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
        wLen=l+b+(CGFloat)((CGFloat)a/4.0);
        NSLog(@"wLen--%f",wLen);
    }
    if(a==0 && l==0)
    {
        return 0;//只有isblank
    }
    else{
        return wLen;//长度，中文占1，英文等能转ascii的占0.25
    }
}

#pragma mark 线的图片
+(UIImageView *)lineViewWithFrame:(CGRect)frame
{
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:frame];
    lineImageView.backgroundColor = kColorLine;
    return lineImageView;
}

#pragma mark 手机号判断方法
+ (BOOL)judgeMobileNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

+ (void)addBackItemToVC:(UIViewController *)vc{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setImage:[UIImage imageNamed:@"返回_默认"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"返回_按下"] forState:UIControlStateHighlighted];
    
    //把视图的边角变为圆形, cornerRadius圆角半径
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //弹簧控件, 修复边距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    vc.navigationItem.leftBarButtonItems = @[spaceItem,backItem];
}

+(UIBarButtonItem *)noTitlebackBtnWithTarget:(id)target selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14, 25)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"left_btn"] forState:UIControlStateHighlighted];
    [btn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn setTitle:@"　　" forState:UIControlStateNormal];
    [btn setTitleShadowColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
//控件的快捷生成
+ (UIButton *)addBtnWithImage:(NSString *)imageName {
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode : UIImageRenderingModeAlwaysOriginal];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    return button;
}


+ (UIView *)addViewWithFrame :(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = kColorWhite;
    view.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 2;//阴影半径，默认3
    view.layer.cornerRadius = 5;
    return view;
}

+ (UILabel *)badgeNumLabWithFrame:(CGRect)frame
{
    UILabel *badgeNumLab = [[UILabel alloc] initWithFrame:frame];
    badgeNumLab.backgroundColor = RGBColor(247, 62, 67);
    badgeNumLab.font = [UIFont systemFontOfSize:12];
    badgeNumLab.layer.cornerRadius = 10;
    badgeNumLab.clipsToBounds = YES;
    badgeNumLab.textAlignment = NSTextAlignmentCenter;
    badgeNumLab.textColor = [UIColor whiteColor];
    badgeNumLab.hidden = YES;
    return badgeNumLab;
}

+(NSString *)formatWithDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (void)layoutBadge:(UILabel *)badgeLab andCount:(NSInteger)count
{
    if (count > 0) {
        badgeLab.hidden = NO;
        badgeLab.text = [NSString stringWithFormat:@"%ld",count];
        if (count > 10) {
            badgeLab.width = 26;
        }else{
            badgeLab.width = 20;
        }
    }else{
        badgeLab.hidden = YES;
    }
}

+(void)setUpNavBar:(UINavigationBar *)navigationBar {
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [[UIImage alloc] init];
}

#pragma mark -崩溃日志发送邮件给开发者
+(void)catchEexceptionMailToDeveloperWithNSException:(NSException *)exception{
    
    /** 获取异常崩溃信息 **/
    NSArray* callStack = [exception callStackSymbols];
    //NSLog(@"%s,%s,%d",__FUNCTION__,__FILE__,__LINE__);
    
    NSString* reason = [exception reason];
    NSString* name = [exception name];
//    NSString *appVersion = [Tools getAppVersion];
    NSString *osSystemVersion = [[UIDevice currentDevice] systemVersion];
//    NSString *deviceModel = [Tools getCurrentDeviceModel];
//    NSString* content =
//    [NSString stringWithFormat:@"======异常错误报告======\nname:\n%@\nreason:"
//     @"\n%@\n\ncrashFile:%@\ncrashFunc:%@\n\ncallStackSymbols:\n%@\n",
//     name, reason,osSystemVersion,
//     [callStack componentsJoinedByString:@"\n"]];
    NSString* content =
    [NSString stringWithFormat:@"======异常错误报告======\nname:\n%@\nreason:"
     @"\n%@\n\n\nosSystemVersion:%@\n\ncallStackSymbols:\n%@\n",
     name, reason,osSystemVersion,
     [callStack componentsJoinedByString:@"\n"]];
    //Application received signal SIGABRT
    //Application received signal SIGSEGV
    /** 把异常崩溃信息发送至开发者邮件 **/
    NSMutableString* mailUrl = [NSMutableString string];
    [mailUrl appendString:@"mailTo:aa943147350@163.com"];
    
    [mailUrl
     appendString:
     @"?subject=程序异常崩溃, 请配合发送异常报告, 我们会尽快解决, 谢谢!"];
    [mailUrl appendFormat:@"&body=%@",content];
    
    /** 打开地址 **/
    NSString* mailPath =
    [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
}
//- (NSData *)UTF8Data {
//    //保存结果
//    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:self.length];
//    
//    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];
//    
//    uint64_t index = 0;
//    const uint8_t *bytes = self.bytes;
//    
//    long dataLength = (long) self.length;
//    
//    while (index < dataLength) {
//        uint8_t len = 0;
//        uint8_t firstChar = bytes[index];
//        
//        // 1个字节
//        if ((firstChar & 0x80) == 0 && (firstChar == 0x09 || firstChar == 0x0A || firstChar == 0x0D || (0x20 <= firstChar && firstChar <= 0x7E))) {
//            len = 1;
//        }
//        // 2字节
//        else if ((firstChar & 0xE0) == 0xC0 && (0xC2 <= firstChar && firstChar <= 0xDF)) {
//            if (index + 1 < dataLength) {
//                uint8_t secondChar = bytes[index + 1];
//                if (0x80 <= secondChar && secondChar <= 0xBF) {
//                    len = 2;
//                }
//            }
//        }
//        // 3字节
//        else if ((firstChar & 0xF0) == 0xE0) {
//            if (index + 2 < dataLength) {
//                uint8_t secondChar = bytes[index + 1];
//                uint8_t thirdChar = bytes[index + 2];
//                
//                if (firstChar == 0xE0 && (0xA0 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
//                    len = 3;
//                } else if (((0xE1 <= firstChar && firstChar <= 0xEC) || firstChar == 0xEE || firstChar == 0xEF) && (0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
//                    len = 3;
//                } else if (firstChar == 0xED && (0x80 <= secondChar && secondChar <= 0x9F) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
//                    len = 3;
//                }
//            }
//        }
//        // 4字节
//        else if ((firstChar & 0xF8) == 0xF0) {
//            if (index + 3 < dataLength) {
//                uint8_t secondChar = bytes[index + 1];
//                uint8_t thirdChar = bytes[index + 2];
//                uint8_t fourthChar = bytes[index + 3];
//                
//                if (firstChar == 0xF0) {
//                    if ((0x90 <= secondChar & secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
//                        len = 4;
//                    }
//                } else if ((0xF1 <= firstChar && firstChar <= 0xF3)) {
//                    if ((0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
//                        len = 4;
//                    }
//                } else if (firstChar == 0xF3) {
//                    if ((0x80 <= secondChar && secondChar <= 0x8F) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
//                        len = 4;
//                    }
//                }
//            }
//        }
//        // 5个字节
//        else if ((firstChar & 0xFC) == 0xF8) {
//            len = 0;
//        }
//        // 6个字节
//        else if ((firstChar & 0xFE) == 0xFC) {
//            len = 0;
//        }
//        
//        if (len == 0) {
//            index++;
//            [resData appendData:replacement];
//        } else {
//            [resData appendBytes:bytes + index length:len];
//            index += len;
//        }
//    }
//    
//    return resData;
//}
@end
