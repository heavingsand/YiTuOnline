//
//  CommentViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/27.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "MyTextView.h"
#import "SocketManager.h"


typedef NS_ENUM(NSUInteger, RequestMode) {
    RequestModeRefresh,
    RequestModeMore,
};

@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *commentArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) MyTextView *textView;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation CommentViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门评论";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    [self tableView];
    [self headView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"CommentTableViewCell"];
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadCommentWithRequestMode:RequestModeRefresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadCommentWithRequestMode:RequestModeMore];
    }];
    
    [self startLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method

- (void)startLoading
{
    [self.tableView.mj_header beginRefreshing];
}
//获取评论
- (void)loadCommentWithRequestMode:(RequestMode)requestMode {
    if (requestMode == RequestModeRefresh) {
        [self.commentArr removeAllObjects];
        self.page = 1;
        self.pageCount = 10;
    }else {
        self.page += 1;
    }
    NSString *path = [NSString stringWithFormat:kUrl_getCommentpage,self.scenicspotid,self.page,self.pageCount];
    [RXApiServiceEngine requestWithType:RequestMethodTypeGet url:path parameters:nil completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            for (NSDictionary *dic in jsonData[@"list"]) {
                CommentModel *model = [CommentModel parse:dic];
                [self.commentArr addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

//发表评论
- (void)publishComment {
    if (self.textView.text.length == 0) {
        [AlertManager alertMessage:@"评论不能为空(～￣▽￣)～"];
        return;
    }
    if ([Common content:self.textView.text] > 60) {
        [AlertManager alertMessage:@"请输入少于60字"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userid"] = [SocketManager sharedSocket].baseModel.ID;
    params[@"scenicspotid"] = [NSString stringWithFormat:@"%ld",(long)self.scenicspotid];
    params[@"comment"] = self.textView.text;
    params[@"commenttime"] = [Common formatWithDate];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_setComment parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [AlertManager toastMessage:@"发表成功" inView:self.view];
                self.textView.text = @"";
                [self startLoading];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}

- (void) hideKeyboard {
//    [self.search resignFirstResponder];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.commentArr != nil) {
        return self.commentArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setCommentWithModel:self.commentArr[indexPath.row]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}
#pragma mark - Lazy Load
- (NSMutableArray *)commentArr {
    if (!_commentArr) {
        _commentArr = [NSMutableArray new];
    }
    return _commentArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        gestureRecognizer.numberOfTapsRequired = 1;
        gestureRecognizer.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:gestureRecognizer];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120)];
        _tableView.tableHeaderView = _headView;
        
        _textView = [[MyTextView alloc] initWithFrame:CGRectMake(10, 10, kMainScreenWidth - 20, 80)];
        _textView.placeholder = @"不想说点什么吗....";
        _textView.font = [UIFont systemFontOfSize:14];
//        _textView.clearsOnInsertion = YES;
        [_headView addSubview:_textView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"游客热门评论";
        titleLab.textColor = RGBColor(248, 117, 69);
        [_headView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 20));
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-5);
        }];
    }
    return _headView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"发表" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _rightBtn.size = CGSizeMake(40, 40);
        [_rightBtn addTarget:self action:@selector(publishComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
