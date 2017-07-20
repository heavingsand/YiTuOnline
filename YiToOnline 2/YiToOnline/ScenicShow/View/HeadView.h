//
//  HeadView.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/22.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScenicIntroModel.h"
#import <UIImageView+WebCache.h>

@interface HeadView : UIView
@property (nonatomic, strong) UIImageView *mainImage;
@property (nonatomic, strong) UIView *contentView1;
@property (nonatomic, strong) UIView *contentView2;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) ScenicIntroModel *model;
@property (nonatomic,copy) void (^menuBtn1Block)();
@property (nonatomic,copy) void (^menuBtn2Block)();
@property (nonatomic,copy) void (^menuBtn3Block)();
@property (nonatomic,copy) void (^menuBtn4Block)();
@property (nonatomic,copy) void (^moreBtnBlock)();
@property (nonatomic, strong) UIButton *menuBtn1;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *scenicspotname;//景区名称
@property (nonatomic, strong) UILabel *starlevel;//景区星级
@property (nonatomic, strong) UILabel *ticketprice;//票价
@property (nonatomic, strong) UILabel *scenicspotsAddress;//景区地址
@property (nonatomic, strong) UILabel *scenicspotsPhone;//景区电话

- (void)setHeadViewContent:(ScenicIntroModel *)model;

@end
