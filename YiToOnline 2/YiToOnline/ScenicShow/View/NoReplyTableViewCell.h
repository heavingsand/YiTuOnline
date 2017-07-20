//
//  NoReplyTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/26.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainModel.h"

@interface NoReplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *complainName;
@property (weak, nonatomic) IBOutlet UILabel *complainTime;
@property (weak, nonatomic) IBOutlet UILabel *complainContent;


- (void)setCellContent:(ComplainModel *)model;

@end
