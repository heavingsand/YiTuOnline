//
//  UserTextViewController.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/14.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTextViewController : UIViewController
@property (nonatomic, copy) NSString *userString;
@property (nonatomic, copy) void (^textFieldBlock)();
@property (nonatomic, strong) UITextField *textField;
@end
