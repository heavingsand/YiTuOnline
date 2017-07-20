//
//  PeripheryTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/28.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "PeripheryModel.h"

@interface PeripheryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *scenicspotRimPicture;
@property (weak, nonatomic) IBOutlet UILabel *scenicspotRimName;
@property (weak, nonatomic) IBOutlet UILabel *scenicspotRimType;
@property (weak, nonatomic) IBOutlet UILabel *scenicspotRimStar;
@property (weak, nonatomic) IBOutlet UILabel *scenicspotRimPrice;
@property (weak, nonatomic) IBOutlet UILabel *scenicspotRimAdress;
@property (weak, nonatomic) IBOutlet UILabel *scenicspotRimDistance;

- (void)setCellContent:(ScenicspotRimModel *)model;

@end
