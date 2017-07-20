//
//  KGSelectView.h
//  KGModalExample
//
//  Created by lin on 12-11-9.
//  Copyright (c) 2012年 David Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGModal.h"

@protocol KGSelectViewDelegate;
@interface KGSelectView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (strong) NSMutableArray *buttonArray;
@property (strong) id<KGSelectViewDelegate> selectDelegate;
@property (strong) KGModal *kgView;

-(void)showSelectViewWithDelegate:(id)delegate;
-(void)addButtonWithTitle:(NSString *)title;
-(void)addButtonWithTitle:(NSString *)title TextColor:(UIColor *)color;

@end

@protocol KGSelectViewDelegate <NSObject>

-(void)selectRowWithIndex:(NSInteger)index;

@end