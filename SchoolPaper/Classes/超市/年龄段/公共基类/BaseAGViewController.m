//
//  BaseAGViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseAGViewController.h"

@interface BaseAGViewController ()
{
    
}
@end

@implementation BaseAGViewController



- (id)initWithStageId:(NSString *)stageId;
{
    if ((self = [super init]))
    {
        _allowRefresh = YES;
        _search_key = @"";
        _scheme_id = @"1";
        _scheme_type_id = @"0";
        _subject_id = @"0";
        _stage_id = stageId;
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];
    
    _table.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas:)];

    NSNotificationAdd(self, refresh:, @"refresh", nil);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat inset = ScaleH(10);
    CGFloat contentHeight = 0;
    NSDictionary *dic = _datas[indexPath.row];
    NSString *tipContent = [Base64 textFromBase64String:dic[@"tipContent"]];
        CGSize tipContentSize = [NSObject getSizeWithText:tipContent font:Font(17) maxSize:CGSizeMake(DeviceW - kDefaultInset.left - kDefaultInset.right - ScaleW(70) - ScaleW(10) * 3, MAXFLOAT)];
    if (tipContentSize.height < Font(17).lineHeight * 3) {
        contentHeight = tipContentSize.height;
    }
    else
    {
        contentHeight = Font(17).lineHeight * 3;
    }

    CGFloat upHeight = (ScaleH(70) > (Font(17).lineHeight * 2 + ScaleH(10)))?ScaleH(70):(Font(17).lineHeight * 2 + ScaleH(10));
   
    return kDefaultInset.top + kDefaultInset.bottom + inset + upHeight + inset + contentHeight + inset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
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


- (void)refresh:(NSNotification *)notification
{
    _allowRefresh = YES;
    _scheme_id = notification.object[@"schemeId"];
    _scheme_type_id = notification.object[@"scheme_type_id"];
    _subject_id = notification.object[@"subject_id"];
    
    
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

- (void)uploadDatas
{
    
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
