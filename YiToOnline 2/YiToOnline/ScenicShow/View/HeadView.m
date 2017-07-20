//
//  HeadView.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/22.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "HeadView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation HeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorBg;
        [self contentView1];
        [self contentView2];
    }
    return self;
}
#pragma mark - Method
- (void)menuBtn1Click:(UIButton *)sender {
    if (self.menuBtn1Block) {
        self.menuBtn1Block();
    }
}

- (void)menuBtn2Click:(UIButton *)sender {
    if (self.menuBtn2Block) {
        self.menuBtn2Block();
    }
}

- (void)menuBtn3Click:(UIButton *)sender {
    if (self.menuBtn3Block) {
        self.menuBtn3Block();
    }
}

- (void)menuBtn4Click:(UIButton *)sender {
    if (self.menuBtn4Block) {
        self.menuBtn4Block();
    }
}

- (void)moreBtnClick:(UIButton *)sender {
    if (self.moreBtnBlock) {
        self.moreBtnBlock();
    }
}

- (UILabel *)addLabel:(CGRect)frame andFont:(NSInteger)font andColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    [self.contentView1 addSubview:label];
    return label;
}

- (UILabel *)addLabel2:(CGRect)frame andFont:(NSInteger)font andColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    [self.contentView2 addSubview:label];
    return label;
}

- (void)setHeadViewContent:(ScenicIntroModel *)model {
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.contentLab.text = model.introduce;
    //自适应宽度
    self.scenicspotname.text = model.scenicspotname;
    CGSize expectSize = [self.scenicspotname sizeThatFits:CGSizeMake(kMainScreenWidth / 3 * 2, 20)];
    self.scenicspotname.frame = CGRectMake(10,10,expectSize.width,expectSize.height);
    self.starlevel.frame =  CGRectMake(self.scenicspotname.right + 2, 12, 120, 20);
    
    self.starlevel.text = [NSString stringWithFormat:@"(%@级景区)", model.starlevel];
    self.ticketprice.text = [NSString stringWithFormat:@"票价: ￥%@/张", model.ticketprice];
    //自适应高度
    self.scenicspotsAddress.text = [NSString stringWithFormat:@"地址: %@", model.scenicspotsAddress];
    CGSize expectSize1 = [self.scenicspotsAddress sizeThatFits:CGSizeMake(kMainScreenWidth / 3 * 2, 40)];
    self.scenicspotsAddress.frame = CGRectMake(10, self.ticketprice.bottom + 5, expectSize1.width,expectSize1.height);
    self.scenicspotsPhone.frame = CGRectMake(10, self.scenicspotsAddress.bottom + 5, 180, 20);
    self.scenicspotsPhone.text = [NSString stringWithFormat:@"电话: %@", model.scenicspotsPhone];
}
#pragma mark - Lazy Load
- (UIImageView *)mainImage {
    if (!_mainImage) {
        _mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 200)];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_mainImage];
    }
    return _mainImage;
}


