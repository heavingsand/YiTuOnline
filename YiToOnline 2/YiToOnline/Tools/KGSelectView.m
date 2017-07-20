//
//  KGSelectView.m
//  KGModalExample
//
//  Created by lin on 12-11-9.
//  Copyright (c) 2012年 David Keegan. All rights reserved.
//

#import "KGSelectView.h"
#import "KGModal.h"
#import "Common.h"

@implementation KGSelectView

#define kRowHeight  44.

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.buttonArray = [NSMutableArray array];
        [self addButtonWithTitle:@"取消" TextColor:[UIColor blackColor]];
    }
    return self;
}

-(void)addButtonWithTitle:(NSString *)title
{
    [self addButtonWithTitle:title TextColor:[UIColor blackColor]];
}
-(void)addButtonWithTitle:(NSString *)title TextColor:(UIColor *)color
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kRowHeight)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setTitleColor:color forState:UIControlStateNormal];
    if (self.buttonArray.count == 0) {
        button.backgroundColor = [UIColor whiteColor];
    }else{
        button.backgroundColor = [UIColor whiteColor];
    }
    button.tag = self.buttonArray.count;
    [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonArray insertObject:button atIndex:0];
    [self addSubview:button];
}
-(void)addButtonWithTitle:(NSString *)title TextColor:(UIColor *)color BackgroundColor:(UIColor *)bgColor
{
}

-(void)showSelectViewWithDelegate:(id)delegate
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kRowHeight*self.buttonArray.count+6);
    // layoutButton
    for (int i=0; i<self.buttonArray.count; i++) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        button.top = kRowHeight*i;
        if (i == self.buttonArray.count-1) {
            button.top += 6;
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, button.bottom-.5, button.width, .5)];
        line.backgroundColor = kColorLine;
        [self addSubview:line];
    }
    
    _selectDelegate = delegate;
    
    _kgView = [KGModal sharedInstance];
    _kgView.tapOutsideToDismiss = YES;
    [_kgView setShowCloseButton:NO];
    [_kgView showPickerWithContentView:self andAnimated:YES];
}

- (void)tapButton:(id)sender
{
    [_kgView hide];
    [_selectDelegate selectRowWithIndex:[sender tag]];
}
@end
