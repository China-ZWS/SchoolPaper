//
//  AgeGroupViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-2.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AgeGroupViewController.h"
#import "AGHeaderView.h"
#import "AGDocumentViewController.h"
#import "AGPlayerViewController.h"

@interface AgeGroupViewController ()
<SideSegmentControllerDelegate>
{
    NSDictionary *_dic;
    NSMutableArray *_datas;
    NSInteger _currentPage;
    AGHeaderView *_headerView;
    UIViewController *_controller;

}
@property (nonatomic, strong) UIView *headerView;
@end

@implementation AgeGroupViewController

- (id)initWithViewControllers:(NSArray *)viewControllers datas:(NSDictionary *)datas;
{
    if ((self = [super initWithViewControllers:viewControllers])){
        self.delegate = self;
        
        _dic = datas;
        [self.navigationItem setNewTitle:[Base64 textFromBase64String:datas[@"ageName"]]];
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
    self.segmentBarFrame = CGRectMake(CGRectGetMinX(self.segmentBar.frame), 44, CGRectGetWidth(self.segmentBar.frame), CGRectGetHeight(self.segmentBar.frame));
    self.lineColor = CustomBlue;
    self.titleColor = CustomBlack;
    self.selectedTitleColor = CustomBlue;

    AgeGroupViewController __weak*safeSelf = self;
    _headerView = [[AGHeaderView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, 44) datas:_dic[@"schemetypes"] selected:^(id datas)
                   {
                       NSNotificationPost(@"refresh", datas, nil);
                       
                       [safeSelf selectViewController];
                     }];
    [self.view addSubview:_headerView];
    

}

- (void)selectViewController
{
    if ([_controller isKindOfClass:[AGPlayerViewController class]]) {
        AGPlayerViewController *ctr = (AGPlayerViewController *)_controller;
        [ctr refreshWithSeleted];
    }
    else if ([_controller isKindOfClass:[AGDocumentViewController class]])
    {
        AGDocumentViewController *ctr = (AGDocumentViewController *)_controller;
        [ctr refreshWithSeleted];
    }
}


- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController;
{
  
    _controller = viewController;
    if ([viewController isKindOfClass:[AGPlayerViewController class]]) {
        AGPlayerViewController *ctr = (AGPlayerViewController *)viewController;
        [ctr refreshWithSeleted];
    }
    else if ([viewController isKindOfClass:[AGDocumentViewController class]])
    {
        AGDocumentViewController *ctr = (AGDocumentViewController *)viewController;
        [ctr refreshWithSeleted];
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
