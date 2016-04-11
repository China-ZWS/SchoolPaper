//
//  NewsDetailViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-3.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()
<UIWebViewDelegate>
{
    id _datas;
    NSDictionary *_dic;
    UILabel * _newsTitle;
    UILabel *_newPub;
    UILabel *_newTime;
    UIWebView *_webView;
}

@property (nonatomic) UIView *webBrowserView;
@end

@implementation NewsDetailViewController



- (void)back
{
    [self popViewController];
}


- (id)initWithDatas:(id)datas;
{
    if ((self = [super init])) {
        _datas = datas;
        [self.navigationItem setNewTitle:@"教育资讯详情"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    _newsTitle = [UILabel new];
    _newsTitle.numberOfLines = 0;
    _newsTitle.font = FontBold(30);
    _newsTitle.textColor = RGBA(80, 80, 80, 1);
    [_webView.scrollView addSubview:_newsTitle];
    
    _newPub = [UILabel new];
    _newPub.numberOfLines = 0;
    _newPub.font = Font(22);
    _newPub.textColor = CustomGray;
    [_webView.scrollView addSubview:_newPub];
    
    _newTime = [UILabel new];
    _newTime.numberOfLines = 0;
    _newTime.font = Font(22);
    _newTime.textColor = CustomGray;
    [_webView.scrollView addSubview:_newTime];
}


- (void)layoutViews
{
    NSString *newsTitle = _dic[@"newsTitle"];
    NSString *newPub = _dic[@"newPub"];
    NSString *newTime = _dic[@"newTime"];
    NSString *content = _dic[@"newsContent"];
    
    CGSize newsTitleSize = [NSObject getSizeWithText:newsTitle font:_newsTitle.font maxSize:CGSizeMake(DeviceW, MAXFLOAT)];
    CGSize newPubSize = [NSObject getSizeWithText:newPub font:_newPub.font maxSize:CGSizeMake(DeviceW, MAXFLOAT)];
    CGSize newTimeSize = [NSObject getSizeWithText:newTime font:_newPub.font maxSize:CGSizeMake(DeviceW, MAXFLOAT)];
    _newsTitle.frame = CGRectMake((DeviceW - newsTitleSize.width) / 2, ScaleH(5), newsTitleSize.width, newsTitleSize.height);
    _newsTitle.text = newsTitle;
    
    _newPub.frame = CGRectMake(ScaleX(10), CGRectGetMaxY(_newsTitle.frame) + ScaleH(5), newPubSize.width, newPubSize.height);
    _newPub.text = newPub;
    
    if ((newPubSize.width + newTimeSize.width + ScaleW(10) * 2) > DeviceW) {
        _newTime.frame = CGRectMake(ScaleX(10), CGRectGetMaxY(_newPub.frame) + ScaleH(5), newTimeSize.width, newTimeSize.height);
    }
    else
    {
        _newTime.frame = CGRectMake(CGRectGetMaxX(_newPub.frame) + ScaleW(10) * 2, CGRectGetMaxY(_newsTitle.frame) + ScaleH(5), newTimeSize.width, newTimeSize.height);
        _newTime.text = newTime;
    }
    
    UIView *webBrowserView = [self webBrowserView];
    CGRect frame = webBrowserView.frame;
    frame.origin.y = CGRectGetMaxY(_newTime.frame);
    webBrowserView.frame = frame;
    [_webView loadHTMLString:content baseURL:nil];
}

- (void)setUpDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"newId"] =  _datas;
    _connection = [BaseModel POST:newServlet parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                      _dic = data[@"data"];
                       [self layoutViews];
                       if (!_dic.count)
                       {
                           [AbnormalView setRect:_webView.frame toView:_webView abnormalType:NotDatas];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:_webView];
                       }
                       
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_dic.count)
                           {
                               [AbnormalView setRect:_webView.bounds toView:_webView abnormalType:NotNetWork];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_webView];
                           }
                       }
                       else
                       {
                           if (!_dic.count)
                           {
                               [AbnormalView setRect:_webView.frame toView:_webView abnormalType:NotDatas];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_webView];
                           }
                       }
                   }];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    _webView.opaque = YES;
    _webView.backgroundColor = [UIColor whiteColor];
}

- (UIView *)webBrowserView
{
    return  _webView.scrollView.subviews[0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        return NO;
    }
    return YES;
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
