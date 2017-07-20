//
//  CompTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/26.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainModel.h"

@interface CompTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *complainTime;
@property (weak, nonatomic) IBOutlet UILabel *complainName;
@property (weak, nonatomic) IBOutlet UILabel *complainContent;
@property (weak, nonatomic) IBOutlet UILabel *replyTime;
@property (weak, nonatomic) IBOutlet UILabel *replyContent;
@property (weak, nonatomic) IBOutlet UIImageView *noReplyImage;


- (void)setCellContent:(ComplainModel *)model;

@end
