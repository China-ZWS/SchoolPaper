//
//  BaseActivityViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/24.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseActivityViewController.h"
#import "PJCell.h"
#import "ActivityDetailsViewController.h"

@interface ActivityCell : PJCell
@property (nonatomic, strong) UIButton *status;
@end

@implementation ActivityCell


- (void)drawRect:(CGRect)rect
{
    [self drawCellWithRound:rect cellStyle:kRoundCell inset:kDefaultInset radius:3 lineWidth:.5 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _title = [UILabel new];
        _title.font = FontBold(17);
        _title.numberOfLines = 2;
        _title.textColor = [UIColor blackColor];
        
        _abstracts = [UILabel new];
        _abstracts.font = Font(15);
        _abstracts.textColor = CustomBlack;
        
        _status = [UIButton buttonWithType:UIButtonTypeCustom];
        [_status setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _status.titleLabel.font = Font(17);
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_abstracts];
//        [self.contentView addSubview:_status];  先毙掉
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headImageView.frame = CGRectMake(kDefaultInset.left * 2, (ScaleH(110) - ScaleW(90)) / 2, ScaleW(90), ScaleH(90));
    _status.frame = CGRectMake(DeviceW - kDefaultInset.right * 2 - ScaleW(60), (ScaleH(110) - ScaleH(60)) / 2, ScaleW(60), ScaleH(60));
    _status.layer.cornerRadius = ScaleH(30);
    _status.layer.masksToBounds =YES;
    
    NSString *name = [Base64 textFromBase64String:_datas[@"name"]];
    CGSize nameSize = [NSObject getSizeWithText:name font:_title.font maxSize:CGSizeMake(DeviceW - kDefaultInset.right * 6 - CGRectGetWidth(_status.frame) - CGRectGetWidth(_headImageView.frame), _title.font.lineHeight * 2)];
    CGFloat allHeight = nameSize.height + kDefaultInset.top * 2 + _abstracts.font.lineHeight;
    
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kDefaultInset.right, (ScaleH(110) - allHeight) / 2, nameSize.width, nameSize.height);
    
    _abstracts.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMaxY(_title.frame) + kDefaultInset.top * 2, DeviceW - kDefaultInset.right * 3, _abstracts.font.lineHeight);
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    NSString *viewImg = [Base64 textFromBase64String:datas[@"viewImage"]];
    NSString *name = [Base64 textFromBase64String:datas[@"name"]];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:datas[@"enrollEndate"]];
    NSString *enrollEndate = [NSObject compareCurrentTimeToPastTime:date];
    
    BOOL isEnroll = [datas[@"isEnroll"] boolValue];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:viewImg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
    _title.text = name;
    _abstracts.text = [NSString stringWithFormat:@"截止日期:%@",enrollEndate];
    
    if (isEnroll) {
        [_status setTitle:@"已报" forState:UIControlStateNormal];
        _status.backgroundColor = CustomGray;
    }
    else
    {
        [_status setTitle:@"报" forState:UIControlStateNormal];
        _status.backgroundColor = CustomBlue;
    }
}

@end

@interface BaseActivityViewController ()

@end

@implementation BaseActivityViewController



- (id)init
{
    if ((self = [super init])) {
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    
    _table.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    [_table.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(110);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.datas = _datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityDetailsViewController *controller = [[ActivityDetailsViewController alloc] initWithDatas:_datas[indexPath.row]];
    [self pushViewController:controller];
}

- (void)refreshDatas:(id)sender
{
    if ([sender isKindOfClass:[MJChiBaoZiHeader class]]){
        _currentPage = 1;
    }
    else
    {
        _currentPage ++;
    }
    
    [self uploadDatas:nil];
}

- (void)uploadDatas:(NSString *)status;
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];    
    params[@"page_number"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"page_size"] = @"10";
    params[@"status"] = status;
 
    _connection = [BaseModel POST:getactivitys parameter:params class:[BaseModel class]
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
