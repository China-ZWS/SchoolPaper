//
//  BaseLMViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/19.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseLMViewController.h"
#import "PJCell.h"
#import "ToolSingleton.h"

@interface LocalMoreCell : PJCell
{
    NSInteger _index;
}
@property (nonatomic, strong) NSDictionary *dicDatas;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setDatas:(id)datas index:(NSInteger)index;
@end

@implementation LocalMoreCell

- (void)drawRect:(CGRect)rect
{
     if (_index == 0)
    {
        [self drawCellWithRound:rect cellStyle:kUpCell inset:kDefaultInset radius:3 lineWidth:.5 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
        [self drawRectWithLine:rect start:CGPointMake(kDefaultInset.left, CGRectGetHeight(rect)- .5) end:CGPointMake(CGRectGetWidth(rect) - kDefaultInset.right, CGRectGetHeight(rect)- .5) lineColor:CustomGray lineWidth:.5];
       
        
        NSString *lat = [_dicDatas[@"seller_lat"] stringValue];
        NSString *lng = [_dicDatas[@"seller_lng"] stringValue];
        NSString *distance = [[ToolSingleton getInstance] getLocationDistanceWithLatitude:lat longitude:lng];
        CGSize distanceSize = [NSObject getSizeWithText:distance font:Font(15) maxSize:CGSizeMake(MAXFLOAT, Font(15).lineHeight)];
        CGFloat distanceMinx = DeviceW - distanceSize.width - kDefaultInset.right * 2;
       
        NSString *areas = [Base64 textFromBase64String:_dicDatas[@"seller_areas"]];
        CGSize areasSize = [NSObject getSizeWithText:areas font:Font(15) maxSize:CGSizeMake(MAXFLOAT, Font(15).lineHeight)];
        CGFloat areasMinX =  distanceMinx - ScaleW(5) - areasSize.width;
        
        
        NSString *name = [Base64 textFromBase64String:_dicDatas[@"seller_name"]];
        CGSize nameSize = [NSObject getSizeWithText:name font:FontBold(17) maxSize:CGSizeMake(areasMinX - 2 * kDefaultInset.left * 2, MAXFLOAT)];
        
        CGFloat nameMinY = kDefaultInset.top * 2;
        CGFloat cellHeight = nameMinY + nameSize.height + kDefaultInset.bottom;
        [self drawTextWithText:name rect:CGRectMake(kDefaultInset.left * 2, nameMinY, nameSize.width, nameSize.height) color:[UIColor blackColor] font:FontBold(17)];
        
        
        CGFloat distanceMiny = kDefaultInset.top + (cellHeight - kDefaultInset.top - distanceSize.height) / 2;
        CGFloat distanceMaxY = distanceMiny + distanceSize.height;
        [self drawTextWithText:distance rect:CGRectMake(distanceMinx, distanceMiny, distanceSize.width, distanceSize.height) color:CustomBlack font:Font(15)];
        [self drawRectWithLine:rect start:CGPointMake(distanceMinx - ScaleW(2.75), distanceMiny) end:CGPointMake(distanceMinx - ScaleW(2.75), distanceMaxY) lineColor:CustomBlack lineWidth:.5];
        [self drawTextWithText:areas rect:CGRectMake(areasMinX, distanceMiny, areasSize.width, areasSize.height) color:CustomBlack font:Font(15)];
        
    }
    else if (_index < [_datas count])
    {
        [self drawCellWithRound:rect cellStyle:kCenterCell inset:kDefaultInset radius:3 lineWidth:.5 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
        [self drawRectWithLine:rect start:CGPointMake(kDefaultInset.left, CGRectGetHeight(rect)- .5) end:CGPointMake(CGRectGetWidth(rect) - kDefaultInset.right, CGRectGetHeight(rect)- .5) lineColor:CustomGray lineWidth:.5];
    }
    else
    {
        [self drawCellWithRound:rect cellStyle:kDownCell inset:kDefaultInset radius:3 lineWidth:.5 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];

    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
     
        _title = [UILabel new];
        _title.font = FontBold(17);
        _title.textColor = [UIColor blackColor];
        _title.numberOfLines = 0;
        _title.backgroundColor = [UIColor clearColor];
        
        _abstracts = [UILabel new];
        _abstracts.font = Font(15);
        _abstracts.textColor = CustomBlack;
        _abstracts.numberOfLines = 0;

        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (!_index) {
        return;
    }
    else if (![_datas count])
    {
        _abstracts.frame = CGRectMake(kDefaultInset.left * 2,kDefaultInset.top,100,_abstracts.font.lineHeight);
        return;
    }
    else
    {
        NSDictionary *datas = _datas[_index - 1];
        
        _headImageView.frame = CGRectMake(kDefaultInset.left * 2, kDefaultInset.top, ScaleW(90), ScaleH(90));
        
        NSString *name = [Base64 textFromBase64String:datas[@"name"]];
        CGSize nameSize = [NSObject getSizeWithText:name font:_title.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(_headImageView.frame) - kDefaultInset.left * 3, MAXFLOAT)];
      
        _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kDefaultInset.right,CGRectGetMinY(_headImageView.frame), nameSize.width , nameSize.height);
        
        
        NSString *tipContent = [Base64 textFromBase64String:datas[@"tipContent"]];
        tipContent = [tipContent stringByAppendingString:@"..."];
        CGSize tipSize = [NSObject getSizeWithText:tipContent font:_abstracts.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(_headImageView.frame) - kDefaultInset.left * 3, MAXFLOAT)];
        _abstracts.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMaxY(_title.frame) + kDefaultInset.top, tipSize.width, tipSize.height);
    }
}



