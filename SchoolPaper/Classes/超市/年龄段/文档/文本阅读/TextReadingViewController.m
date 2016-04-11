
//
//  TextReadingViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-16.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "TextReadingViewController.h"

@interface TextReadingViewController ()
{
    UIWebView *_webView;
    NSInteger _currentPage;
    NSArray *_datas;
}
@end

@implementation TextReadingViewController

- (id)init
{
   
    if ((self = [super init])) {
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        _currentPage = 0;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}


#pragma mark - 信息灌入
- (void)setInformation:(id)information
{
    _information = information;
    _datas = [[_information[@"chapters"] reverseObjectEnumerator] allObjects];
    [self.navigationItem setNewTitle:[Base64 textFromBase64String:information[@"name"]]];
    

}


- (void)loadView
{
    [super loadView];
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"上一章" style:UIBarButtonItemStylePlain target:self action:@selector(pre)];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"下一章" style:UIBarButtonItemStylePlain target:self action:@selector(next)];

    [self setToolbarItems:@[centerSpace,lefttem, centerSpace, right,centerSpace]];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor whiteColor];
    BOOL isManychapter = [_information[@"isManychapter"] boolValue];
    if (isManychapter) {
        [_webView loadHTMLString:[Base64 textFromBase64String:_datas[_currentPage][@"chapterContent"]] baseURL:nil];
    }
    else
    {
        [_webView loadHTMLString:[Base64 textFromBase64String:_information[@"content"]] baseURL:nil];
    }
    [self.view addSubview:_webView];
    // Do any additional setup after loading the view.
}

- (void)pre
{
    
    BOOL isManychapter = [_information[@"isManychapter"] boolValue];
    
    if (!isManychapter || !_currentPage)
    {
        [self.view makeToast:@"没有上一章了" duration:.5 position:@"center"];
        return;
    }
    
    [_webView loadHTMLString:[Base64 textFromBase64String:_datas[--_currentPage][@"chapterContent"]] baseURL:nil];
}

- (void)next
{
    BOOL isManychapter = [_information[@"isManychapter"] boolValue];
    if (!isManychapter || _currentPage == _datas.count - 1)
    {
        [self.view makeToast:@"没有下一章了" duration:.5 position:@"center"];
        return;
    }
    [_webView loadHTMLString:[Base64 textFromBase64String:_datas[++_currentPage ][@"chapterContent"]] baseURL:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController  setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController  setToolbarHidden:YES animated:YES];
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
