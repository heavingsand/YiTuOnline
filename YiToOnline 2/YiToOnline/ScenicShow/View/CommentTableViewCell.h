//
//  CommentTableViewCell.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import <UIImageView+WebCache.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet UIImageView *headportrait;

- (void)setCommentWithModel:(CommentModel *)model;

@end
