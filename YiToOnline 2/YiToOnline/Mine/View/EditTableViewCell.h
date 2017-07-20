//
//  EditTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/13.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UIImageView *userImage;

- (void)setText:(NSString *)text;
@end
