//
//  HSCircleViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-1.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "HSCircleViewController.h"
#import "HSCircleCell.h"
#import "CircleDetailViewController.h"
#import "CircleTopicViewController.h"

@interface HSCircleViewController ()
{
    NSInteger _currentPage;
    NSMutableArray *_datas;
}
@end

@implementation HSCircleViewController


- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"家校圈"];
        _datas = [NSMutableArray array];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    
    _table.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    [_table.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(120);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    HSCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HSCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.datas = _datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _datas[indexPath.row];
    if ([dic[@"circleType"] integerValue] == 1 || [dic[@"circleType"] integerValue] == 2) {
        [self pushViewController:[[CircleDetailViewController alloc] initWithDatas:dic]];
    }
    else
    {
        [self pushViewController:[[CircleTopicViewController alloc] initWithDatas:dic]];
    }

    
}

- (void)refreshDatas:(id)sender
{
    if ([sender isKindOfClass:[MJChiBaoZiHeader class]])
    {
        _currentPage = 1;
    }
    else
    {
        _currentPage ++;
    }
    
    [self uploadDatas];
}

- (void)uploadDatas
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"schoolCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"schoolCode"]];
    params[@"classCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"classCode"]];
    params[@"page"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"pageSize"] = @"10";


    _connection = [BaseModel POST:circleServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       NSArray *temps = data[@"data"];
                       
                       if (!temps.count)
                       {
                           _currentPage --;
                       }
                       else
                       {
                           if (_currentPage == 1) {
                               [_datas removeAllObjects];
                           }
                           [_datas addObjectsFromArray:temps];
                           [self reloadTabData];
                       }
                       [_table.header endRefreshing];
                       [_table.footer endRefreshing];
                       
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
                       [_table.header endRefreshing];
                       [_table.footer endRefreshing];
                       if (_datas.count)
                       {
                           _currentPage --;
                       }
                       
                       
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
