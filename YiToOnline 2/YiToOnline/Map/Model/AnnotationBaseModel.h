//
//  AnnotationBaseModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/26.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MusicModel;

@interface AnnotationBaseModel : NSObject
@property (nonatomic, copy) NSString *attractionsid;//景区id
@property (nonatomic, copy) NSString *attractionsname;//景点名称
@property (nonatomic, copy) NSString *introduce;//景点介绍
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSArray<MusicModel *> *music;
//一键求助数据
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL isStaff;
@end


@interface MusicModel : NSObject
@property (nonatomic, copy) NSString *musicurl;
@property (nonatomic, copy) NSString *languagename;
@property (nonatomic, assign) NSInteger musicid;
@property (nonatomic, assign) NSInteger languageid;
@end
