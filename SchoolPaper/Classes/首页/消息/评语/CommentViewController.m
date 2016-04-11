//
//  CommentViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-2.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "DataConfigManager.h"

@interface CommentViewController ()
@end

@implementation CommentViewController


- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"评 语"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
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
    [_table.header beginRefreshing];
    
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.datas = _datas[indexPath.row];
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = CGRectGetMaxY(cell.contentLb.frame) + ScaleH(15);
    cell.frame = cellFrame;
    return cell;
}

- (void)refreshDatas;
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xxCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"schoolCode"]];
    params[@"classNo"] = [Base64 textFromBase64String:[Infomation readInfo][@"classCode"]];
    params[@"xCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"xcode"]];
;

    _connection = [BaseModel POST:commentServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                    
                       _datas = data[@"data"];
                       [DataConfigManager archiveWithHomeCommentData:_datas[[_datas count] - 1]];
                       [_table.header endRefreshing];
                       
                       [self reloadTabData];
                       
                       if (![_datas count])
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
                       [_table.header endRefreshing];
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (![_datas count])
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
                           if (![_datas count])
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
