//
//  OGCommentViewController.m
//  SchoolPaper
//
//  Created by 周文松 on 15/10/20.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "OGCommentViewController.h"
#import "PJCell.h"
#import "StarRateView.h"

@interface OGCell : PJCell
@property (nonatomic, strong) StarRateView *rate;

@end

@implementation OGCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.textLabel.font = FontBold(17);
        _createTime = [UILabel new];
        _createTime.font = Font(15);
        _createTime.textColor = CustomBlack;
        
        self.detailTextLabel.font = Font(15);
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = CustomBlack;
        _rate = [StarRateView new];
        _rate.allowUserInteraction = NO;
        
        [self.contentView addSubview:_createTime];
        [self.contentView addSubview:_rate];
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat inset = ScaleH(10);
    self.imageView.frame = CGRectMake(inset, inset, ScaleW(60), ScaleH(60));
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x =  CGRectGetMaxX(self.imageView.frame) + inset;
    textLabelFrame.origin.y = CGRectGetMidY(self.imageView.frame) - self.textLabel.font.lineHeight - inset / 2;
    self.textLabel.frame = textLabelFrame;
    
    
    
    NSString *content = [Base64 textFromBase64String:_datas[@"appraiseContent"]];
    
    if (!content.length) {
        content = @"（空）";
    }
    CGSize contentSize = [NSObject getSizeWithText:content font:self.detailTextLabel.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(self.imageView.frame) - inset, MAXFLOAT)];
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + inset, CGRectGetMidY(self.imageView.frame) + inset / 2, contentSize.width, contentSize.height);
    
    if (self.textLabel.font.lineHeight + contentSize.height + inset > CGRectGetHeight(self.imageView.frame)) {
        [_rate setFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + inset, CGRectGetMaxY(self.detailTextLabel.frame) + inset, ScaleW(120), ScaleH(20)) starCount:5];
    }
    else
    {
        [_rate setFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + inset, CGRectGetMaxY(self.imageView.frame) + inset, ScaleW(120), ScaleH(20)) starCount:5];
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:_datas[@"appraiseDate"]];
    NSString *createTime = [NSObject compareCurrentTimeToPastTime:date];
    CGSize createTimeSize = [NSObject getSizeWithText:createTime font:_createTime.font maxSize:CGSizeMake(DeviceW, _createTime.font.lineHeight)];
    _createTime.frame = CGRectMake(DeviceW - CGRectGetMaxX(self.imageView.frame) + inset * 2 - createTimeSize.width, CGRectGetMinY(self.imageView.frame), createTimeSize.width, createTimeSize.height);
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetMaxX(self.imageView.frame) + inset, 0, 0)];
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    NSString *topImg = [Base64 textFromBase64String:datas[@"appraiserTopimg"]];
    NSString *userName = [Base64 textFromBase64String:datas[@"appraiserName"]];
    NSString *content = [Base64 textFromBase64String:datas[@"appraiseContent"]];
    
    if (!content.length) {
        content = @"（空）";
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:datas[@"appraiseDate"]];
    NSString *createTime = [NSObject compareCurrentTimeToPastTime:date];
    _createTime.text = createTime;
    
    CGFloat score = [datas[@"appraiseScore"] floatValue];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topImg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
    self.textLabel.text = userName;
    self.detailTextLabel.text = content;
    _rate.percentage = score / 5;
}

@end

@interface OGCommentViewController ()
{
    NSInteger _currentPage;
}
@end

@implementation OGCommentViewController

- (id)init
{
    if ((self = [super init])) {
        self.title = @"评论";
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)setDic:(id)dic
{
    _dic = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
//    _table.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_table.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat inset = ScaleH(10);
    NSDictionary *datas = _datas[indexPath.row];
    NSString *content = [Base64 textFromBase64String:datas[@"appraiseContent"]];
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
    OGCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OGCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
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
    params[@"product_id"] = _dic[@"id"];
    params[@"page_number"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"page_size"] = @"10";
    
    _connection = [BaseModel POST:sellerappraise parameter:params   class:[BaseModel class]
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
