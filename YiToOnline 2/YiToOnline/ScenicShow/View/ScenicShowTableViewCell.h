//
//  ScenicShowTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/21.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScenicShowTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *starLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UIView *lineView;

- (void)setImage:(NSString *)imageUrl andTitle:(NSString *)title andStar:(NSString *)star andPrice:(NSInteger )price;

@end
