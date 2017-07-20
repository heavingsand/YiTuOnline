//
//  ComplainTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/23.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ComplainTableViewCell.h"

@implementation ComplainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.cornerRadius = 10;
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *lab1 = [self addLabel:CGRectMake(10, 10, kMainScreenWidth / 2 -10, 20) andFont:13 andColor:RGBColor(120, 120, 120)];
        lab1.text = @"投诉景区";
        UILabel *lab2 = [self addLabel:CGRectMake(lab1.right, 10, kMainScreenWidth / 2, 20) andFont:13 andColor:RGBColor(120, 120, 120)];
        lab2.text = @"投诉时间";
        
        self.scenicspotnameLab = [self addLabel:CGRectMake(10, lab1.bottom, kMainScreenWidth / 2 -10, 20) andFont:14 andColor:kColorMajor];
        self.complaintstimeLab = [self addLabel:CGRectMake(self.scenicspotnameLab.right, lab2.bottom, kMainScreenWidth/2, 20) andFont:14 andColor:kColorMajor];
        
        UILabel *lab3 = [self addLabel:CGRectMake(10, self.scenicspotnameLab.bottom + 5, kMainScreenWidth - 20, 20) andFont:13 andColor:RGBColor(120, 120, 120)];
        lab3.text = @"投诉内容";
        
//        self.complaintsLab = [self addLabel:CGRectMake(10, lab3.bottom, kMainScreenWidth - 20, 0) andFont:14 andColor:kColorMajor];
        self.complaintsLab = [[UILabel alloc] init];
        [self.contentView addSubview:self.complaintsLab];
        self.complaintsLab.font = [UIFont systemFontOfSize:14];
        self.complaintsLab.textColor = kColorMajor;
        self.complaintsLab.numberOfLines = 0;
//        [self.complaintsLab sizeToFit];
        self.complaintsLab.text = @"xxxxxx";
        [self.complaintsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(lab3.mas_bottom).mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
        }];
        
        self.replyImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.replyImage];
        [self.replyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(85, 35));
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(60);
        }];
        self.replyImage.image = [UIImage imageNamed:@"noReply"];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.complaintsLab.bottom + 5, kMainScreenWidth - 20, 1)];
        self.lineView.backgroundColor = kColorLine;
        [self.contentView addSubview:self.lineView];
        
        self.lab4 = [self addLabel:CGRectMake(10, self.lineView.bottom + 10, kMainScreenWidth / 2 - 10, 20) andFont:13 andColor:RGBColor(120, 120, 120)];
        self.lab4.text = @"景区回复";
        self.lab5 = [self addLabel:CGRectMake(self.lab4.right, self.lineView.bottom + 10, kMainScreenWidth / 2 , 20) andFont:13 andColor:RGBColor(120, 120, 120)];
        self.lab5.text = @"回复时间";
        
        self.replyLab = [self addLabel:CGRectMake(10, self.lab4.bottom, kMainScreenWidth / 2 - 10, 20) andFont:14 andColor:kColorMajor];
        self.replyLab.numberOfLines = 0;
        [self.replyLab sizeToFit];
        
        self.replytimeLab = [self addLabel:CGRectMake(self.replyLab.right, self.lab5.bottom, kMainScreenWidth / 2, 20) andFont:14 andColor:kColorMajor];
    }
    return self;
}

- (UILabel *)addLabel:(CGRect)frame andFont:(NSInteger)font andColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    [self.contentView addSubview:label];
    return label;
}

- (void)setCellContent:(ComplainModel *)model {
//    @property (nonatomic, strong) UILabel *scenicspotnameLab;//投诉景区名称
//    @property (nonatomic, strong) UILabel *complaintstimeLab;//投诉时间
//    @property (nonatomic, strong) UILabel *complaintsLab;//投诉内容
//    @property (nonatomic, strong) UILabel *reply;//景区回复
//    @property (nonatomic, strong) UILabel *replytime;//处理时间
    self.scenicspotnameLab.text = model.scenicspotname;
    self.complaintstimeLab.text = model.complaintstime;
    self.complaintsLab.text = model.complaints;
    self.replyLab.text = model.reply;
    self.replytimeLab.text = model.replytime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
