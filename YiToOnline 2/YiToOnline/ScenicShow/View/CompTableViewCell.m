//
//  CompTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/26.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "CompTableViewCell.h"

@implementation CompTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.cornerRadius = 10;
    self.complainName.textColor = kColorMajor;
    self.complainTime.textColor = kColorMajor;
    self.complainContent.textColor = kColorMajor;
    self.replyTime.textColor = kColorMajor;
    self.replyContent.textColor = kColorMajor;
//    self.complainName.adjustsFontSizeToFitWidth = YES;
    
     self.noReplyImage.transform=CGAffineTransformMakeRotation(-M_PI*0.2);
}

- (void)setCellContent:(ComplainModel *)model {
    self.complainName.text = model.scenicspotname;
    self.complainTime.text = model.complaintstime;
    self.complainContent.text = model.complaints;
    self.replyContent.text = model.reply;
    self.replyTime.text = model.replytime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
