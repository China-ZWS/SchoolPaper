//
//  AboutViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-20.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"关于我们"];
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
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[serverUrl stringByAppendingFormat:@"config/html/about.html"]]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
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
