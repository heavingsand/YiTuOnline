//
//  MineTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/13.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.leftView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.leftView];
        self.leftView.contentMode = UIViewContentModeCenter;
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.left.mas_equalTo(5);
            make.centerY.mas_equalTo(0);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = kColorMajor;
        self.label.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.left.mas_equalTo(self.leftView.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(0);
        }];
        
        self.rightView = [[UIImageView alloc] init];
        [self.rightView setImage:[UIImage imageNamed:@"MineIcon1_goto"]];
        self.rightView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.rightView];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 17));
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
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
        self.lineView.hidden = YES;
    }
    return self;
}

- (void)setImageView:(NSString *)imageName andText:(NSString *)text {
    [self.leftView setImage:[UIImage imageNamed:imageName]];
    self.label.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
