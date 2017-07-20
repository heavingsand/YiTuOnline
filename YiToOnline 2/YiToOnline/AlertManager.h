//
//  AlertManager.h
//  HoneyLemon
//
//  Created by  on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma  -mark alert tag

#define ALERT_TAG_NONE              0
#define ALERT_TAG_PAIR_CONFIRM      1


@interface AlertManager : NSObject

+ (void)alertWithTitle:(NSString *)title tag:(int)tag message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)alertNetworkError;
+ (void)alertMessage:(NSString *)message;

+ (AlertManager *)shared;

-(void)alertLoadingViewWithTitle:(NSString *)title tag:(int)tag Delegate:(id)delegate;
-(void)hideAlertWithAnimate:(BOOL)animated;


-(void)alertLoginWithDelegate:(id)delegate TextField:(UITextField *)field;
-(void)callPhoneNumber:(NSString *)num;

+(void)toastMessage:(NSString *)message inView:(UIView *)view;
+ (void)toastSuccessMessage:(NSString *)message inView:(UIView *)view;

@end
