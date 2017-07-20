//
//  NotiTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/19.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NotiTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *redPoint;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UILabel *timeLab;

- (void)setTitle:(NSString *)title andSubtitle:(NSString *)suntitle andTime:(NSString *)time;
@end