- (UIView *)contentView1 {
    if (!_contentView1) {
        _contentView1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainImage.bottom, kMainScreenWidth, 160)];
        _contentView1.backgroundColor = kColorWhite;
        [self addSubview:_contentView1];
        //功能条
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _menuView.layer.cornerRadius = 2;
        _menuView.layer.shadowRadius = 2;//阴影半径，默认3
        _menuView.layer.shadowColor = [[UIColor blackColor] CGColor];
        _menuView.layer.shadowOpacity = 1.0;//阴影透明度，默认0
        _menuView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _menuView.backgroundColor = [UIColor blackColor];
        _menuView.alpha = 0.2;
        [_contentView1 addSubview:_menuView];
        
        UIButton *menuBtn1 = self.menuBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _menuView.width / 4, 40)];
        [menuBtn1 setImage:[UIImage imageNamed:@"classMenu1"] forState:UIControlStateNormal];
        [_menuView addSubview:menuBtn1];
        [menuBtn1 addTarget:self action:@selector(menuBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *menuBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(menuBtn1.right, 0, _menuView.width / 4, 40)];
        [menuBtn2 setImage:[UIImage imageNamed:@"classMenu2"] forState:UIControlStateNormal];
        [_menuView addSubview:menuBtn2];
        [menuBtn2 addTarget:self action:@selector(menuBtn2Click:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *menuBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(menuBtn2.right, 0, _menuView.width / 4, 40)];
        [menuBtn3 setImage:[UIImage imageNamed:@"classMenu3"] forState:UIControlStateNormal];
        [_menuView addSubview:menuBtn3];
        [menuBtn3 addTarget:self action:@selector(menuBtn3Click:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *menuBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(menuBtn3.right, 0, _menuView.width / 4, 40)];
        [menuBtn4 setImage:[UIImage imageNamed:@"classMenu4"] forState:UIControlStateNormal];
        [_menuView addSubview:menuBtn4];
        [menuBtn4 addTarget:self action:@selector(menuBtn4Click:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLab = [self addLabel:CGRectMake(10, _menuView.bottom + 10, kMainScreenWidth - 20, 20) andFont:16 andColor:kColorMajor];
        titleLab.text = @"┃景点描述";
        
        _contentLab = [self addLabel:CGRectMake(10, titleLab.bottom + 5, kMainScreenWidth - 20, 60) andFont:14 andColor:kColorMajor];
        _contentLab.numberOfLines = 3;
        
        _moreBtn = [[UIButton alloc] init];
        [_contentView1 addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-5);
        }];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:RGBColor(248, 117, 69) forState:UIControlStateNormal];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 40, 1)];
        lineView.backgroundColor = RGBColor(248, 117, 69);
        [_moreBtn addSubview:lineView];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _contentView1;
}

- (UIView *)contentView2 {
    if (!_contentView2) {
        _contentView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView1.bottom + 3, kMainScreenWidth, 155)];
        _contentView2.backgroundColor = kColorWhite;
        [self addSubview:_contentView2];
        //景区名称
        self.scenicspotname = [self addLabel2:CGRectMake(10, 10, 120, 20) andFont:20 andColor:[UIColor blackColor]];
        //星级
        self.starlevel = [self addLabel2:CGRectMake(self.scenicspotname.right + 2, 10, 120, 20) andFont:16 andColor:kColorMajor];
        self.starlevel.adjustsFontSizeToFitWidth = YES;
        //票价
        self.ticketprice = [self addLabel2:CGRectMake(10, self.scenicspotname.bottom + 5, 180, 20) andFont:16 andColor:kColorMajor];
        //地址
        self.scenicspotsAddress = [self addLabel2:CGRectMake(10, self.ticketprice.bottom + 5, 180, 20) andFont:16 andColor:kColorMajor];
        self.scenicspotsAddress.numberOfLines = 2;
        //电话
        self.scenicspotsPhone = [self addLabel2:CGRectMake(10, self.scenicspotsAddress.bottom + 5, 180, 20) andFont:16 andColor:kColorMajor];
        //订票
        UIButton *bookingBtn = [[UIButton alloc] init];
        [_contentView2 addSubview:bookingBtn];
        [bookingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
        }];
        bookingBtn.layer.cornerRadius = 5;
        bookingBtn.backgroundColor = RGBColor(208, 69, 27);
        [bookingBtn setTitle:@"立即订购" forState:UIControlStateNormal];
        [bookingBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        
        UILabel *commentLab = [[UILabel alloc] init];
        [_contentView2 addSubview:commentLab];
        [commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(180, 20));
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(10);
        }];
        commentLab.text = @"┃评论";
        commentLab.textColor = kColorMajor;
        commentLab.font = [UIFont systemFontOfSize:16];
        
        
    }
    return _contentView2;
}

@end
