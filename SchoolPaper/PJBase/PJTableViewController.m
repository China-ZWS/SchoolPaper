//
//  PJTableViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJTableViewController.h"
#import "PJNavigationBar.h"

@interface PJTableViewController ()

@end

@implementation PJTableViewController

- (id)initWithTableViewStyle:(UITableViewStyle)style;
{
    if ((self = [super initWithTableViewStyle:style parameters:nil])) {
        
    }
    return self;
}
- (void)addHeader;
{

}

- (void)addFooter;
{

}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(249, 249, 249, 1);
}

- (void)addNavigationWithPresentViewController:(UIViewController *)viewcontroller;
{
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
     nav.viewControllers = @[viewcontroller];
    [self presentViewController:nav];
}

- (void)reguser
{
    
}

- (void)back
{
    [self dismissViewController];
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
