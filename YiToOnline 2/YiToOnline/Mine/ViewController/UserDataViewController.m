//
//  UserDataViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/14.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "UserDataViewController.h"
#import "EditTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SocketManager.h"
#import "RSKImageCropper.h"
#import "KGPickerView.h"
#import "UserTextViewController.h"
#import "NSString+Extension.h"

@interface UserDataViewController ()<UITableViewDelegate,UITableViewDataSource,RSKImageCropViewControllerDelegate,KGPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton  *rightBtn;
@end

@implementation UserDataViewController
#define kMenuArr1 @[@[@"个人头像",@"昵称名",@"旅游方式"],@[@"性别",@"年龄"]]
#define kMenuArr2 @[@"个人头像",@"员工姓名"]
#define kmenuArr3 @[@[[SocketManager sharedSocket].baseModel.headImg,[SocketManager sharedSocket].baseModel.name,[SocketManager sharedSocket].baseModel.travelmodes],@[[SocketManager sharedSocket].baseModel.sex,[SocketManager sharedSocket].baseModel.age]]

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    self.title = @"个人资料";
    UIBarButtonItem *item = [Common noTitlebackBtnWithTarget:self selector:@selector(returnLaststageVC)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    [self tableView];
    [self.tableView registerClass:[EditTableViewCell class] forCellReuseIdentifier:@"EditTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
/*返回上一级控制器*/
- (void)returnLaststageVC {
    [self.navigationController popViewControllerAnimated:YES];
}
/*完成修改*/
- (void)saveUserData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url;
    if (self.isstaff) {
        
        url = kUrl_UploadStaff;
        EditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        params[@"headportrait"] = [NSString imageBase64:cell.userImage.image];
        params[@"numberid"] = [SocketManager sharedSocket].baseModel.ID;
        EditTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        params[@"staffname"] = cell1.rightLab.text;
        
    }else {
        url = kUrl_UploadPortraitUpdateUser;
        EditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        params[@"headportrait"] = [NSString imageBase64:cell.userImage.image];
        params[@"numberid"] = [SocketManager sharedSocket].baseModel.ID;
        EditTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        params[@"username"] = cell1.rightLab.text;
        EditTableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        params[@"sex"] = cell2.rightLab.text;
        EditTableViewCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        params[@"age"] = cell3.rightLab.text;
        EditTableViewCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        params[@"travelmodes"] = cell4.rightLab.text;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [SocketManager sharedSocket].baseModel.headImg = [NSString stringWithFormat:@"%@",jsonData[@"result"][@"headportrait"]];
                [kNotificationCenter postNotificationName:kReloadHead object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [AlertManager toastMessage:error.domain inView:self.view];
        }
    }];
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isstaff) {
        return 1;
    } else {
        return kMenuArr1.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isstaff) {
        return kMenuArr2.count;
    }
    else {
        return [[kMenuArr1 objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MineTableViewCell";
    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[EditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self.isstaff) {
        cell.label.text = kMenuArr2[indexPath.row];
        if (indexPath.row == 0) {
            cell.lineView.hidden = NO;
            [cell.userImage sd_setImageWithURL:[NSURL URLWithString:self.rightArr[0][indexPath.row]]];
            cell.userImage.hidden = NO;
        }
        if (indexPath.row == 1) {
            cell.rightLab.text = self.rightArr[0][indexPath.row];
            cell.rightLab.hidden = NO;
        }
    }else {
        cell.label.text = kMenuArr1[indexPath.section][indexPath.row];
        if ((indexPath.section == 0 && indexPath.row != 2) || (indexPath.section == 1 && indexPath.row == 0)) {
            cell.lineView.hidden = NO;
        }
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.userImage.hidden = NO;
            [cell.userImage sd_setImageWithURL:[NSURL URLWithString:self.rightArr[indexPath.section][indexPath.row]]];
        }else {
            cell.rightLab.text = self.rightArr[indexPath.section][indexPath.row];
            cell.rightLab.hidden = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //修改头像
    if (indexPath.section == 0 && indexPath.row == 0) {
        //UIImage *image = [[YYImageCache sharedCache] getImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:[SocketManager sharedSocket].baseModel.headImg]]];
        EditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:cell.userImage.image cropMode:RSKImageCropModeCircle];
        imageCropVC.delegate = self;
        [self.navigationController pushViewController:imageCropVC animated:YES];
    }
    //修改昵称
    if (indexPath.section == 0 && indexPath.row == 1) {
        UserTextViewController *jumpVc = [[UserTextViewController alloc] init];
        EditTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        jumpVc.userString = cell.rightLab.text;
        __weak typeof(UserTextViewController) *weakVc = jumpVc;
        [jumpVc setTextFieldBlock:^{
            cell.rightLab.text = weakVc.textField.text;
        }];
        [self.navigationController pushViewController:jumpVc animated:YES];
    }
    //旅游方式
    if (indexPath.section == 0 && indexPath.row == 2) {
        KGPickerView *pickerView = [[KGPickerView alloc] initWithStyle:5 Title:@"请选择旅游方式" delegate:self];
        [pickerView showInView:self.view];
    }
    //性别
    if (indexPath.section == 1 && indexPath.row == 0) {
        KGPickerView *pickerView = [[KGPickerView alloc] initWithStyle:6 Title:@"请选择性别" delegate:self];
        [pickerView showInView:self.view];
    }
    //年龄
    if (indexPath.section == 1 && indexPath.row == 1) {
        UserTextViewController *jumpVc = [[UserTextViewController alloc] init];
        EditTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        jumpVc.userString = cell.rightLab.text;
        __weak typeof(UserTextViewController) *weakVc = jumpVc;
        [jumpVc setTextFieldBlock:^{
            cell.rightLab.text = weakVc.textField.text;
        }];
        [self.navigationController pushViewController:jumpVc animated:YES];
    }
}
#pragma mark - RSImage Delegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect{
    EditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.userImage setImage:croppedImage];
 //   [kNotificationCenter postNotificationName:kNotifReloadUserInfo object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - KGPicker delegate
//刷新旅游信息
- (void)confirmTravelmodes:(NSString *)string {
    EditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.rightLab.text = string;
}
//刷新性别
- (void)confirmSex:(NSString *)string {
    EditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.rightLab.text = string;
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

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _rightBtn.size = CGSizeMake(40, 40);
        [_rightBtn addTarget:self action:@selector(saveUserData) forControlEvents:UIControlEventTouchUpInside];
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
