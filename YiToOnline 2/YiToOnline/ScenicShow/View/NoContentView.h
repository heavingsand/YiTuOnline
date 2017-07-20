//
//  NoContentView.h
//  Luohe
//
//  Created by sks on 16/6/14.
//  Copyright © 2016年 linyingbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoContentView : UIView
@property (nonatomic) UILabel *label;
@property (nonatomic) NSString *style;
- (instancetype)initWithStyle:(NSString *)style;
@end
