//
//  SearchBarViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "HSSearchBarViewController.h"
#import "HSSearchCell.h"

@interface HSSearchBarViewController ()
{
    NSDictionary *_datas;
}
@end

@implementation HSSearchBarViewController


- (id)initWithDatas:(NSDictionary *)datas
{
    if ((self = [super init]))
    {
        _datas = datas;
        [self.navigationItem setNewTitle:@"搜索结果"];
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
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new] ;
    headerView.backgroundColor = RGBA(230, 230, 230, 1);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(ScaleX(20), 0, DeviceW, ScaleH(40))];
    title.textColor = CustomBlack;
    title.text = _datas[@"key"];
    [headerView addSubview:title];

    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas[@"datas"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    HSSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HSSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setDatas:_datas indexPath:indexPath];;
    return cell;
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
