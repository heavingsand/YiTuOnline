//
//  ModelCommentPage.h
//  YiToOnline
//
//  Created by 吴迪 on 16/9/6.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCommentPage : NSObject

@property (nonatomic, copy) NSString *username;

@property (nonatomic, assign) NSInteger commentid;

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *headportrait;

@property (nonatomic, copy) NSString *commenttime;

//- (instancetype)initWithDic:(NSDictionary *)dic;
//+ (instancetype)ModelCommentPageWithDic:(NSDictionary *)dic;

@end
