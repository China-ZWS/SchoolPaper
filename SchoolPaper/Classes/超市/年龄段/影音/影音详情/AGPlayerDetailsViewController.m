//
//  AGPlayerDetailsViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-9.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AGPlayerDetailsViewController.h"
#import "MoviePlayerViewController.h"
#import "AppDelegate.h"

@interface AGPlayerDetailsViewController ()
{
}
@end

@implementation AGPlayerDetailsViewController

- (id)initWithViewControllers:(NSArray *)viewControllers datas:(NSDictionary *)datas
{
    if ((self = [super initWithViewControllers:viewControllers datas:datas]))
    {
        
    }
    return self;
}

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
        CGFloat useCountMinY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *3 - ScaleH(20) - ScaleH(15)) / 2;
        _useCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), useCountMinY, DeviceW - CGRectGetMaxX(_headerImageView.frame) - ScaleW(10) - CGRectGetMinX(_headerImageView.frame), Font(15).lineHeight)];
        _useCount.textColor = CustomBlack;
        _useCount.font = Font(15);
    }
    
    NSString *type = _datas[@"type"];
    
    if ([type isEqualToString:@"AUDIO"])
    {
        _useCount.text = [[_datas[@"useCount"] stringValue] stringByAppendingString:@" 人收听"];
    }
    else if ([type isEqualToString:@"VIDEO"])
    {
        _useCount.text = [[_datas[@"useCount"] stringValue] stringByAppendingString:@" 人观看"];
    }
    return _useCount;
}

- (UILabel *)status
{
    if (!_status)
    {
        _status = [UILabel new];
        CGFloat statusMinY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *3 - ScaleH(20) - ScaleH(15)) / 2 + Font(15).lineHeight + ScaleH(5);
        _status = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), statusMinY, DeviceW - CGRectGetMaxX(_headerImageView.frame) - ScaleW(10) - CGRectGetMinX(_headerImageView.frame), Font(15).lineHeight)];
        _status.textColor = CustomBlack;
        _status.font = Font(15);
    }
    _status.text = [Base64 textFromBase64String:_datas[@"status"]];
    return _status;
}

- (UILabel *)source
{
    if (!_source)
    {
        _source = [UILabel new];
        CGFloat sourceMinY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *3 - ScaleH(20) - ScaleH(15)) / 2 + (Font(15).lineHeight + ScaleH(5)) * 2;
        _source = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), sourceMinY, DeviceW - CGRectGetMaxX(_headerImageView.frame) - ScaleW(10) - CGRectGetMinX(_headerImageView.frame), Font(15).lineHeight)];
        _source.textColor = CustomBlack;
        _source.font = Font(15);
    }
    
    _source.text = [@"来源：" stringByAppendingString:[Base64 textFromBase64String:_datas[@"source"]]];
    return _source;
}

- (StarRateView *)rate
{
    if (!_rate) {
        CGFloat _rateMinY = CGRectGetMinY(_headerImageView.frame) + (CGRectGetHeight(_headerImageView.frame) - Font(15).lineHeight *3 - ScaleH(20) - ScaleH(15)) / 2 + (Font(15).lineHeight + ScaleH(5)) * 3;
        _rate = [[StarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + ScaleW(10), _rateMinY, ScaleW(120), ScaleH(20)) starCount:5];
        _rate.allowUserInteraction = NO;
    }
    _rate.percentage = [_datas[@"score"] floatValue] / 5;
    return _rate;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.headerImageView];
    [self.view addSubview:self.useCount];
    [self.view addSubview:self.status];
    [self.view addSubview:self.source];
    [self.view addSubview:self.rate];
}

- (void)lodingDatas:(NSDictionary *)datas;
{
    _datas = datas;
    
    [self headerImageView];
    [self useCount];
    [self status];
    [self source];
    [self rate];
    [super lodingDatas:datas];
}

- (void)eventWithStatus
{
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app->_networkStatus == ReachableViaWWAN)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前3G网络" message:@"请切换到WIFI环境下观看" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    MoviePlayerViewController *player = [[MoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[Base64 textFromBase64String:_datas[@"resourceUri"]]]];
    [self presentMoviePlayerViewControllerAnimated: player];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
