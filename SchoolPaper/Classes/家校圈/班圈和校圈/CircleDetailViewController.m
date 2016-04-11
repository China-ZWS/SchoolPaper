//
//  CircleDetailViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "CircleDetailCell.h"
#import "CirclePostedViewController.h"
#import "ChatInputView.h"

@interface CircleDetailViewController ()< ChatInputViewDelegate>
{
    NSInteger _currentPage;
    NSMutableArray *_datas;
    NSDictionary *_dic;
    ChatInputView *_input;
    NSIndexPath *_indexPath;
}
@end

@implementation CircleDetailViewController


- (id)initWithDatas:(NSDictionary *)datas;
{
    if ((self = [super init])) {
        _dic = datas;
        
        switch ([datas[@"circleType"] integerValue]) {
            case 1:
                [self.navigationItem setNewTitle:@"校 圈"];
                break;
            case 2:
                [self.navigationItem setNewTitle:@"班 圈"];
                break;
            case 3:
                [self.navigationItem setNewTitle:@"话题圈"];
                break;
            default:
                break;
        }
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
//    [self addNavigationWithPresentViewController:[[CirclePostedViewController alloc] initWithDatas:_dic postedType:kSchoolAndClass]];
    [self pushViewController:[[CirclePostedViewController alloc] initWithDatas:_dic postedType:kSchoolAndClass]];
}


- (UIView *)layoutHeaderView
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceW / 2)];
    [view sd_setImageWithURL:[NSURL URLWithString:_dic[@"circleImg"]] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
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
    
    
    _table.tableHeaderView = [self layoutHeaderView];
    
    
    _input = [ChatInputView inputWithScrollView:_table];
    _input.delegate = self;
    _input.font = Font(18);
    _input.type = kDefult;
    _input.beginShowType = kBeginHiden;
    [self.view addSubview:_input];
  

    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    
    _table.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    [_table.header beginRefreshing];

    
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    CircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[CircleDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.plBtn addTarget:self action:@selector(eventWithPl:) forControlEvents:UIControlEventTouchUpInside];
        [cell.zanBtn addTarget:self action:@selector(eventWithZan:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    cell.datas = _datas[indexPath.row];
    
    CGRect cellRect = cell.frame;
    if (CGRectGetHeight(cell.plList.frame))
    {
        cellRect.size.height = CGRectGetMaxY(cell.plList.frame) + ScaleW(15);
    }
    else
    {
        cellRect.size.height = CGRectGetMaxY(cell.plBtn.frame) + ScaleW(15);
    }
    cell.frame = cellRect;
    return cell;
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
    params[@"type"] = _dic[@"circleType"];
    params[@"page"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"pageSize"] = @"10";
    
    _connection = [BaseModel POST:schoolAndClassServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       NSMutableArray *temps = [self createDatas:data[@"data"]];
                       
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


- (void)eventWithPl:(UIButton *)button
{
    UITableViewCell *cell = nil;
    for (UIView* next = [button superview]; next; next =
         next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableViewCell
                                          class]])
        {
            cell = (UITableViewCell *)nextResponder;
            break;
        }
    }

    _indexPath = [_table indexPathForCell:cell];
    [_input presentWithKeyboard:button];
}

- (BOOL)inputView:(ChatInputView *)inputView inputOfText:(NSString *)text;
{
    NSMutableDictionary *dic = _datas[_indexPath.row];
    NSMutableArray *comments = dic[@"comments"];
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"postId"] = dic[@"postId"];
    params[@"replyContent"] = _input.field.text;
    params[@"type"] = @"1";
    params[@"userId"] = [Infomation readInfo][@"id"];
    
    NSMutableDictionary *commentsDic = [NSMutableDictionary dictionary];
    commentsDic[@"comment"] = [Base64 base64StringFromText: params[@"replyContent"]];
    commentsDic[@"commentName"] = [Infomation readInfo][@"name"];
    [comments addObject:commentsDic];
    [self reloadTabData];

    __block BOOL isReturn = NO;
    _connection = [BaseModel POST:submitTieReplyServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"回帖成功"];
                       isReturn = YES;
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       isReturn = NO;
                   }];
    
    return isReturn;
}


- (void)eventWithZan:(UIButton *)zanBtn
{
    NSMutableDictionary *dic = zanBtn.bindingInfo[@"data"];
    
    if (![dic[@"zan"] integerValue])
    {
        dic[@"zan"] = [NSString stringWithFormat:@"%d",[dic[@"zan"] integerValue] + 1];
    }
    else
    {
        [self.view makeToast:@"你已经点过赞了!"];
        return;
    }
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"postId"] = dic[@"postId"];
    params[@"type"] = @"1";
    
    [self reloadTabData];
    
    _connection = [BaseModel POST:submitTieZanServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"点赞成功"];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                   }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [self.view endEditing:YES];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.view endEditing:NO];
//}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSMutableArray *)createDatas:(NSArray*)datas
{
  
    
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary *dic in datas)
    {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (NSString *key in dic)
        {
            if ([key isEqualToString:@"comments"])
            {
                NSMutableArray *comments = [NSMutableArray arrayWithArray:dic[key]];
                tempDic[key] = comments;
            }
            else
            {
                tempDic[key] = dic[key];
            }
        }
        
        [data addObject:tempDic];
    }
    return data;
}


@end
