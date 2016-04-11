//
//  AchievementViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-2.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AchievementViewController.h"
#import "AchievementCell.h"
#import "AchievementHeader.h"
#import "PJTableView.h"

static NSString *const cellIdentifier = @"cellIdentifier";



@interface AchievementViewController ()
<AchievementHeaderDelegate>
{
    NSArray *_datas;
    NSString *_kc;
    NSString *_xnd;
    NSString *_xq;
}
@end



@implementation AchievementViewController


- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"成 绩"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
        _kc = @"";
        _xnd = @"2015-2016";
        _xq = @"上";
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AchievementHeader *view = [[AchievementHeader alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(100)) ];
    view.delegate = self;
    [self.view addSubview:view];

    
    self.tableWithFrame = CGRectMake(0, CGRectGetHeight(view.frame), DeviceW, CGRectGetHeight(self.view.frame) - CGRectGetHeight(view.frame));
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    [_table.header beginRefreshing];
    [_table registerClass:[AchievementCell class] forCellReuseIdentifier:cellIdentifier];
}

- (UIView *)getHeaderView
{
    AchievementHeader *view = [[AchievementHeader alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(100))];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(70);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    [cell setDatas:(indexPath.row?_datas[indexPath.row - 1]:nil) indexPath:indexPath];
    return cell;
}


- (void)refreshDatas{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xxCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"schoolCode"]];
    params[@"classNo"] = [Base64 textFromBase64String:[Infomation readInfo][@"classCode"]];
    params[@"xcode"] = [Base64 textFromBase64String:[Infomation readInfo][@"xcode"]];
    params[@"kc"] = _kc;
    params[@"xnd"] = _xnd;
    params[@"xq"] = _xq;

    
    _connection = [BaseModel POST:xKscjServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       _datas = data[@"data"];
                       [self reloadTabData];
                       [_table.header endRefreshing];
                       
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_table.bounds toView:_table abnormalType:NotDatas];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:self.table];
                       }
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       
                       [self.view makeToast:msg];
                       [_table.header endRefreshing];
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_table.bounds toView:_table abnormalType:NotDatas];
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
                               [AbnormalView setRect:_table.bounds toView:_table abnormalType:NotDatas];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.table];
                           }
                           
                       }

                   }];
}


- (void)returnDatas:(NSDictionary *)dic
{
    _kc = dic[@"kc"];
    _xnd = [dic[@"semester"] substringWithRange:NSMakeRange(0,9)];
    _xq = [dic[@"semester"] substringWithRange:NSMakeRange(9, 1)];
    [_table.header beginRefreshing];
    
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
