//
//  MyTextView.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, retain) UILabel *placeHolderLabel;

-(void)textChanged:(NSNotification*)notification;

@end
