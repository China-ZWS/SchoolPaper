//
//  LocalMoreViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/19.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "LocalMoreViewController.h"
#import "MoreHeader.h"
#import "DetailOrganizationViewController.h"
#import "DetailsViewController.h"
#import "BusinessDetailViewController.h"
#import "OGCommentViewController.h"

@interface LocalMoreViewController ()
{
    MoreHeader *_headerView;
}
@end

@implementation LocalMoreViewController

- (id)initWithDatas:(NSDictionary *)datas
{
    if ((self = [super initWithDatas:datas])) {
        [self.navigationItem setNewTitle:@"本地培训机构"];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableWithFrame = CGRectMake(0, 44, DeviceW, CGRectGetHeight(self.view.frame) - 44);
    LocalMoreViewController __weak* safeSelf = self;
    _headerView = [[MoreHeader alloc] initWithFrame:CGRectMake(0, 0, DeviceW, 44) selected:^(id datas)
                   {
                       [safeSelf refreshRequest:datas];
                   }];
    [self.view addSubview:_headerView];
}

- (void)refreshRequest:(NSDictionary *)data
{
    [super refreshRequest:data];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *viewControllers = @[[DetailsViewController  new], [BusinessDetailViewController new],  [OGCommentViewController new]];
    DetailOrganizationViewController *controller = [[DetailOrganizationViewController alloc] initWithViewControllers:viewControllers andId:_datas[indexPath.section][@"seller_product"][indexPath.row - 1][@"id"]];
    [self pushViewController:controller];
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
