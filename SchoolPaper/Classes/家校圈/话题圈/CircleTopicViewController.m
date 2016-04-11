//
//  CircleTopicViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-5-4.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "CircleTopicViewController.h"
#import "CirclePostedViewController.h"
#import "CircleTopicCell.h"
#import "TopicDetailsViewController.h"

@interface CircleTopicViewController ()
{
    NSMutableArray *_datas;
    NSInteger _currentPage;
    NSDictionary *_dic;
}
@end

@implementation CircleTopicViewController


- (id)initWithDatas:(NSDictionary *)datas;
{
    if ((self = [super init])) {
        _dic = datas;
        [self.navigationItem setNewTitle:@"话题圈"];
        _datas = [NSMutableArray array];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(right) image:@"icon_QA.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)right
{

    [self pushViewController:[[CirclePostedViewController alloc] initWithDatas:_dic postedType:kTopic]];
}

- (UIView *)layoutHeaderView
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceW / 2)];
    [view sd_setImageWithURL:[NSURL URLWithString:_dic[@"circleImg"]] placeholderImage:[UIImage imageNamed:@"userguide_avatar_icon.png"]];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame) - ScaleH(40), DeviceW , ScaleH(40))];
    title.backgroundColor = RGBA(10, 10, 10, .6);
    title.font = FontBold(20);
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [Base64 textFromBase64String:_dic[@"circleName"]];
    [view addSubview:title];
    return view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    _table.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    [_table.header beginRefreshing];
    
    
    _table.tableHeaderView = [self layoutHeaderView];
    
    [_table.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefaultInset.top + kDefaultInset.bottom + ScaleH(60) + Font(17).lineHeight * 2 + ScaleH(30) * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    CircleTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CircleTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.datas = _datas[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:[[TopicDetailsViewController alloc] initWithDatas:_datas[indexPath.row]]];
}

- (void)refreshDatas:(id)sender;
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
    params[@"circleId"] = _dic[@"circleId"];
    params[@"page"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"pageSize"] = @"10";
    
    _connection = [BaseModel POST:boardServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       NSMutableArray *temps = data[@"data"];
                       
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

- (void)refreshWithViews
{
    
    [_table.header beginRefreshing];
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
