//
//  PeripheryTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/28.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "PeripheryTableViewCell.h"

@implementation PeripheryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.scenicspotRimPicture.layer.cornerRadius = 5;
    self.scenicspotRimPicture.clipsToBounds = YES;
    self.scenicspotRimType.textColor = RGBColor(248, 117, 69);
    self.scenicspotRimStar.textColor = RGBColor(250, 226, 53);
}

- (void)setCellContent:(ScenicspotRimModel *)model {
    [self.scenicspotRimPicture sd_setImageWithURL:[NSURL URLWithString:model.scenicspotRimPicture]];
    self.scenicspotRimName.text = model.scenicspotRimName;
    self.scenicspotRimType.text = model.scenicspotRimType;
    //★★★★★
    if (model.starLove == 5) {
        self.scenicspotRimStar.text = @"★★★★★";
    }
    if (model.starLove == 4) {
        self.scenicspotRimStar.text = @"★★★★";
    }
    if (model.starLove == 3) {
        self.scenicspotRimStar.text = @"★★★";
    }
    if (model.starLove == 2) {
        self.scenicspotRimStar.text = @"★★";
    }
    if (model.starLove == 1) {
        self.scenicspotRimStar.text = @"★";
    }
    
    self.scenicspotRimPrice.text = [NSString stringWithFormat:@"人均: ¥%@",model.price];
    self.scenicspotRimAdress.text = [NSString stringWithFormat:@"位于: %@", model.place];
    if (model.distance < 1000) {
        self.scenicspotRimDistance.text = [NSString stringWithFormat:@"距离: %ld米", (long)model.distance];
    } else {
        NSInteger distance = (long)model.distance / 1000;
        self.scenicspotRimDistance.text = [NSString stringWithFormat:@"距离: %ldkm", (long)distance];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
