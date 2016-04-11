//
//  UserInfo.m
//  SchoolPaper
//
//  Created by 周文松 on 15/9/24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "UserInfo.h"
#import "DataConfigManager.h"
#import "MineCell.h"
#import "EditViewController.h"
#import "SignatureViewController.h"
#import "FeedBackViewController.h"
#import "AboutViewController.h"
#import "BasePhotoPickerManager.h"
#import "APService.h"

@interface UserInfo ()
{
    NSArray *_sectionTows;
    UIImageView *_imageView;
    
}
@end

@implementation UserInfo

- (UIView *)setFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), ScaleH(80))];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kDefaultInset.left, (CGRectGetHeight(view.frame) - ScaleH(40)) / 2, CGRectGetWidth(_table.frame) - kDefaultInset.left * 2, ScaleH(50));
    button.backgroundColor = CustomBlue;
    button.titleLabel.font = Font(20);
    [button setTitle:@"退 出" forState:UIControlStateNormal];
    [button getCornerRadius:5 borderColor:[UIColor clearColor] borderWidth:1 masksToBounds:YES];
    [button addTarget:self action:@selector(eventWithExit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = DeviceW - DeviceW * (1 - viewSlideHorizonRatio) * viewHeightNarrowRatio * viewHeightNarrowRatio - kDefaultInset.left * 2;
    self.tableWithFrame = CGRectMake(kDefaultInset.left, (DeviceH - ScaleH(60) * 4 - ScaleH(80) * 2 + 64) / 2 - 64,
                                     width, CGRectGetHeight(_table.frame));
    self.table.tableFooterView = [self setFooterView];
    
    // Do any additional setup after loading the view.
}

- (void)setUpDatas
{
    _sectionTows = [DataConfigManager getSetConfigList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [Infomation readInfo]?2:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(25);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return _sectionTows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return ScaleH(80);
        }
    }
    return ScaleH(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else
    {
        NSArray *views = cell.contentView.subviews;
        for (UIView *v in views)
        {
            [v removeFromSuperview];
        }
    }
    
    [cell dic:indexPath.section?_sectionTows[indexPath.row]:[Infomation readInfo] indexPath:indexPath rowNum:indexPath.section?_sectionTows.count:1];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:10];
    if (imageView)
    {
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom)]];
        imageView.userInteractionEnabled = YES;
        _imageView = imageView;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            [_main pushViewController:[EditViewController new]];
            [_menu touchesLeftItem];
        }
        else
        {
            [_main pushViewController:[SignatureViewController new]];
            [_menu touchesLeftItem];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            [MBProgressHUD showMessag:@"清除缓存中..." toView:self.view];
            [self performSelector:@selector(clearDatas) withObject:nil afterDelay:1];
        }
        else if (indexPath.row == 1) {
            [_main pushViewController:[FeedBackViewController new]];
            [_menu touchesLeftItem];
        }
        else if (indexPath.row == 2)
        {
            [_main pushViewController:[AboutViewController new]];
            [_menu touchesLeftItem];
        }
    }
}

- (void)handlePanFrom
{
    [[BasePhotoPickerManager shared] showActionSheetInView:self.view fromController:self completion:^(UIImage *img)
     {
         [MBProgressHUD showMessag:@"头像上传中..." toView:self.view];
         
         NSString *account = [Infomation readInfo][@"id"];
         NSString *secret_key = [Infomation readInfo][@"secret_key"];
         NSString *code = @"1";
         
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
         params[@"code"] = code;
         params[@"secret_key"] = secret_key;
         params[@"account"] = account;
         
         _imageView.image = img;
         [ZWSRequest postRequestWithURL:[serverUrl stringByAppendingString:submittopimg] postParems:params images:@[img] success:^(id datas)
          {
              NSString *top_image = datas[@"data"];
              NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Infomation readInfo]];
              dic[@"top_image"] = top_image;
              [Infomation writeInfo:dic];
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              NSNotificationPost(@"changeImg", nil, nil);
          }
                                failure:^(NSString *msg)
          {
              [self.view makeToast:msg];
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }
          ];
     }
                                               cancelBlock:^()
     
     {
         [self.view makeToast:@"取消"];
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)clearDatas
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.view makeToast:@"清除成功"];
}


#pragma mark - 退出
- (void)eventWithExit
{
    [APService setTags:nil alias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];

    [Infomation deleteInfo];
    [_menu touchesLeftItem];
    [_main hasLogin];
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
