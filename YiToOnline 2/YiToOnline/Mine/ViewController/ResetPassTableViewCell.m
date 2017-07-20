//
//  ResetPassTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/13.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ResetPassTableViewCell.h"

@implementation ResetPassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = RGBColor(66, 66, 66);
        self.label.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        self.label.adjustsFontSizeToFitWidth = YES;
        
        self.textField = [[UITextField alloc] init];
        self.textField.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 40));
            make.left.mas_equalTo(self.label.mas_right);
            make.centerY.mas_equalTo(0);
        }];
//        [self.textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
        
        self.codeBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.codeBtn];
        [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
        }];
        self.codeBtn.backgroundColor = RGBColor(248, 117, 69);
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.codeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [self.codeBtn setTitle:@"重新发送" forState:UIControlStateSelected];
        [self.codeBtn setTitleColor:kColorWhite forState:UIControlStateSelected];
        self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.codeBtn.layer.cornerRadius = 5;
        self.codeBtn.hidden = YES;
        [self.codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
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

- (void)codeBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
    }
    if (self.CodeBtnBlock) {
        self.CodeBtnBlock();
    }
}


- (void)textChange {
    
}

- (void)setText:(NSString *)text {
    
    self.label.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
