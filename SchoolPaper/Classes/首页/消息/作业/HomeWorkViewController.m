//
//  HomeWorkViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-2.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "HomeWorkViewController.h"
#import "MJRefresh.h"
#import "HomeWorkCell.h"
#import "DataConfigManager.h"

@interface HomeWorkViewController ()
{
    NSMutableArray *_datas;
    NSString *_hwBegTime;
    NSString *_hwEndTime;

}
@end

@implementation HomeWorkViewController



- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"作 业"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
        _datas = [NSMutableArray array];
    
    }
    return self;
}

- (void)back
{
    [self popViewController];
}


- (void)viewDidLoad {
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
    
    UITableViewCell * cell = (UITableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    HomeWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HomeWorkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.datas = _datas[indexPath.row];
    

    CGFloat maxY = (CGRectGetMaxY(cell.hour.frame) > CGRectGetMaxY(cell.title.frame)?CGRectGetMaxY(cell.hour.frame):CGRectGetMaxY(cell.title.frame)) + ScaleH(15);
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = maxY;
    cell.frame = cellFrame;
    
    return cell;
}


- (void)refreshDatas:(id)sender
{
    BOOL isHeader = NO;
    if ([sender isKindOfClass:[MJChiBaoZiHeader class]])
    {
        _hwBegTime = nil, _hwEndTime = nil;
        isHeader = YES;
    }
    
    if (!_hwBegTime.length && !_hwEndTime.length) {
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *locationString=[dateFormatter stringFromDate:senddate];
        _hwEndTime = locationString;
        [NSObject setNowDate:locationString format:@"yyyy-MM-dd" getFirstDayOfWeek:^(NSString *date)
         {
             _hwBegTime = date;
         }
            getLastDayOfWeek:^(NSString *date)
         {
             
         }];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xxCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"schoolCode"]];
    params[@"classNo"] = [Base64 textFromBase64String:[Infomation readInfo][@"classCode"]];
    params[@"hwBegTime"] = _hwBegTime;
    params[@"hwEndTime"] = _hwEndTime;
    
    _connection = [BaseModel POST:xHwServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       NSMutableArray *datas = data[@"data"];
                      
                       if ([datas count])
                       {
                           if (isHeader) {
                               [_datas removeAllObjects];
                           }
//                           [_datas insertObjects:datas atIndexes: [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_datas.count,[datas count])]];
                           [_datas addObjectsFromArray:[[datas reverseObjectEnumerator] allObjects]];
                           NSString *nowDate = [NSObject pushedBackSevenDays:[datas[0][@"hwDate"] componentsSeparatedByString:@" "][0] format:@"yyyy-MM-dd"];

                           [NSObject setNowDate:nowDate format:@"yyyy-MM-dd" getFirstDayOfWeek:^(NSString *date)
                            {
                                _hwBegTime = date;
                            }
                               getLastDayOfWeek:^(NSString *date)
                            {
                                _hwEndTime = date;
                            }];

                           [_table reloadData];

                           [DataConfigManager archiveWithHomeWorkDatas:datas[datas.count - 1]];
                       }
                       
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_table.frame toView:_table abnormalType:NotDatas];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:self.table];
                       }
                       
                       [self.table.header endRefreshing];
                       [self.table.footer endRefreshing ];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                    
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
  
                       [self.view makeToast:msg];
                       [_table.footer endRefreshing ];
                       [_table.header endRefreshing];
                   }];
}


- (void)didReceiveMemoryWarning {
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
