//
//  ActivityAreaViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/24.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ActivityAreaViewController.h"

@interface ActivityAreaViewController ()

@end

@implementation ActivityAreaViewController

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    if ((self = [super initWithViewControllers:viewControllers])) {
        [self.navigationItem setNewTitle:@"活动专区"];
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
    self.lineColor = CustomBlue;
    self.titleColor = CustomBlack;
    self.selectedTitleColor = CustomBlue;
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
