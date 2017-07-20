//
//  PreformanceTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceModel.h"
#import <UIImageView+WebCache.h>

@interface PreformanceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageName;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UILabel *showAdress;
@property (weak, nonatomic) IBOutlet UILabel *showTime;

- (void)setCellContent:(PerformanceModel *)model;

@end
