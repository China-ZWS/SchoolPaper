//
//  BusinessDetailViewController.m
//  SchoolPaper
//
//  Created by 周文松 on 15/10/20.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "PJCell.h"
#import "PJTableView.h"
@interface BCell : PJCell

@end

@implementation BCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.textLabel.font = Font(17);
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = CustomBlack;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setDatas:(id)datas
{
    self.imageView.image = [UIImage imageNamed:datas[@"image"]];
    self.textLabel.text = datas[@"title"];
    NSLog(@"1111 %@",datas[@"title"]);
}

@end


@interface BusinessDetailViewController ()
<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
{
}
@property (nonatomic, strong) UITableView *headerView;
@property (nonatomic, strong) UIWebView *content;
@property (nonatomic) NSArray *cellDatas;
@end

@implementation BusinessDetailViewController

- (id)init
{
    if ((self = [super init])) {
        self.title = @"商品详情";
    }
    return self;
}

- (UITableView *)headerView
{
    if (!_headerView) {
        _headerView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(120)) style:UITableViewStylePlain];
        _headerView.delegate = self;
        _headerView.dataSource = self;
    }
    return _headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _cellDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    BCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.datas = _cellDatas[indexPath.row];
    return cell;
}

- (void)setDatas:(id)datas
{
    
    if (!datas || _datas) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _datas = datas;
        self.cellDatas = @[@{@"title":__TEXT(datas[@"seller"][@"address"]),@"image":@"icon_address.png"},@{@"title":__TEXT(datas[@"seller"][@"telphone"]),@"image":@"ss"}];
        [_headerView reloadData];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:__TEXT(datas[@"seller"][@"htmlPath"])]];
        [_content loadRequest:request];
    });
}

- (UIWebView *)content
{
    if (!_content) {
        _content = [UIWebView new];
        _content.delegate = self;
    }
    return _content;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _content.hidden = NO;
    CGRect rect = _content.frame;
    rect.origin = CGPointMake(0, CGRectGetMaxY(_headerView.frame));
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



- (void)loadView
{
    [super loadView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.content];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
