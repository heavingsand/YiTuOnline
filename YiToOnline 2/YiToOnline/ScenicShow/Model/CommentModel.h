//
//  CommentModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface CommentModel : NSObject
@property (nonatomic, copy) NSString *commentid;//用户id
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *comment;//评论内容
@property (nonatomic, copy) NSString *headportrait;//头像
@property (nonatomic, copy) NSString *commenttime;//时间
@end
