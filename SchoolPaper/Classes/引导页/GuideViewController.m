//
//  GuideViewController.m
//  SchoolPaper
//
//  Created by 周文松 on 15/10/30.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()
<UIScrollViewDelegate>
{
    void(^_success)();
}
@end

@implementation GuideViewController
- (id)initWithSuccess:(void(^)())success;
{
    if ((self = [super init])) {
        _success = success;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(4 * DeviceW, DeviceH);
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < 4; i ++)
    {       
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *DeviceW, 0, DeviceW, DeviceH)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d.png",i + 1]];
        [scrollView addSubview:imageView];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, DeviceH - ScaleH(50) -  Font(16).lineHeight, DeviceW, Font(16).lineHeight);
    btn.titleLabel.font = Font(16);
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"暂不激活，点击进入"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSForegroundColorAttributeName
                            value:RGBA(75, 153, 116, 1) // 更改颜色
                            range:contentRange];
    [btn setAttributedTitle:content forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(zhou) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    BOOL has = [self APCheckIfAppInstalled2:@"My1Lottery://"];
    if (has) {
        return;
    }
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"select.png"];
    UIImage *sb = [UIImage imageNamed:@"selected.png"];
    btn2.frame = CGRectMake((DeviceW - img.size.width) / 2, CGRectGetMinY(btn.frame) - 20 - img.size.height, img.size.width, img.size.height);
    [btn2 setBackgroundImage:img forState:UIControlStateNormal];
    [btn2 setBackgroundImage:sb forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(wen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.contentOffset.x > DeviceW * 3) {
        _success();
    }
}

- (void)zhou
{
    
    _success();
}

- (void)wen
{
    BOOL has = [self APCheckIfAppInstalled2:@"My1Lottery://"];
    if (!has) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-yuan-jia-jia-zhang-xiao/id834172741?mt=8"]];
    }
}

-(BOOL) APCheckIfAppInstalled2:(NSString *)urlSchemes
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlSchemes]];
}

@end
