//
//  SOSResultViewController.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/9.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSResultViewController : UIViewController
@property (nonatomic, copy) void (^SOSBtnBlock)();
@property (nonatomic, strong) NSArray *mainArr;
@end
