//
//  ScenicShowTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/21.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ScenicShowTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation ScenicShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //图片
        self.headImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImage];
        self.headImage.layer.cornerRadius = 4;
        self.headImage.clipsToBounds = YES;
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(80, 80));
            make.left.mas_offset(10);
            make.centerY.mas_equalTo(0);
        }];
        
        //标题
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textColor = RGBColor(60, 60, 60);
        self.titleLab.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - self.headImage.width - 30, 25));
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(10);
        }];
        
        //星级
        self.starLab = [[UILabel alloc] init];
        self.starLab.textColor = kColorMajor;
        self.starLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.starLab];
        [self.starLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - self.headImage.width - 30, 25));
            make.top.mas_equalTo(self.titleLab.mas_bottom);
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(10);
        }];
        //价格
        self.priceLab = [[UILabel alloc] init];
        self.priceLab.textColor = RGBColor(248, 117, 69);
        self.priceLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - self.headImage.width - 30, 25));
            make.bottom.mas_equalTo(-8);
            make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(10);
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGBColor(241, 241, 241);
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setImage:(NSString *)imageUrl andTitle:(NSString *)title andStar:(NSString *)star andPrice:(NSInteger )price {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.titleLab.text = title;
    self.starLab.text = [NSString stringWithFormat:@"%@级景区",star];
    self.priceLab.text = [NSString stringWithFormat:@"%ld¥",(long)price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
