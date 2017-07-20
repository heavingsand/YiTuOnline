//
//  NotiTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/19.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "NotiTableViewCell.h"

@implementation NotiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //红点
        self.redPoint = [[UIImageView alloc] init];
        [self.contentView addSubview:self.redPoint];
        [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.left.mas_equalTo(5);
            make.centerY.mas_equalTo(0);
        }];
        self.redPoint.layer.cornerRadius = 5;
        self.redPoint.clipsToBounds = YES;
        self.redPoint.backgroundColor = KcolorRed;
        self.redPoint.hidden = YES;
        
        //图像
        self.headImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImage];
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.mas_equalTo(self.redPoint.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(0);
        }];
        self.headImage.image = [UIImage imageNamed:@"notihead"];
        self.headImage.layer.cornerRadius = 5;
        self.headImage.clipsToBounds = YES;
        
        //标题
        self.titleLab = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 60, 20));
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(6);
            make.centerY.mas_equalTo(-14);
//            make.top.mas_equalTo(10);
        }];
        self.titleLab.font = [UIFont systemFontOfSize:19];
        
        //内容
        self.subtitleLab = [[UILabel alloc] init];
        [self.contentView addSubview:self.subtitleLab];
        [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 60, 20));
//            make.bottom.mas_equalTo(-10);
            make.centerY.mas_equalTo(8);
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(6);
        }];
        self.subtitleLab.font = [UIFont systemFontOfSize:15];
        self.subtitleLab.textColor = kColorMajor;
        
        //时间
        self.timeLab = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(160, 20));
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-2);
        }];
        self.timeLab.textColor = kColorMajor;
        self.timeLab.font = [UIFont systemFontOfSize:14];
        self.timeLab.textAlignment = NSTextAlignmentRight;
    
    }
    return self;
}

- (void)setTitle:(NSString *)title andSubtitle:(NSString *)suntitle andTime:(NSString *)time {
    self.titleLab.text = title;
    self.subtitleLab.text = suntitle;
    self.timeLab.text = time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
