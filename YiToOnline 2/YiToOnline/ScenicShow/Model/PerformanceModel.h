//
//  PerformanceModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface PerformanceModel : NSObject
@property (nonatomic, assign) NSInteger showId;
@property (nonatomic, copy) NSString *showName;
@property (nonatomic, assign) NSInteger scenicspotid;
@property (nonatomic, copy) NSString *showDateTime;
@property (nonatomic, copy) NSString *showPlace;
@property (nonatomic, copy) NSString *showPicture;
@end
