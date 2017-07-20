//
//  ViewController.m
//  Day07_Wlecome
//
//  Created by tarena on 16/1/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "AppDelegate.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic) NSArray *imageNames;
@property (nonatomic) UIScrollView *scroVIew;
//页数提示控件
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) UIButton *button;
@end

@implementation ViewController
#pragma mark - UIScrollViewDelegate 代理方法
//当发生滚动操作时触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //lronund() 把浮点型 -> 整型,四舍五入
    long int page = lroundf(scrollView.contentOffset.x/scrollView.frame.size.width);
    //currentPage当前页数
    self.pageControl.currentPage = page;
    if (page == self.imageNames.count - 1) {
        self.button.hidden = NO;
    } else {
        self.button.hidden = YES;
    }
}


#pragma mark - 生命周期 Life cicrcle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self scroVIew];
    [self pageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//隐藏状态栏,重写
- (BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma  mark - 方法 Method
//保存版本号, 并且获取AppDelegate实例来跳转页面
- (void)enterMainPage {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [Common setAsynchronous:version WithKey:kRunVersion];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate changeRootVC];
}
#pragma mark - 懒加载 Lazy Load
- (UIScrollView *)scroVIew {
	if(_scroVIew == nil) {
		_scroVIew = [[UIScrollView alloc] init];
        [self.view addSubview:_scroVIew];
        [_scroVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //翻页滚动模式
        _scroVIew.pagingEnabled = YES;
        //隐藏横向滚动提示
        _scroVIew.showsHorizontalScrollIndicator = NO;
        //设置代理来实时接收当前滚动状态
        _scroVIew.delegate = self;
        //弹簧禁用
        _scroVIew.bounces = NO;
        UIView *lastView = nil;
        NSInteger count = self.imageNames.count;
        for (int i = 0; i < count ; i++) {
            NSString *imageName = self.imageNames[i];
            UIImage *image = [UIImage imageNamed:imageName];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [_scroVIew addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(_scroVIew);
                make.top.bottom.mas_equalTo(0);
                if (i == 0) {
                    make.left.mas_equalTo(0);
                }else{
                    make.left.mas_equalTo(lastView.mas_right).mas_equalTo(0);
                    if (i == count - 1) {
                        make.right.mas_equalTo(0);
                    }
                }
            }];
            
            lastView = imageView;
            
            _button =  [[UIButton alloc] initWithFrame:CGRectMake(120, kScreenHeight - 120, kScreenWidth - 240, 40)];
            [_button setTitle:@"立即体验" forState:UIControlStateNormal];
            _button.layer.cornerRadius = 18;
            [_button setTitleColor:kColorWhite forState:UIControlStateNormal];
            [_button setBorderColor:kColorWhite width:1 cornerRadius:18];
            [self.view addSubview:_button];
            [_button addTarget:self action:@selector(enterMainPage) forControlEvents:UIControlEventTouchUpInside];
            _button.hidden = YES;
        }
	}
	return _scroVIew;
}

- (NSArray *)imageNames {
	if(_imageNames == nil) {
		_imageNames = @[@"welcome1",
                        @"welcome2",
                        @"welcome3",
                        @"welcome4"];
        
	}
	return _imageNames;
}

- (UIPageControl *)pageControl {
	if(_pageControl == nil) {
		_pageControl = [[UIPageControl alloc] init];
        //页数 -- 点的个数
        _pageControl.numberOfPages = self.imageNames.count;
        [self.view addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
        }];
        _pageControl.userInteractionEnabled = NO;
	}
	return _pageControl;
}

@end
