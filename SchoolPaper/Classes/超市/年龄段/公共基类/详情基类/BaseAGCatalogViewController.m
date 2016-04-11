//
//  BaseAGCatalogViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-9.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseAGCatalogViewController.h"

@interface BaseAGCatalogViewController ()

@end

@implementation BaseAGCatalogViewController

- (id)init
{
    if ((self = [super init])) {
        self.title = @"目 录";
    }
    return self;
}

- (void)lodingWithCatalog:(id)datas;
{
    _datas = [[datas reverseObjectEnumerator] allObjects];
    [self reloadTabData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font =  Font(17);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [Base64 textFromBase64String:_datas[indexPath.row][@"chapterNumber"]];
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didReceiveMemoryWarning
{
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
