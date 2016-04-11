//
//  DetailOrganizationViewController.m
//  SchoolPaper
//
//  Created by 周文松 on 15/10/20.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "DetailOrganizationViewController.h"
#import "DetailsViewController.h"
#import "BusinessDetailViewController.h"
#import "OGCommentViewController.h"

@interface DetailOrganizationViewController ()
<SideSegmentControllerDelegate>
{
    NSArray *_datas;
    UIViewController *_currentController;
    NSString *_parameter;

}
@end

@implementation DetailOrganizationViewController

- (id)initWithViewControllers:(NSArray *)viewControllers andId:(NSString *)parameter;
{
    if ((self = [super initWithViewControllers:viewControllers])) {
        self.delegate = self;
        _parameter = parameter;
        [self.navigationItem setNewTitle:@"详情"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lineColor = CustomBlue;
    self.titleColor = CustomBlack;
    self.selectedTitleColor = CustomBlue;
}

- (void)setUpDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = _parameter;

    _connection = [BaseModel POST:getsellerproductbyid parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       _datas = data[@"data"];
                       DetailsViewController *ctr = (DetailsViewController *)_currentController;
                       ctr.datas = _datas;
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                   }];

}

- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController;
{
    _currentController = viewController;
    if ([viewController isKindOfClass:[DetailsViewController class]]) {
        DetailsViewController *ctr = (DetailsViewController *)viewController;
        ctr.datas = _datas;
    }
    else if ([viewController isKindOfClass:[BusinessDetailViewController class]])
    {
        BusinessDetailViewController *ctr = (BusinessDetailViewController *)viewController;
        ctr.datas = _datas;
    }
    else if ([viewController isKindOfClass:[OGCommentViewController class]])
    {
        OGCommentViewController *ctr = (OGCommentViewController *)viewController;
        ctr.dic = _datas;
    }

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
