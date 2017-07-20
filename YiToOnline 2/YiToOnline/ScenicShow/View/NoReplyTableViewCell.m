//
//  NoReplyTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/26.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "NoReplyTableViewCell.h"

@implementation NoReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.cornerRadius = 10;
    self.complainName.textColor = kColorMajor;
    self.complainTime.textColor = kColorMajor;
    self.complainContent.textColor = kColorMajor;
}

- (void)setCellContent:(ComplainModel *)model {
    self.complainName.text = model.scenicspotname;
    self.complainTime.text = model.complaintstime;
    self.complainContent.text = model.complaints;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
