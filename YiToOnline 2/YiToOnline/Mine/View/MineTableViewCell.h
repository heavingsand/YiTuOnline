//
//  MineTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/13.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong) UIView *lineView;

- (void)setImageView:(NSString *)imageName andText:(NSString *)text;
@end
