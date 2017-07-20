//
//  PageViewController.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/21.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <WMPageController/WMPageController.h>
#import "ModelScenicShowHomePage.h"

@interface PageViewController : WMPageController
@property (nonatomic, retain) ModelScenicShowHomePage *model;
@property (nonatomic, copy) NSString *scenicspotid;

@end
