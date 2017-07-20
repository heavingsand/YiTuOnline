//
//  MineUserDataTableViewCell.m
//  YiToOnline
//
//  Created by 吴迪 on 16/9/28.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "MineUserDataTableViewCell.h"

@interface MineUserDataTableViewCell ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain)NSArray *pickerArr;


@end

@implementation MineUserDataTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatMineUserData];
    }
    return self;
}


- (void)creatMineUserData{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTHCELL * 0.5, HEIGHTCELL * 0.05)];
    _pickerArr = [[NSArray alloc] initWithObjects:@"自驾游", @"飞机", @"汽车", @"火车", @"轮船", @"骑车", @"步行", @"其他", nil];
    //pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString  *_proNameStr = [_pickerArr objectAtIndex:row];
        NSLog(@"nameStr=%@",_proNameStr);
    } else {
        NSString  *_proTimeStr = [_pickerArr objectAtIndex:row];
        NSLog(@"_proTimeStr=%@",_proTimeStr);
    }
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_pickerArr objectAtIndex:row];
    } else {
        return [_pickerArr objectAtIndex:row];
        
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
