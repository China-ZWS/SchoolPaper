//
//  ActivityDetailsViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/24.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ActivityDetailsViewController.h"

@interface ADHeaderView : UIView
@property (nonatomic, strong) NSDictionary *datas;
@end

@implementation ADHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    
    if (!_datas)return;
 
    [self drawCellWithRound:rect cellStyle:kRoundCell inset:kDefaultInset radius:3 lineWidth:.5 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
    
    NSString *name = [Base64 textFromBase64String:_datas[@"name"]];
    CGSize nameSize = [NSObject getSizeWithText:name font:FontBold(17) maxSize:CGSizeMake(DeviceW - kDefaultInset.right * 5 - ScaleW(60), FontBold(17).lineHeight * 2)];
    CGFloat allHeight = nameSize.height + kDefaultInset.top * 2 + Font(15).lineHeight;
    [self drawTextWithText:name rect:CGRectMake(kDefaultInset.right * 2, (ScaleH(110) - allHeight) / 2, nameSize.width, nameSize.height) color:[UIColor blackColor] font:FontBold(17)];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:_datas[@"enrollEndate"]];
    NSString *enrollEndate = [NSObject compareCurrentTimeToPastTime:date];
    
    [self drawTextWithText:[@"截止日期:" stringByAppendingString:enrollEndate] rect:CGRectMake(kDefaultInset.left * 2, (ScaleH(110) - allHeight) / 2 + nameSize.height + kDefaultInset.top * 2, DeviceW - kDefaultInset.right * 5 - ScaleW(60), Font(15).lineHeight) color:CustomBlack font:Font(15)];

}

- (void)setDatas:(NSDictionary *)datas
{
    _datas = datas;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DeviceW - kDefaultInset.right * 2 - ScaleW(60), (ScaleH(110) - ScaleH(60)) / 2, ScaleW(60), ScaleH(60));
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = Font(17);
    btn.layer.cornerRadius = ScaleH(30);
    btn.layer.masksToBounds =YES;
    BOOL isEnroll = [datas[@"isEnroll"] boolValue];
     if (isEnroll) {
        [btn setTitle:@"已报" forState:UIControlStateNormal];
        btn.backgroundColor = CustomGray;
        btn.enabled = NO;
    }
    else
    {
        [btn setTitle:@"报" forState:UIControlStateNormal];
        btn.backgroundColor = CustomBlue;
        btn.enabled = YES;
    }

//    [self addSubview:btn]; //县毙掉
}


@end


@interface ADContentView : UIView
{
    UIWebView *_webView;
}
@property (nonatomic, strong) id datas;
@end

@implementation ADContentView

- (void)drawRect:(CGRect)rect
{
    if (!_datas)return;
    
    [self drawCellWithRound:rect cellStyle:kRoundCell inset:kDefaultInset radius:3 lineWidth:.5 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
    [self drawRectWithLine:rect start:CGPointMake(kDefaultInset.left, kDefaultInset.top + ScaleH(44)) end:CGPointMake(DeviceW - kDefaultInset.right, kDefaultInset.top + ScaleH(44)) lineColor:CustomGray lineWidth:.5];
    [self drawTextWithText:@"活动详情" rect:CGRectMake(kDefaultInset.left * 2,kDefaultInset.top + (ScaleH(44) - Font(15).lineHeight) / 2,100,Font(15).lineHeight) color:CustomBlack font:Font(15)];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
//    NSString *html = [Base64 textFromBase64String:datas[@"htmlPath"]];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(kDefaultInset.left, kDefaultInset.top + ScaleH(45), DeviceW - kDefaultInset.left * 2, CGRectGetHeight(self.frame) - kDefaultInset.top * 2 - ScaleH(45))];
    _webView.backgroundColor = [UIColor clearColor];
    [self addSubview:_webView];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_webView setOpaque:NO];
    [_webView scalesPageToFit];
}

- (void)setDatas:(NSDictionary *)datas
{
    _datas = datas;
    NSString *html = [Base64 textFromBase64String:datas[@"htmlPath"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:html]];
    [_webView loadRequest:request];
}

@end


@interface ActivityDetailsViewController ()

@property (nonatomic, strong) id datas;

@end

@implementation ActivityDetailsViewController

- (id)initWithDatas:(id)datas;
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"活动专区"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
        _datas = datas;
    }
    return self;
}


- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ADHeaderView *headerView = [[ADHeaderView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(110))];
    headerView.datas = _datas;
    [self.view addSubview:headerView];

    ADContentView *content = [[ADContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), DeviceW, CGRectGetHeight(self.view.frame) - CGRectGetHeight(headerView.frame))];
    content.datas = _datas;
    [self.view addSubview:content];

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
