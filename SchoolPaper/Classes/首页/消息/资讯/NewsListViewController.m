//
//  NewsListViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-2.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "NewsListViewController.h"
#import "MJRefresh.h"
#import "NewsCell.h"
#import "NewsDetailViewController.h"
#import "PJTableView.h"
#import "DataConfigManager.h"

@interface NewsListViewController ()
<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NewsListViewController


- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"资讯详情"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
        _datas = [NSMutableArray arrayWithArray:[DataConfigManager getArchiveWithNewsDatas]];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    [_table.header beginRefreshing];}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{;
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas[section][@"news"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return ScaleW(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        return  (DeviceW - ScaleW(10) * 2) / 1.3322 + ScaleH(10) * 2;
    }
    return ScaleH(100) / 1.3322 + ScaleH(10) * 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    CGSize size = [NSObject getSizeWithText:_datas[section][@"mainTime" ] font:Font(17) maxSize:CGSizeMake(CGRectGetWidth(tableView.frame), ScaleW(20))];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(tableView.frame) - size.width) / 2, ScaleW(50) - size.height - ScaleH(10), size.width, size.height)];
    title.font = Font(17);
    title.backgroundColor = [UIColor clearColor];
    title.textColor = CustomGray;
    title.text = _datas[section][@"mainTime"];
    [view addSubview:title];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setDatas:_datas[indexPath.section][@"news"] indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:[[NewsDetailViewController alloc] initWithDatas:_datas[indexPath.section][@"news"][indexPath.row][@"newsId"]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 拉取数据
- (void)refreshDatas;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"time"] =  [DataConfigManager getArchiveWithNewsTime];
    
    _connection = [BaseModel POST:mainNewsServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       NSMutableArray *datas = data[@"data"];
                       if ([datas count])
                       {
                           
                           if (_datas.count)
                           {
                               
                               [_datas addObjectsFromArray:datas];
                           }
                           else
                           {
                               _datas = datas;
                               

                           }
                           [DataConfigManager archiveWithNewsDatas:_datas];
                       }
                       
                       [DataConfigManager archiveWithNewsTime:nil];
                       [self reloadTabData];
                       [_table.header endRefreshing ];
                       
                       
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_table.frame toView:_table abnormalType:NotDatas];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:self.table];
                       }

                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [_table.header endRefreshing ];
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_table.frame toView:_table abnormalType:NotNetWork];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.table];
                           }
                           
                       }
                       else
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_table.frame toView:_table abnormalType:NotDatas];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.table];
                           }
                           
                       }

                   }];
    
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