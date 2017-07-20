//
//  OverlayModel.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/28.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DaolanlatlngModel;

@interface OverlayModel : NSObject
@property (nonatomic, copy) NSString *scenicspotname;
@property (nonatomic, copy) NSString *daolanpngurl;
@property (nonatomic, assign) NSInteger scenicspotsid;
@property (nonatomic, strong) DaolanlatlngModel *daolanlatlng;
@end

@interface DaolanlatlngModel : NSObject
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *late;
@property (nonatomic, copy) NSString *lnge;

@end
