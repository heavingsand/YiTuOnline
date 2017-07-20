//
//  ComplainTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/23.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainModel.h"

@interface ComplainTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *scenicspotnameLab;//投诉景区名称
@property (nonatomic, strong) UILabel *complaintstimeLab;//投诉时间
@property (nonatomic, strong) UILabel *complaintsLab;//投诉内容
@property (nonatomic, strong) UILabel *replyLab;//景区回复
@property (nonatomic, strong) UILabel *replytimeLab;//处理时间
@property (nonatomic, strong) UIImageView *replyImage;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *lab4;
@property (nonatomic, strong) UILabel *lab5;

- (void)setCellContent:(ComplainModel *)model;

@end
