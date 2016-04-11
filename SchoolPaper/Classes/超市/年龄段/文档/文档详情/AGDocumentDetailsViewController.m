//
//  AGDocumentDetailsViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-9.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AGDocumentDetailsViewController.h"
#import "TextReadingViewController.h"

@interface AGDocumentDetailsViewController ()

@end

@implementation AGDocumentDetailsViewController

- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScaleW(20), (ScaleH(180) - ScaleW(100)) / 2, ScaleW(100), ScaleW(100))];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    NSString *viewImg = [Base64 textFromBase64String:_datas[@"viewImg"]];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:viewImg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
    return _headerImageView;
}

- (UILabel *)useCount
{
    if (!_useCount)
    {
        CGFloat useCountMinY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *5 - ScaleH(20) - ScaleH(25)) / 2;
        _useCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), useCountMinY, DeviceW - CGRectGetMaxX(_headerImageView.frame) - ScaleW(10) - CGRectGetMinX(_headerImageView.frame), Font(15).lineHeight)];
        _useCount.backgroundColor = [UIColor clearColor];
        _useCount.textColor = CustomBlack;
        _useCount.font = Font(15);
        _useCount.textColor = CustomBlack;
    }
    
    _useCount.text = [[_datas[@"useCount"] stringValue] stringByAppendingString:@" 人阅读"];
    
    return _useCount;
}

- (UILabel *)status
{
    if (!_status) {
        CGFloat catalogueY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *5 - ScaleH(20) - ScaleH(25)) / 2 + Font(15).lineHeight  + ScaleH(5);
        _status = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), catalogueY, DeviceW - CGRectGetMaxX(_headerImageView.frame) - ScaleW(10) - CGRectGetMinX(_headerImageView.frame), Font(15).lineHeight)];
        _status.font = Font(15);
        _status.textColor = CustomBlack;
    }
    _status.text = [Base64 textFromBase64String:_datas[@"status"]];
    return _status;
}


- (UILabel *)source
{
    if (!_source)
    {
        _source = [UILabel new];
        CGFloat sourceMinY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *5 - ScaleH(20) - ScaleH(25)) / 2 + (Font(15).lineHeight  + ScaleH(5)) * 2;
        _source = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), sourceMinY, DeviceW - CGRectGetMaxX(_headerImageView.frame) - ScaleW(10) - CGRectGetMinX(_headerImageView.frame), Font(15).lineHeight)];
        _source.textColor = CustomBlack;
        _source.font = Font(15);
        _source.textColor = CustomBlack;
    }
    
    _source.text = [@"来源：" stringByAppendingString:[Base64 textFromBase64String:_datas[@"source"]]];
    return _source;
}


- (UILabel *)author
{
    if (!_author)
    {
        CGFloat authorY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *5 - ScaleH(20) - ScaleH(25)) / 2 + (Font(15).lineHeight  + ScaleH(5)) * 3;
        _author = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), authorY, DeviceW - CGRectGetMaxX(_headerImageView.frame) - ScaleW(10) - CGRectGetMinX(_headerImageView.frame), Font(15).lineHeight)];
        _author.font = Font(15);
        _author.textColor = CustomBlack;
    }
    _author.text = [@"作者：" stringByAppendingString:[Base64 textFromBase64String:_datas[@"author"]]];
    return _author;
}

- (UILabel *)wordCount
{
    if (!_wordCount) {
        CGFloat wordCountY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *5 - ScaleH(20) - ScaleH(25)) / 2 + (Font(15).lineHeight  + ScaleH(5)) * 4;
        _wordCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), wordCountY, DeviceW - CGRectGetMaxX(_headerImageView.frame) - ScaleW(10) - CGRectGetMinX(_headerImageView.frame), Font(15).lineHeight)];
        _wordCount.font = Font(15);
        _wordCount.textColor = CustomBlack;
    }
    _wordCount.text = [@"字数：" stringByAppendingString:[Base64 textFromBase64String:_datas[@"wordCount"]]];
    return _wordCount;
}

- (StarRateView *)rate
{
    if (!_rate) {
        CGFloat _rateMinY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *5 - ScaleH(20) - ScaleH(25)) / 2 + (Font(15).lineHeight + ScaleH(5)) * 5;
        _rate = [[StarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), _rateMinY, ScaleW(120), ScaleH(20)) starCount:5];
        _rate.allowUserInteraction = NO;
    }
    _rate.percentage = [_datas[@"score"] floatValue] / 5;
    return _rate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headerImageView];
    [self.view addSubview:self.useCount];
    [self.view addSubview:self.status];
    [self.view addSubview:self.source];
    [self.view addSubview:self.author];
    [self.view addSubview:self.wordCount];
    [self.view addSubview:self.rate];
    // Do any additional setup after loading the view.
}

- (void)lodingDatas:(NSDictionary *)datas;
{
    _datas = datas;
    [self headerImageView];
    [self useCount];
    [self status];
    [self source];
    [self author];
    [self wordCount];
    [self rate];
    [super lodingDatas:datas];
}


- (void)eventWithStatus
{
    TextReadingViewController *ctr = [[TextReadingViewController alloc] init];
    ctr.information = _datas;
    [self pushViewController:ctr];
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
