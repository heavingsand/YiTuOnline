//
//  ModelScenicShowHomePage.h
//  YiToOnline
//
//  Created by 吴迪 on 16/9/2.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelScenicShowHomePage : NSObject

@property (nonatomic, copy) NSString *synopsis;

@property (nonatomic, copy) NSString *scenicspotname;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, copy) NSString *gailantu;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *coordinatesjin;

@property (nonatomic, copy) NSString *starlevel;

@property (nonatomic, assign) NSInteger scenicspotid;

@property (nonatomic, assign) NSInteger cityid;

@property (nonatomic, copy) NSString *coordinateswei;

@property (nonatomic, copy) NSString *voice;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, assign) NSInteger ticketprice;

@property(nonatomic, copy) NSString *city;

//@property(nonatomic, strong) ProvinceCityModel *result;

//- (instancetype) initWithDic:(NSDictionary *)dic;
//+ (instancetype) modelScenicShowHomePageWithDic:(NSDictionary *)dic;
@end

//@interface ProvinceCityModel : NSObject
//@property(nonatomic, copy) NSString *city;
//@property(nonatomic, copy) NSString *cityid;
//@end
