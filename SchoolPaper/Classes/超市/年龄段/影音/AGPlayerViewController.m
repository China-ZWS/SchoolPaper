//
//  AGPlayerViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-2.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AGPlayerViewController.h"
#import "AGPlayerCell.h"

#import "AGPlayerDetailsViewController.h"
#import "AGPDTextViewController.h"
#import "AGPDCatalogViewController.h"
#import "AGPDCommentViewController.h"


@interface AGPlayerViewController ()

@end

@implementation AGPlayerViewController



- (id)initWithStageId:(NSString *)stageId;
{
    if ((self = [super initWithStageId:stageId]))
    {
        self.title = @"影 音";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cellIdentifer";
    AGPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[AGPlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    NSDictionary *datas = _datas[indexPath.row];
    cell.datas = datas;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *datas = _datas[indexPath.row];
    NSArray *viewControllers = @[[AGPDTextViewController new],[AGPDCatalogViewController new],[[AGPDCommentViewController alloc] initWithDatas:datas]];
    AGPlayerDetailsViewController *controller = [[AGPlayerDetailsViewController alloc] initWithViewControllers:viewControllers datas:datas];
    [self pushViewController:controller];
}


- (void)uploadDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"search_key"] = _search_key;
    params[@"scheme_id"] = _scheme_id;
    params[@"scheme_type_id"] = _scheme_type_id;
    params[@"subject_id"] = _subject_id;
    params[@"stage_id"] = _stage_id;
    params[@"res_type"] = @"MEDIA";
    params[@"page_number"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"page_size"] = @"10";
    
    _connection = [BaseModel POST:findresbystage parameter:params   class:[BaseModel class]
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
                       
                       if (![_datas count])
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
                       if ([_datas count])
                       {
                           _currentPage --;
                       }
                       
                       
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (![_datas count])
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
                           if (![_datas count])
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent NS_AVAILABLE_IOS(5_0);
{
    
}

- (void)willMoveToParentViewController:(nullable UIViewController *)parent NS_AVAILABLE_IOS(5_0);
{

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
