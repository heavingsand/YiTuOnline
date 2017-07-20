//
//  PreformanceTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "PreformanceTableViewCell.h"

@implementation PreformanceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageName.layer.cornerRadius = 5;
    self.imageName.clipsToBounds = YES;
}

- (void)setCellContent:(PerformanceModel *)model {
    [self.imageName sd_setImageWithURL:[NSURL URLWithString:model.showPicture]];
    self.showName.text = model.showName;
    self.showAdress.text = [NSString stringWithFormat:@"地点: %@", model.showPlace];
    self.showTime.text = [NSString stringWithFormat:@"时间: %@", model.showDateTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
