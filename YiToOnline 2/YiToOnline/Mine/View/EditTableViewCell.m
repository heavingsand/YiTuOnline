//
//  EditTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/13.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "EditTableViewCell.h"

@implementation EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //名称
        self.label = [[UILabel alloc] init];
        self.label.textColor = kColorMajor;
        self.label.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        
        
        //右箭头
        self.rightView = [[UIImageView alloc] init];
        [self.rightView setImage:[UIImage imageNamed:@"MineIcon1_goto"]];
        self.rightView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.rightView];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 17));
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        
        //右边信息
        self.rightLab = [[UILabel alloc] init];
        self.rightLab.textColor = RGBColor(125, 125, 125);
        self.rightLab.font = [UIFont systemFontOfSize:15];
        self.rightLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.rightLab];
        [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.right.mas_equalTo(self.rightView.mas_left).mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
        }];
        self.rightLab.hidden = YES;
        
        //右边头像
        self.userImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userImage];
//        self.userImage.contentMode = UIViewContentModeCenter;
        self.userImage.layer.cornerRadius = 40;
        self.userImage.clipsToBounds = YES;
        [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.right.mas_equalTo(self.rightView.mas_left).mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
        }];
        self.userImage.hidden = YES;

        
        //底部横线
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

- (void)setText:(NSString *)text {

    self.label.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
