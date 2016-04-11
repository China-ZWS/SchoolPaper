//
//  BaseAGDetailsViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-9.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseAGDetailsViewController.h"
#import "BaseAGTextViewController.h"
#import "BaseAGCatalogViewController.h"
#import "BaseAGCommentViewController.h"
#import "BaseAGReviewViewController.h"

@interface BaseAGDetailsViewController ()
<SideSegmentControllerDelegate>
{
    NSDictionary *_dic;
}
@property (nonatomic) UIButton *button;
@end

@implementation BaseAGDetailsViewController

- (id)initWithViewControllers:(NSArray *)viewControllers datas:(NSDictionary *)datas;
{
    if (([super initWithViewControllers:viewControllers]))
    {
        self.delegate = self;
        _dic = datas;
        [self.navigationItem setNewTitle:[Base64 textFromBase64String:datas[@"name"]]];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        [self.navigationItem setRightItemWithTarget:self title:nil action:@selector(right) image:@"icon_QA.png"];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)right
{
    [self pushViewController:[[BaseAGReviewViewController alloc] initWithDatas:_dic]];
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, DeviceW - ScaleW(40), 35);
        _button.backgroundColor = CustomBlue;
        [_button getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(3) shadowColor:CustomlightPurple shadowOpacity:.6 cornerRadius:ScaleW(3) masksToBounds:NO];
        NSString *type = _dic[@"type"];
        
        if ([type isEqualToString:@"AUDIO"])
        {
            [_button setTitle:@"收 听" forState:UIControlStateNormal];
        }
        else if ([type isEqualToString:@"VIDEO"])
        {
            [_button setTitle:@"播 放" forState:UIControlStateNormal];
        }
        else if ([type isEqualToString:@"DOCUMENT"])
        {
            [_button setTitle:@"阅 读" forState:UIControlStateNormal];
        }
        [_button addTarget:self action:@selector(eventWithStatus) forControlEvents:UIControlEventTouchUpInside];
        _button.userInteractionEnabled = NO;
        _button.alpha = .3;
    }
    
    return _button;

}

- (void)loadView
{
    [super loadView];
    
    NSMutableArray *tbitems = [NSMutableArray array];
    UIBarButtonItem *sure = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    [tbitems addObject:sure];
    
    UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, DeviceH - 44, DeviceW, 44)];
    tool.items = tbitems;
    tool.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:tool];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.segmentBarFrame = CGRectMake(CGRectGetMinX(self.segmentBar.frame), ScaleH(180), CGRectGetWidth(self.segmentBar.frame), CGRectGetHeight(self.segmentBar.frame));
    self.slideView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentBar.frame) + 1, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.segmentBar.frame) + 1 - 44);

    self.lineColor = CustomBlue;
    self.titleColor = CustomBlack;
    self.selectedTitleColor = CustomBlue;
}

- (void)setUpDatas
{

    [MBProgressHUD showMessag:Loding_text1 toView:self.view];
    
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"res_id"] = _dic[@"id"];
//    params[@"res_id"] = @"44";

    NSString *servlet = nil;
    NSString *type = _dic[@"type"];
    
    if ([type isEqualToString:@"AUDIO"])
    {
        servlet = getaudio;
    }
    else if ([type isEqualToString:@"VIDEO"])
    {
        servlet = getvideo;
    }
    else if ([type isEqualToString:@"DOCUMENT"])
    {
        servlet = getdocument;
    }
 
    _connection = [BaseModel POST:servlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       _button.userInteractionEnabled = YES;
                       _button.alpha = 1;
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [self lodingDatas:data[@"data"]];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       _button.userInteractionEnabled = NO;
                       _button.alpha = .5;
                       [self.view makeToast:msg];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];
}

- (void)lodingDatas:(NSDictionary *)datas
{
    BaseAGTextViewController *textController = nil;
    BaseAGCatalogViewController *catelogController = nil;
    for (UIViewController *viewCtr in self.viewControllers)
    {
        if ([viewCtr isKindOfClass:[BaseAGTextViewController class]])
        {
            textController = (BaseAGTextViewController *)viewCtr;
        }
        else if ([viewCtr isKindOfClass:[BaseAGCatalogViewController class]])
        {
            catelogController = (BaseAGCatalogViewController *)viewCtr;
        }
    }
    
    [textController lodingWithText:[Base64 textFromBase64String:datas[@"remark"]]];
    [catelogController lodingWithCatalog:datas[@"chapters"]];
}


- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController;
{
    if ([viewController isKindOfClass:[BaseAGCommentViewController class]])
    {
        BaseAGCommentViewController *ctr = (BaseAGCommentViewController *)viewController;
        [ctr  refreshWithSeleted];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithStatus
{
    
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
