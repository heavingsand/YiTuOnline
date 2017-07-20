//
//  MineViewController.m
//  YiTuOnline
//
//  Created by 吴迪 on 16/8/31.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "MineViewController.h"
#import "WDNetworkHandler.h"
#import <UIButton+WebCache.h>
#import "SocketManager.h"
#import "MineTableViewCell.h"
#import "EditViewController.h"
#import <UIImageView+WebCache.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"


@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, retain) UIImageView *headImage;

@property (nonatomic, retain) UILabel *labelUserName;

@property (nonatomic, retain) UILabel *labelAccount;

@property (nonatomic, retain) UIButton *imageViewhradportrait;

@property (nonatomic, retain) NSString *userPhoneNumber;

@end

@implementation MineViewController

#define kMenuArray @[@[@"相册",@"足迹",@"收藏",@"喜欢"],@[@"设置"],@[@"验票"]]
#define kImageArray @[@[@"MineIcon1",@"MineIcon2",@"MineIcon3",@"MineIcon4"],@[@"MineIcon5"],@[@"MineIcon6"]]

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setUpNavBar:self.navigationController.navigationBar];
    self.view.backgroundColor = kColorBg;
    // 隐藏NavigationBar：
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self tableView];
    [self headView];
    [self topView];
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    
    [kNotificationCenter addObserver:self selector:@selector(reloadUserHeadImage) name:kReloadHead object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Method
//刷新头像
- (void)reloadUserHeadImage {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[SocketManager sharedSocket].baseModel.headImg]];
}
//头像放大
- (void)settingBackgroudImage {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    
    if (self.headImage.image) {
        photo.image = self.headImage.image;
    }else{
        photo.url = [NSURL URLWithString:[SocketManager sharedSocket].baseModel.headImg]; // 图片路径
    }
    photo.srcImageView = self.headImage; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kMenuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [[kMenuArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setImageView:kImageArray[indexPath.section][indexPath.row] andText:kMenuArray[indexPath.section][indexPath.row]];
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            cell.lineView.hidden = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //访问相册
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImagePickerController *imagePC = [UIImagePickerController new];
        imagePC.delegate = self;
        //编辑状态
        imagePC.allowsEditing = YES;
        imagePC.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:imagePC animated:YES completion:nil];
    }
    //足迹
    if (indexPath.section == 0 && indexPath.row == 1) {
        
    }
    //收藏
    if (indexPath.section == 0 && indexPath.row == 2) {
        
    }
    //喜欢
    if (indexPath.section == 0 && indexPath.row == 3) {
        
    }
    //设置
    if (indexPath.section == 1 && indexPath.row == 0) {
        EditViewController *jumpVC = [[EditViewController alloc] init];
        jumpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    //验票
    if (indexPath.section == 2 && indexPath.row == 0) {
        
    }
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 112) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT * 0.2)];
        _headView.backgroundColor = RGBColor(248, 117, 69);
        _headView.userInteractionEnabled = YES;
        
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, (kMainScreenHeight * 0.2 - 100 ) / 2, 80, 80)];
        _headImage.backgroundColor = [UIColor clearColor];
        _headImage.layer.cornerRadius = 40;
        _headImage.clipsToBounds = YES;
        [_headImage sd_setImageWithURL:[NSURL URLWithString:[SocketManager sharedSocket].baseModel.headImg]];
        [_headView addSubview:_headImage];
        //为图片添加手势控制
        [_headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBackgroudImage)]];
        _headImage.userInteractionEnabled = YES;
        
        
        _labelUserName = [[UILabel alloc] initWithFrame:CGRectMake(_headImage.right + 10, (kMainScreenHeight * 0.2 - 100 ) / 2, WIDTH * 0.5, 40)];
//        _labelUserName.text = @"昵称 : 嘻嘻哈哈";
        _labelUserName.text = [NSString stringWithFormat:@"昵称 : %@",[SocketManager sharedSocket].baseModel.name];
        _labelUserName.font = [UIFont systemFontOfSize:18];
        _labelUserName.textColor = [UIColor whiteColor];
        [_headView addSubview:_labelUserName];
        
        _labelAccount = [[UILabel alloc] initWithFrame:CGRectMake(_headImage.right + 10, _labelUserName.bottom, WIDTH * 0.75, 40)];
        _labelAccount.text = @"个人介绍 : 什么都没有留下 ... ✎_ ";
        _labelAccount.font = [UIFont systemFontOfSize:15];
        _labelAccount.textColor = [UIColor whiteColor];
        [_headView addSubview:_labelAccount];
        
        _tableView.tableHeaderView = _headView;
    }
    return _headView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView  = [[UIView alloc] initWithFrame:CGRectMake(0, -200, kMainScreenWidth, 200)];
        _topView.backgroundColor = RGBColor(248, 117, 69);
        [_tableView addSubview:_topView];
    }
    return _topView;
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
