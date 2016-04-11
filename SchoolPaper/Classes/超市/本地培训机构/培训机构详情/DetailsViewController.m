//
//  DetailsViewController.m
//  SchoolPaper
//
//  Created by 周文松 on 15/10/20.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "DetailsViewController.h"
#import "PJCell.h"

@interface DetailsCell : PJCell
<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation DetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _webView = [UIWebView new];
        _webView.delegate = self;
        [self.contentView addSubview:_webView];
    }
    return self;
}



- (void)setDatas:(id)datas
{
    
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:__TEXT(datas[@"htmlPath"])]];
    [_webView loadRequest:request];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect rect = _webView.frame;
    rect.origin = CGPointMake(defaultInset.left, ScaleW(30) - defaultInset.top);
    rect.size = CGSizeMake(DeviceW - defaultInset.left - defaultInset.right, 1);
    _webView.frame = rect;
    
    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",ScaleW(105)]];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
    
    CGFloat totalHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    
    rect.size.height = totalHeight;
    _webView.frame = rect;
    
    
    CGRect selfRect = self.frame;
    selfRect.size.height = CGRectGetMaxY(_webView.frame) + defaultInset.bottom ;
    self.frame = selfRect;

}

@end

@interface DetailsViewController ()
<UIWebViewDelegate>
{
    NSArray *_cellDatas;
    NSDictionary *_datas;
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UIWebView *content;
@end

@implementation DetailsViewController

- (id)init
{
    if ((self = [super init])) {
        self.title = @"本单详情";
    }
    return self;
}

- (UIView *)headerView
{
    if(_headerView)
    {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }
    _headerView = [UIView new];
    UILabel *title = [UILabel new];
    
    title.font = FontBold(17);
    title.numberOfLines = 0;
    title.textColor = [UIColor blackColor];
    [_headerView addSubview:title];
    
    UILabel *abstracts = [UILabel new];
    abstracts.font = Font(15);
    abstracts.numberOfLines = 0;
    abstracts.textColor = CustomBlack;
    [_headerView addSubview:abstracts];
    NSString *name = [Base64 textFromBase64String:_datas[@"name"]];
    CGSize nameSize = [NSObject getSizeWithText:name font:title.font maxSize:CGSizeMake(DeviceW - kDefaultInset.left * 2, MAXFLOAT)];
    title.frame = CGRectMake(kDefaultInset.right,kDefaultInset.top, nameSize.width , nameSize.height);
    title.text = name;
    
    NSString *tipContent = [Base64 textFromBase64String:_datas[@"tipContent"]];
    CGSize tipSize = [NSObject getSizeWithText:tipContent font:abstracts.font maxSize:CGSizeMake(DeviceW - kDefaultInset.left * 2, MAXFLOAT)];
    abstracts.frame = CGRectMake(CGRectGetMinX(title.frame), CGRectGetMaxY(title.frame) + kDefaultInset.top, tipSize.width, tipSize.height);
    abstracts.text = tipContent;
    _headerView.frame = CGRectMake(0, 0, DeviceW, CGRectGetMaxY(abstracts.frame) + kDefaultInset.bottom);
    return _headerView;
}


- (UILabel *)text
{
    if (!_text) {
        _text = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), DeviceW, ScaleH(30))];
        _text.font = Font(15);
        _text.textColor = CustomBlack;
        _text.backgroundColor = CustomGray;
        _text.text = @"  购买须知";
    }
    return _text;
}

- (UIWebView *)content
{
    if (!_content) {
        _content = [UIWebView new];
        _content.delegate = self;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:__TEXT(_datas[@"htmlPath"])]];
        [_content loadRequest:request];
    }
    return _content;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _content.hidden = NO;
    CGRect rect = _content.frame;
    rect.origin = CGPointMake(0, CGRectGetMaxY(_text.frame));
    rect.size = CGSizeMake(DeviceW , 1);
    _content.frame = rect;
    
    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",ScaleW(105)]];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
    
    CGFloat totalHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    
    rect.size.height = totalHeight;
    _content.frame = rect;
    _scrollView.contentSize = CGSizeMake(DeviceW, CGRectGetMaxY(_content.frame));
}



- (void)setDatas:(id)datas
{
    if (!datas || _datas) {
        return;
    }
    _datas = datas;
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.text];
    [self.scrollView addSubview:self.content];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
