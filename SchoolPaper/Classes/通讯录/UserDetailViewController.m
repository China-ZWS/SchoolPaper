//
//  UserDetailViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-22.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "UserDetailViewController.h"
#import "PJCell.h"
#import "ChatListViewController.h"

@interface UserDetailCell :PJCell
{
    NSIndexPath *_indexPath;
    NSString *_type;
}

@end

@implementation UserDetailCell



- (void)drawRect:(CGRect)rect
{
    
    UIEdgeInsets inset = UIEdgeInsetsMake(ScaleX(8), ScaleY(10), ScaleW(8), ScaleH(10));
    
    
    if (_indexPath.row == 0)
    {
        
        [self drawCellWithRound:rect cellStyle:kUpCell inset:inset radius:ScaleW(5) lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, .5);
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGFloat lengths[] = {5,10};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextMoveToPoint(context, 10, CGRectGetHeight(rect)  - .3);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect) - 10,CGRectGetHeight(rect)  - .3);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    else if (_indexPath.row == 1)
    {
        [self drawCellWithRound:rect cellStyle:kCenterCell inset:inset radius:ScaleW(5) lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, .5);
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGFloat lengths[] = {5,10};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextMoveToPoint(context, 10, CGRectGetHeight(rect)  - .3);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect) - 10,CGRectGetHeight(rect)  - .3);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    else
    {
        [self drawCellWithRound:rect cellStyle:kDownCell inset:inset radius:ScaleW(5) lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];

    }

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    UIEdgeInsets inset = UIEdgeInsetsMake(ScaleX(8), ScaleY(10), ScaleW(8), ScaleH(10));

    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(inset.left + ScaleW(15), inset.top + (ScaleH(78) - inset.top - ScaleH(60)) / 2, ScaleW(60), ScaleH(60))];
        [self.contentView addSubview:_headImageView];
        
        _textLb = [UILabel new];
        _textLb.font = Font(17);
        _textLb.textColor = CustomGray;
        [self.contentView addSubview:_textLb];
        
        _title = [UILabel new];
        _title.font = Font(17);
        _title.numberOfLines = 0;
        _title.textColor = CustomBlue;
        [self.contentView addSubview:_title];

    }
    return self;
}

