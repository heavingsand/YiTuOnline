//
//  MapViewController.h
//  YiTuOnline
//
//  Created by 吴迪 on 16/8/31.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController
//关键字检索
- (void)searchPoiByKeyword:(NSString *)keyword;
//周边检索
- (void)searchPoiByCenterCoordinate:(NSString *)keyword;
@end
