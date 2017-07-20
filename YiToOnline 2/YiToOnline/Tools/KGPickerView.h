//
//  KGPickerView.h
//  LotteryTicket
//
//  Created by lin on 12-11-14.
//
//

typedef enum{
    KGPickerViewStyleNormal = 0,
    KGPickerViewStyleBet = 1,
    KGPickerViewStyleDouble = 2,
    KGPickerViewStyleProvinece = 3,
    KGPickerViewStyleIntegral = 4,
    /* 新增 */
    KGPickerViewStyleTravelmodes = 5,
    KGPickerViewStyleSex = 6,
    /*******/
    KGPickerViewStyleDate   = 10,
//    UITableViewScrollPositionBottom
} KGPickerViewStyle;

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KGModal.h"

@protocol KGPickerViewDelegate;

@interface KGPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign) KGPickerViewStyle style;
@property (strong) KGModal *kgView;
@property (strong) id<KGPickerViewDelegate> delegate;
@property (strong) UIPickerView *pickerView;
@property (strong) NSArray *firstList,*secondList,*provinecesArray, *travelmodesArr, *userSexArr;
@property (assign) NSInteger firstIndex,secondIndex;
@property (strong) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *userString;

- (id)initWithStyle:(NSInteger)style Title:(NSString *)title delegate:(id<KGPickerViewDelegate>)delegate ;
- (id)initDatePickerWithTitle:(NSString *)title delegate:(id <KGPickerViewDelegate>)delegate;
- (void)showInView:(UIView *) view;
-(void)hideView;

@end


@protocol KGPickerViewDelegate <NSObject>

@optional
-(void)confirmIndex:(NSInteger)firstIndex;
-(void)confirmDate:(NSDate *)date;
-(void)confirmFirst:(NSInteger)firstIndex Second:(NSInteger)secondIndex;
-(void)confirmProvinceName:(NSString *)provinceName cityName:(NSString *)cityName First:(NSInteger)firstIndex Second:(NSInteger)secondIndex;
- (void)confirmTravelmodes:(NSString *)string;
- (void)confirmSex:(NSString *)string;
@end
