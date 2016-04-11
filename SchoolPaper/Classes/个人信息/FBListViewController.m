//
//  AboutListViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-20.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "FBListViewController.h"
#import "FeedBackCell.h"

@interface FBListViewController ()

@end

@implementation FBListViewController

- (id)initWithOptions:(void (^)(NSString *type))options;
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"选择类型"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
        _options = options;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(60);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    FeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[FeedBackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.textLabel setTextColor:CustomBlue];
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"程序出错";
            break;
        case 1:
            cell.textLabel.text = @"资源出错";
            break;
        case 2:
            cell.textLabel.text = @"显示异常";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedBackCell *cell = (FeedBackCell *)[tableView cellForRowAtIndexPath:indexPath];
       
    _options(cell.textLabel.text);
    [self back];
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