- (void)setDatas:(id)datas indexPath:(NSIndexPath *)indexPath type:(NSString *)type
{
    UIEdgeInsets inset = UIEdgeInsetsMake(ScaleX(8), ScaleY(10), ScaleW(8), ScaleH(10));

    _indexPath = indexPath;
    _datas = datas;
    _type = type;
    
    NSString *title1 = @"手机号码：";
    NSString *title2 = @"个性签名：";
    NSString *name = nil;
    NSString *phoneNum = nil;
    NSString *autograph = nil;
    
    if ([_type isEqualToString:kTeachers]) {
        name = [Base64 textFromBase64String:_datas[@"tacName"]];
        phoneNum = [_datas[@"teacPhone"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        autograph = [Base64 textFromBase64String:_datas[@"autograph"]];
    }
    else
    {
        name = [Base64 textFromBase64String:_datas[@"stuName"]];
        phoneNum = [_datas[@"stuPhone"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        autograph = [Base64 textFromBase64String:_datas[@"autograph"]];
    }
    
    CGSize title1Size = [NSObject getSizeWithText:title1 font:Font(17) maxSize:CGSizeMake(100, 20)];
    CGSize title2Size = [NSObject getSizeWithText:title2 font:Font(17) maxSize:CGSizeMake(100, 20)];
    CGSize nameSize = [NSObject getSizeWithText:name font:FontBold(20) maxSize:CGSizeMake(100, 20)];
    CGSize phoneNumSize = [NSObject getSizeWithText:phoneNum font:Font(17) maxSize:CGSizeMake(DeviceW - inset.left - ScaleW(15) - inset.left - inset.right - title1Size.width, 20)];
    CGSize autographSize = [NSObject getSizeWithText:autograph font:Font(17) maxSize:CGSizeMake(DeviceW - inset.left - ScaleW(15) - inset.left - inset.right - title2Size.width, MAXFLOAT)];
    
    if (indexPath.row == 0)
    {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:_datas[@"topImg"] ]] placeholderImage:[UIImage imageNamed:@"icon_head.png"]];
        
        
        _title.frame = CGRectMake(inset.left + ScaleW(15) * 2 + CGRectGetWidth(_headImageView.frame), inset.top + (ScaleH(70) - inset.top - nameSize.height) / 2, nameSize.width, nameSize.height);
        _title.font = FontBold(20);
        _title.text = name;
        
        _headImageView.hidden = NO;
        _textLb.hidden = YES;

    }
    else if (indexPath.row == 1)
    {
        _textLb.frame = CGRectMake(inset.left + ScaleW(15), (ScaleW(60) - title1Size.height) / 2, title1Size.width, title1Size.height);
        _textLb.text = title1;
        
         _title.frame = CGRectMake(CGRectGetMaxX(_textLb.frame), CGRectGetMinY(_textLb.frame), phoneNumSize.width, phoneNumSize.height);
        
        _title.text = phoneNum;
        _headImageView.hidden = YES;
        _textLb.hidden = NO;
    }
    else
    {
        if (autographSize.height < ScaleW(60))
        {
            _textLb.frame = CGRectMake(inset.left + ScaleW(15), (ScaleW(68) - inset.bottom - title2Size.height) / 2, title2Size.width, title2Size.height);
            _title.frame = CGRectMake(CGRectGetMaxX(_textLb.frame), CGRectGetMinY(_textLb.frame), autographSize.width, autographSize.height);

        }
        else
        {
            _textLb.frame = CGRectMake(inset.left + ScaleW(15), ScaleH(10), title2Size.width, title2Size.height);
            _title.frame = CGRectMake(CGRectGetMaxX(_textLb.frame), CGRectGetMinY(_textLb.frame), autographSize.width, autographSize.height);
        }
        
        _textLb.text = title2;

        _title.text = autograph;
        _headImageView.hidden = YES;
        _textLb.hidden = NO;

    }

    [self setNeedsDisplay];
}

@end

@interface UserDetailViewController ()
{
    NSDictionary *_datas;
    NSString *_type;
    UIWebView * _callWebview;
}
@end

@implementation UserDetailViewController

- (id)initWithDatas:(id)datas type:(NSString *)type;
{
    if ((self = [super init]))
    {
        _datas = datas;
        _type = type;
        [self.navigationItem setNewTitle:@"详细资料"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sendMsg.frame = CGRectMake(ScaleX(10), DeviceH - ScaleH(50) - ScaleH(15), DeviceW - ScaleW(10) * 2, ScaleH(50));
    [sendMsg setTitle:@"发送消息" forState:UIControlStateNormal];
    sendMsg.titleLabel.font = Font(20);
    sendMsg.backgroundColor = CustomBlue;
    [sendMsg getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [sendMsg addTarget:self action:@selector(eventWithSend) forControlEvents:UIControlEventTouchUpInside];
    sendMsg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_table addSubview:sendMsg];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return ScaleH(78);
    }
    else if (indexPath.row == 1)
    {
        return ScaleH(60);
    }
    else
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UserDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UserDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setDatas:_datas indexPath:indexPath type:_type];

    if (indexPath.row == 2)
    {
        CGRect rect = cell.frame;
        if (CGRectGetHeight(cell.title.frame) > ScaleH(60))
        {
            rect.size.height = CGRectGetMaxY(cell.title.frame) + ScaleH(10) + ScaleH(8);
        }
        else
        {
            rect.size.height = ScaleH(68);
        }
        cell.frame = rect;
    }
    return cell;
}


#pragma mark - 拨打电话
- (void)eventWithCall
{
    NSString *phoneNum = nil;
    if ([_type isEqualToString:kTeachers]) {
        phoneNum = _datas[@"teacPhone"];
    }
    else
    {
        phoneNum = _datas[@"stuPhone"];
    }

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
    if (!_callWebview) {
        _callWebview = [[UIWebView alloc] init];
        [self.view addSubview:_callWebview];
    }
    [_callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];

}

#pragma mark - 发送消息
- (void)eventWithSend
{
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    if ([_type isEqualToString:kTeachers]) {
        datas[@"user_name"] = [Base64 textFromBase64String:_datas[@"tacName"]] ;
        datas[@"mobile"] = _datas[@"teacPhone"];
        datas[@"key_id"] = [datas[@"mobile"] stringByAppendingString:datas[@"user_name"]];
        datas[@"user_id"] = [[Base64 textFromBase64String:[Infomation readInfo][@"mobileTag"]] stringByAppendingString:[Base64 textFromBase64String:[Infomation readInfo][@"name"]]];
        datas[@"create_id"] = datas[@"user_id"];
    }
    else
    {
        datas[@"user_name"] = [[Base64 textFromBase64String:_datas[@"stuName"]] stringByReplacingOccurrencesOfString:@"家长" withString:@""];
        datas[@"mobile"] = _datas[@"stuPhone"];
        datas[@"key_id"] = [datas[@"mobile"] stringByAppendingString:datas[@"user_name"]];
        datas[@"user_id"] = [[Base64 textFromBase64String:[Infomation readInfo][@"mobileTag"]] stringByAppendingString:[Base64 textFromBase64String:[Infomation readInfo][@"name"]]];
        datas[@"create_id"] = datas[@"user_id"];
    }
    
    [self addNavigationWithPresentViewController:[[ChatListViewController alloc] initWithName:datas chatType:kMessage]];
}


- (void)didReceiveMemoryWarning
{
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
