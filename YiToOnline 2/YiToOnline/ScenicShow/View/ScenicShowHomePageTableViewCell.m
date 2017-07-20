//
//  ScenicShowHomePageTableViewCell.m
//  YiToOnline
//
//  Created by 吴迪 on 16/9/2.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ScenicShowHomePageTableViewCell.h"

@implementation ScenicShowHomePageTableViewCell


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatTableViewCell];
    }
    return self;
}

- (void)creatTableViewCell{
    self.imageViewBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTHCELL, HEIGHTCELL * 0.29)];
    [self addSubview:self.imageViewBackGround];
    
    self.labelAttractionsName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageViewBackGround.frame.size.height * 0.1, WIDTHCELL * 0.7, self.imageViewBackGround.frame.size.height * 0.1)];
    //self.labelAttractionsName.backgroundColor = [UIColor redColor];
    self.labelAttractionsName.textColor = [UIColor whiteColor];
    self.labelAttractionsName.font = [UIFont systemFontOfSize:21];
    //self.labelAttractionsName.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:21];
    self.labelAttractionsName.font = [UIFont boldSystemFontOfSize:23.0];
    self.labelAttractionsName.shadowColor = HEXCOLOR(0x999999); //增加阴影
    self.labelAttractionsName.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3)
    // self.labelAttractionsName.shadowColor = nil; //取消阴影
    [self addSubview:self.labelAttractionsName];
    
    
    self.labelAttractionsLevel  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageViewBackGround.frame.size.height * 0.75, WIDTHCELL * 0.3, self.imageViewBackGround.frame.size.height * 0.3)];
    self.labelAttractionsLevel.textColor = [UIColor whiteColor];
    self.labelAttractionsLevel.shadowColor = HEXCOLOR(0x999999);
    self.labelAttractionsLevel.shadowOffset = CGSizeMake(4, 4);
    [self addSubview:self.labelAttractionsLevel];
    
    
    self.labelTicketMoney = [[UILabel alloc] initWithFrame:CGRectMake(WIDTHCELL * 0.77, self.imageViewBackGround.frame.size.height * 0.75, WIDTHCELL * 0.3, self.imageViewBackGround.frame.size.height * 0.3)];
    self.labelTicketMoney.textColor = [UIColor whiteColor];
    self.labelTicketMoney.shadowColor = HEXCOLOR(0x999999);
    self.labelTicketMoney.shadowOffset = CGSizeMake(4, 4);
    [self addSubview:self.labelTicketMoney];
    
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
