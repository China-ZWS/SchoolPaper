//
//  TopicDetailsViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "TopicDetailsViewController.h"
#import "TopicDetailsCell.h"
#import "ChatInputView.h"

@interface TopicDetailsViewController ()
<ChatInputViewDelegate>
{
    NSDictionary *_dic;
    NSMutableDictionary *_datas;
    ChatInputView *_input;
}
@property (nonatomic, strong) UIButton *plBtn;
@property (nonatomic, strong) UIButton *zanBtn;
@end

@implementation TopicDetailsViewController


- (id)initWithDatas:(NSDictionary *)datas;
{
    if ((self = [super init])) {
        _dic = datas;
        [self.navigationItem setNewTitle:[Base64 textFromBase64String:datas[@"boardtitle"]]];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
    }
    return self;
}

- (void)back
{
    [self.navigationController  setToolbarHidden:YES animated:YES];
    [self popViewController];
}


- (UIButton *)plBtn
{
    if (!_plBtn) {
        _plBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _plBtn.frame = CGRectMake(0, 0, DeviceW / 2 - ScaleW(30), 35);
        UIImage *talkImg = [UIImage imageNamed:@"icon_msg_white.png"];
        [_plBtn setImage:talkImg forState:UIControlStateNormal];
        _plBtn.backgroundColor = CustomBlue;
        [_plBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, ScaleW(5), 0, 0)];
        [_plBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -ScaleW(5), 0, 0)];
        [_plBtn addTarget:self action:@selector(eventWithPl:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plBtn;
}

- (void)refreshPl
{
    NSInteger num = [_datas[@"comments"] count];;
    [_plBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
}

- (UIButton *)zanBtn
{
    if (!_zanBtn) {
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanBtn.frame = CGRectMake(0, 0, DeviceW / 2 - ScaleW(30), 35);
        _zanBtn.backgroundColor = CustomBlue;
        [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, ScaleW(5), 0, 0)];
        [_zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -ScaleW(5), 0, 0)];
    }
    [self refreshZan];
     return _zanBtn;
}

- (void)refreshZan
{
    NSInteger zan = [_datas[@"zan"] integerValue];
    
    UIImage *zanImg = [UIImage imageNamed:@"icon_heart_while_press.png"];
    UIImage *zan_h = [UIImage imageNamed:@"icon_heart_white.png"];
    
    [_zanBtn setTitle:[NSString stringWithFormat:@"%ld",zan] forState:UIControlStateNormal];
    [_zanBtn setImage:zanImg forState:UIControlStateNormal];
    [_zanBtn addTarget:self action:@selector(eventWithZan:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)loadView
{
    [super loadView];
    [self.navigationController  setToolbarHidden:NO animated:YES];
    self.navigationController.toolbar.barTintColor = RGBA(230, 230, 230, .5);
    self.navigationController.toolbar.tintColor = RGBA(230, 230, 230, .5);
    NSMutableArray *tbitems = [NSMutableArray array];
    UIBarButtonItem *plBtn = [[UIBarButtonItem alloc] initWithCustomView:self.plBtn];
    UIBarButtonItem *zanBtn = [[UIBarButtonItem alloc] initWithCustomView:self.zanBtn];

    [tbitems addObject:plBtn];
    [tbitems addObject:zanBtn];
    [self setToolbarItems:tbitems];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    _input = [ChatInputView inputWithScrollView:_table];
    _input.delegate = self;
    _input.font = Font(18);
    _input.type = kDefult;
    _input.beginShowType = kBeginHiden;
    [self.view addSubview:_input];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count?1:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    TopicDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[TopicDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.datas = _datas;
    CGRect cellRect = cell.frame;
    if (CGRectGetHeight(cell.plList.frame))
    {
        cellRect.size.height = CGRectGetMaxY(cell.plList.frame) + ScaleW(15);
    }
    else if (CGRectGetHeight(cell.collectionView.frame))
    {
        cellRect.size.height = CGRectGetMaxY(cell.collectionView.frame) + ScaleW(15);
    }
    else
    {
        cellRect.size.height = CGRectGetMaxY(cell.contentLb.frame) + ScaleW(15);
    }
    cell.frame = cellRect;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshDatas;
{
    
    [self.view endEditing:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"boardId"] = _dic[@"boardId"];
    params[@"page"] = @"1";
    params[@"pageSize"] = [NSString stringWithFormat:@"%d",INT16_MAX];
    _connection = [BaseModel POST:boardInfoServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       _datas = [self createDatas:data[@"data"]];

                       [self refreshPl];
                       [self refreshZan];
                       [self reloadTabData];
                       [_table.header endRefreshing];
     
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [_table.header endRefreshing];
                   }];
}

- (void)eventWithPl:(UIButton *)button
{
    
    [_input presentWithKeyboard];
}

#pragma mark - inputDelegate
- (BOOL)inputView:(ChatInputView *)inputView inputOfText:(NSString *)text;
{
    NSMutableArray *comments = _datas[@"comments"];
    [self.view endEditing:YES];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"postId"] = _datas[@"boardId"];
    params[@"replyContent"] = _input.field.text;
    params[@"type"] = @"2";
    params[@"userId"] = [Infomation readInfo][@"id"];


    NSMutableDictionary *commentsDic = [NSMutableDictionary dictionary];
    commentsDic[@"comment"] = [Base64 base64StringFromText: params[@"replyContent"]];
    commentsDic[@"commentName"] = [Infomation readInfo][@"name"];
    [comments addObject:commentsDic];
    [self reloadTabData];
//    CGPoint bottomOffset = CGPointMake(_table.contentOffset.x, (_table.contentSize.height - _table.bounds.size.height + 44>0)?_table.contentSize.height - _table.bounds.size.height + 44:0);
//    [_table setContentOffset:bottomOffset animated:NO];

    _connection = [BaseModel POST:submitTieReplyServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"回帖成功" duration:.5 position:@"center"];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                   }];
    return YES;

}

- (void)eventWithZan:(UIButton *)zanBtn
{
    
    if (![_datas[@"zan"] integerValue])
    {
        _datas[@"zan"] = [NSString stringWithFormat:@"%d",[_datas[@"zan"] integerValue] + 1];
    }
    else
    {
        [self.view makeToast:@"你已经点过赞了!" duration:.5 position:@"center"];
        return;
    }
    [self refreshZan];
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"postId"] = _datas[@"boardId"];
    params[@"type"] = @"2";
    
    
    _connection = [BaseModel POST:submitTieZanServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"点赞成功" duration:.5 position:@"center"];
                       NSNotificationPost(RefreshWithViews, nil, nil);

                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                   }];
}



- (NSMutableDictionary *)createDatas:(NSDictionary*)datas
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    for (NSString *key in datas)
    {
        if ([key isEqualToString:@"comments"])
        {
            NSMutableArray *comments = [NSMutableArray arrayWithArray:datas[key]];
            data[key] = comments;
        }
        else
        {
            data[key] = datas[key];
        }
    }

    return data;
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
