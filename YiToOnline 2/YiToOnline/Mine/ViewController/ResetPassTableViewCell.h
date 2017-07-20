//
//  ResetPassTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/13.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPassTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) void (^CodeBtnBlock)();
- (void)setText:(NSString *)text;

@end