- (void)setDatas:(id)datas index:(NSInteger)index;
{
    _index = index;
    _dicDatas = datas;
    NSArray *arr = datas[@"seller_product"];
    _datas = arr;
    [self setNeedsDisplay];
    
    
    if (index)
    {
        if (arr.count)
        {
            NSDictionary *dic = arr[index - 1];
            NSString *viewImg = [Base64 textFromBase64String:dic[@"viewImg"]];
            NSString *name = [Base64 textFromBase64String:dic[@"name"]];
            NSString *tipContent = [Base64 textFromBase64String:dic[@"tipContent"]];
            tipContent = [tipContent stringByAppendingString:@"..."];
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:viewImg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
            _title.text = name;
            _abstracts.text = tipContent;
            _headImageView.hidden = NO;
            _title.hidden = NO;
            _abstracts.hidden = NO;

        }
        else
        {
            _abstracts.text = @"暂无数据";
            _title.hidden = YES;
            _abstracts.hidden = NO;
            _headImageView.hidden = YES;
        }
    }
    else
    {
        _headImageView.hidden = YES;
        _title.hidden = YES;
        _abstracts.hidden = YES;
    }
}
@end

@interface BaseLMViewController ()
@end

@implementation BaseLMViewController


- (id)initWithDatas:(NSDictionary *)datas
{
    if ((self = [super initWithTableViewStyle:UITableViewStyleGrouped])) {
        _stage_id = datas[@"stage_id"];
        _subject_id = datas[@"subject_id"];
        _area_id = datas[@"area_id"];
        _seller_id = datas[@"seller_id"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        _datas = [NSMutableArray array];
        [[ToolSingleton getInstance] startingGpsLocation];
        

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![_datas count]) {
        return 0;
    }
    return [_datas[section][@"seller_product"] count] + ([_datas[section][@"seller_product"] count]?1:2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)  {
        NSDictionary *dic = _datas[indexPath.section];
        
        NSString *lat = [dic[@"seller_lat"] stringValue];
        NSString *lng = [dic[@"seller_lng"] stringValue];
        NSString *distance = [[ToolSingleton getInstance] getLocationDistanceWithLatitude:lat longitude:lng];
        CGSize distanceSize = [NSObject getSizeWithText:distance font:Font(15) maxSize:CGSizeMake(MAXFLOAT, Font(15).lineHeight)];
        CGFloat distanceMinx = DeviceW - distanceSize.width - kDefaultInset.right * 2;
        
        NSString *areas = [Base64 textFromBase64String:dic[@"seller_areas"]];
        CGSize areasSize = [NSObject getSizeWithText:areas font:Font(15) maxSize:CGSizeMake(MAXFLOAT, Font(15).lineHeight)];
        CGFloat areasMinX =  distanceMinx - ScaleW(5) - areasSize.width;
        
        
        NSString *name = [Base64 textFromBase64String:dic[@"seller_name"]];
        CGSize nameSize = [NSObject getSizeWithText:name font:FontBold(17) maxSize:CGSizeMake(areasMinX - 2 * kDefaultInset.left * 2, MAXFLOAT)];
        
        CGFloat nameMinY = kDefaultInset.top * 2;
        CGFloat cellHeight = nameMinY + nameSize.height + kDefaultInset.bottom;
        return cellHeight;
        
    }
    else
    {
        
        if (![_datas[indexPath.section][@"seller_product"] count]) {
            return kDefaultInset.top + Font(15).lineHeight + kDefaultInset.bottom * 2;
        }
        
        NSDictionary *datas =  _datas[indexPath.section][@"seller_product"][indexPath.row - 1];
        CGFloat inset = kDefaultInset.top;
        
        NSString *name = [Base64 textFromBase64String:datas[@"name"]];
        CGSize nameSize = [NSObject getSizeWithText:name font:FontBold(17) maxSize:CGSizeMake(DeviceW - ScaleW(90) - kDefaultInset.left * 5, MAXFLOAT)];
        
        NSString *tipContent = [Base64 textFromBase64String:datas[@"tipContent"]];
        tipContent = [tipContent stringByAppendingString:@"..."];
        CGSize tipSize = [NSObject getSizeWithText:tipContent font:Font(15) maxSize:CGSizeMake(DeviceW - ScaleW(90) - kDefaultInset.left * 5, MAXFLOAT)];
                
        return inset * 3 + nameSize.height + tipSize.height + ((indexPath.row == [_datas[indexPath.section][@"seller_product"] count])?kDefaultInset.bottom:0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    LocalMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LocalMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dic = _datas[indexPath.section];
    [cell setDatas:dic index:indexPath.row];
    return cell;
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
    
    [self uploadDatas];
}


- (void)uploadDatas
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"stage_id"] = _stage_id;
    params[@"subject_id"] = _subject_id;
    params[@"area_id"] = _area_id;
    params[@"seller_id"] = _seller_id;

    params[@"page_number"] = [NSString stringWithFormat:@"%d",_currentPage];
    params[@"page_size"] = @"10";
    
    NSLog(@"%@",params);
    
    _connection = [BaseModel POST:findsellerproduct parameter:params   class:[BaseModel class]
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

- (void)refreshRequest:(NSDictionary *)data
{
    _stage_id = data[@"stage_id"];
    _subject_id = data[@"subject_id"];
    _area_id = data[@"area_id"];
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
