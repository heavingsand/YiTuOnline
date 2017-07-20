//
//  ScenicSpotIntroViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/22.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "ScenicSpotIntroViewController.h"
#import "ScenicIntroModel.h"
#import "NotiTableViewCell.h"
#import "HeadView.h"
#import <UIImageView+WebCache.h>
#import "NotiDetailViewController.h"
#import "ComplainViewController.h"
#import "CommentTableViewCell.h"
//#import "ViewController.h"
#import "CommentViewController.h"

@interface ScenicSpotIntroViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *commentArr;
@property (nonatomic, strong) NSMutableDictionary *scenicSpotDic;
@property (nonatomic, strong) ScenicIntroModel *scenicIntroModel;
@property (nonatomic, strong) HeadView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ScenicSpotIntroViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBg;
//    [self.tableView registerClass:[NotiTableViewCell class] forCellReuseIdentifier:@"NotiTableViewCell"];
    
    [self tableView];
    [self headView];
    [self footView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"CommentTableViewCell"];
    
    [self loadScenicSpotIntro];
    [self loadComment];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight * 0.2)];
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
//加载景区信息
- (void)loadScenicSpotIntro {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"scenicspotid"] = [NSString stringWithFormat:@"%ld", (long)self.scenicspotsid];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_idgetscenicspots parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
//                self.scenicSpotDic = jsonData[@"result"];
                self.scenicIntroModel = [ScenicIntroModel parse:jsonData[@"result"]];
//                self.headView.model = self.scenicIntroModel;
//                [self.headView.mainImage sd_setImageWithURL:[NSURL URLWithString:self.scenicIntroModel.img]];
//                self.headView.contentLab.text = self.scenicIntroModel.introduce;
                [self.headView setHeadViewContent:self.scenicIntroModel];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
//获取评论
- (void)loadComment {
    NSString *path = [NSString stringWithFormat:kUrl_getCommentpage,self.scenicspotsid,1,5];
    [RXApiServiceEngine requestWithType:RequestMethodTypeGet url:path parameters:nil completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            for (NSDictionary *dic in jsonData[@"list"]) {
                CommentModel *model = [CommentModel parse:dic];
                [self.commentArr addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}
//更过评论
- (void)moreCommentBtnClick {
    CommentViewController *jumpVc = [[CommentViewController alloc] init];
    jumpVc.scenicspotid = self.scenicspotsid;
    [self.navigationController pushViewController:jumpVc animated:YES];
}

//功能栏
- (void)menu1Click {
    NotiDetailViewController *jumpVc = [[NotiDetailViewController alloc] init];
    jumpVc.urlString = self.scenicIntroModel.daolanpngurl;
    [self.navigationController pushViewController:jumpVc animated:YES];
}

- (void)menu2Click {
    NotiDetailViewController *jumpVc = [[NotiDetailViewController alloc] init];
    jumpVc.urlString = self.scenicIntroModel.vr;
    [self.navigationController pushViewController:jumpVc animated:YES];
}

- (void)menu3Click {
//    ViewController *jumpVc = [[ViewController alloc] init];
//    [self presentViewController:jumpVc animated:YES completion:nil];
}

- (void)menu4Click {
    ComplainViewController *jumpVc = [ComplainViewController new];
    [self.navigationController pushViewController:jumpVc animated:YES];
}

- (void)moreBtnClick {
    NotiDetailViewController *jumpVc = [[NotiDetailViewController alloc] init];
    jumpVc.urlString = self.scenicIntroModel.link;
    [self.navigationController pushViewController:jumpVc animated:YES];
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
#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 104) style:UITableViewStylePlain];
        _tableView.backgroundColor = kColorBg;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (HeadView *)headView {
    if (!_headView) {
        _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 521)];
        __weak typeof(self) weakSelf = self;
        [_headView setMenuBtn1Block:^{
            [weakSelf menu1Click];
        }];
        [_headView setMenuBtn2Block:^{
            [weakSelf menu2Click];
        }];
        [_headView setMenuBtn3Block:^{
            [weakSelf menu3Click];
        }];
        [_headView setMenuBtn4Block:^{
            [weakSelf menu4Click];
        }];
        [_headView setMoreBtnBlock:^{
            [weakSelf moreBtnClick];
        }];
        _tableView.tableHeaderView = _headView;
    }
    return _headView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
        _footView.backgroundColor = kColorWhite;
        
        UIButton *moreCommentBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 90, 0, 80, 50)];
        [moreCommentBtn setTitle:@"更多评论" forState:UIControlStateNormal];
        [moreCommentBtn setTitleColor:kColorMajor forState:UIControlStateNormal];
        moreCommentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_footView addSubview:moreCommentBtn];
        [moreCommentBtn addTarget:self action:@selector(moreCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        _tableView.tableFooterView = _footView;
    }
    return _footView;
}

- (NSMutableArray *)commentArr {
    if (!_commentArr) {
        _commentArr = [NSMutableArray new];
    }
    return _commentArr;
}

- (NSMutableDictionary *)scenicSpotDic {
    if (!_scenicSpotDic) {
        _scenicSpotDic = [NSMutableDictionary new];
    }
    return _scenicSpotDic;
}

- (ScenicIntroModel *)scenicIntroModel {
    if (!_scenicIntroModel) {
        _scenicIntroModel = [ScenicIntroModel new];
    }
    return _scenicIntroModel;
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
