//
//  KGPickerView.m
//  LotteryTicket
//
//  Created by lin on 12-11-14.
//
//

#import "KGPickerView.h"

#define kDuration 0.3
#define kWidth   [[UIScreen mainScreen] bounds].size.width

@implementation KGPickerView

#define kTravleArr @[@"自驾游", @"飞机", @"汽车", @"火车", @"轮船", @"骑车", @"步行", @"其他"]
#define kSexArr @[@"男",@"女"]

- (id)initWithStyle:(NSInteger)style Title:(NSString *)title delegate:(id <KGPickerViewDelegate>)delegate 
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, 260)];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.style = style;
        self.backgroundColor = [UIColor whiteColor];
        // 头部
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
		toolBar.barStyle = UIBarStyleBlack;
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStylePlain target: self action: @selector(done)];
		UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
		UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
		NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, rightButton, nil];
		[toolBar setItems: array];
		[self addSubview:toolBar];
        
        // 标题 其它
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
        
        //picker 
        UIPickerView *pickerView = self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kWidth, 216)];
        pickerView.showsSelectionIndicator = YES;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
        
        if (style == KGPickerViewStyleProvinece) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Provineces" ofType:@"plist"];
            self.provinecesArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
            NSDictionary *firstDic = [self.provinecesArray objectAtIndex:0];
            self.secondList = [firstDic objectForKey:@"cities"];
        }
        if (style == KGPickerViewStyleTravelmodes) {
            self.travelmodesArr = kTravleArr;
            self.userString = [self.travelmodesArr objectAtIndex:0];
        }
        if (style == KGPickerViewStyleSex) {
            self.userSexArr = kSexArr;
            self.userString = [self.userSexArr objectAtIndex:0];
        }
    }
    return self;
}

- (id)initDatePickerWithTitle:(NSString *)title delegate:(id <KGPickerViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, 260)];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        self.style = 10;
        // 头部
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        toolBar.barStyle = UIBarStyleBlack;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStylePlain target: self action: @selector(done)];
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, rightButton, nil];
        [toolBar setItems: array];
        [self addSubview:toolBar];
        
        // 标题 其它
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
        
        //picker
        UIDatePicker *pickerView = self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, kWidth, 216)];
        pickerView.datePickerMode = UIDatePickerModeDate;
        [self addSubview:pickerView];
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    _kgView = [KGModal sharedInstance];
    _kgView.tapOutsideToDismiss = YES;
    [_kgView setShowCloseButton:NO];
    [_kgView showPickerWithContentView:self andAnimated:YES];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //if (_style == KGPickerViewStyleNormal || _style == KGPickerViewStyleIntegral) {
      //  return 1;
   // }else{
     //   return 2;
    //}
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_style == KGPickerViewStyleProvinece) {
        switch (component) {
            case 0:
            {
                return self.provinecesArray.count;
            }
                break;
            case 1:
            {
                return [self.secondList count];
            }
                break;
            default:
                return 0;
                break;
        }
    }
    if (_style == KGPickerViewStyleTravelmodes) {
        return self.travelmodesArr.count;
    }
    if (_style == KGPickerViewStyleSex) {
        return self.userSexArr.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_style == KGPickerViewStyleProvinece) {
        switch (component) {
            case 0:
            {
                NSDictionary *firstDic = [self.provinecesArray objectAtIndex:row];
                return [firstDic objectForKey:@"ProvinceName"];
            }
                break;
            case 1:
            {
                return [[self.secondList objectAtIndex:row] objectForKey:@"CityName"];
            }
                break;
            default:
                return nil;
                break;
        }
    }
    if (_style == KGPickerViewStyleTravelmodes) {
        return [self.travelmodesArr objectAtIndex:row];
    }
    if (_style == KGPickerViewStyleSex) {
        return [self.userSexArr objectAtIndex:row];
    }
    return 0;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_style == KGPickerViewStyleTravelmodes) {
        self.userString =  [self.travelmodesArr objectAtIndex:row];
    }
    if (_style == KGPickerViewStyleSex) {
        self.userString =  [self.userSexArr objectAtIndex:row];
    }
}

#pragma mark - Button lifecycle

- (void)cancel{
    [self hideView];
}

- (void)done{
    [self hideView];
    // 点击确定，执行代理方法
    
    
    ////////
    if (_style == KGPickerViewStyleTravelmodes) {
        [_delegate confirmTravelmodes:self.userString];
    }
    if (_style == KGPickerViewStyleSex) {
        [_delegate confirmSex:self.userString];
    }
}
-(void)hideView
{
    [_kgView hide];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
