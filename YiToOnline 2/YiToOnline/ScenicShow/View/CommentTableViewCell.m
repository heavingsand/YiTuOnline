//
//  CommentTableViewCell.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headportrait.layer.cornerRadius = 5;
    self.headportrait.clipsToBounds = YES;
    self.comment.textColor = kColorMajor;
    self.commentTime.textColor = kColorMajor;
}

- (void)setCommentWithModel:(CommentModel *)model {
    [self.headportrait sd_setImageWithURL:[NSURL URLWithString:model.headportrait]];
    self.commentTime.text = model.commenttime;
    self.userName.text = model.username;
    self.comment.text = model.comment;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
