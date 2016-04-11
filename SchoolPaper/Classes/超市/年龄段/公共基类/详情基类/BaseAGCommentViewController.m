//
//  BaseAGCommentViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-9.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseAGCommentViewController.h"
#import "BaseAGCommentCell.h"
#import "MJRefresh.h"
@interface BaseAGCommentViewController ()
{
    NSMutableArray *_datas;
    NSDictionary *_dic;
    NSInteger _currentPage;
    BOOL _allowRefresh;
}
@end

@implementation BaseAGCommentViewController


- (id)initWithDatas:(id)datas;
{
    if ((self = [super init])) {
        self.title = @"评 论";
        _dic = datas;
        _allowRefresh = YES;
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    _table.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat inset = ScaleH(10);
    NSDictionary *datas = _datas[indexPath.row];
    NSString *content = [Base64 textFromBase64String:datas[@"content"]];
    CGSize contentSize = [NSObject getSizeWithText:content font:Font(15) maxSize:CGSizeMake(DeviceW - ScaleW(60) - inset * 2, MAXFLOAT)];
    if (FontBold(17).lineHeight + contentSize.height + inset > ScaleH(60)) {
        return inset * 4 + FontBold(17).lineHeight + contentSize.height  + ScaleH(20);
    }
    else
    {
        return inset * 3 + ScaleH(60) + ScaleH(20);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    BaseAGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BaseAGCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.datas = _datas[indexPath.row];
    return cell;
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"resource_id"] = _dic[@"id"];
    params[@"page_number"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"page_size"] = @"10";
    
    _connection = [BaseModel POST:getresappraise parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       NSMutableArray *temps = data[@"data"];
                       
                       if (!temps.count && _currentPage > 1)
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
                           [AbnormalView setDelegate:self toView:_table];
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
                               [AbnormalView setDelegate:self toView:_table];
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
                               [AbnormalView setRect:_table.frame toView:_table abnormalType:kError];
                               [AbnormalView setDelegate:self toView:_table];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.table];
                           }
                       }
                   }];
}


- (void)refreshWithSeleted
{
    if (_allowRefresh)
    {
        _allowRefresh = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_table.header beginRefreshing];
        });
    }
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
