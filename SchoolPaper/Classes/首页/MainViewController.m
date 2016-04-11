//
//  MainViewController.m
//  SchoolPaper
//
//  Created by 周文松 on 15/9/24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "MainViewController.h"
#import "DataConfigManager.h"
#import "PJCell.h"

@interface HSMsgCell : PJCell
@property (nonatomic, strong) UILabel *time;
@end
@implementation HSMsgCell
- (void)drawRect:(CGRect)rect
{
    
    [self drawCellWithRound:rect cellStyle:kRoundCell inset:kDefaultInset radius:ScaleH(5) lineWidth:.5 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat lengths[] = {5,10};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, ScaleX(70), CGRectGetHeight(rect) / 2 - .5);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - 10,CGRectGetHeight(rect) / 2 - .5);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _headImageView = [UIImageView new];
        _name = [UILabel new];
        _name.font = Font(17);
        _name.textColor = CustomBlue;
        
        _title = [UILabel new];
        _title.font = Font(19);
        _title.textColor = CustomBlue;
        
        _contentLb = [UILabel new];
        _contentLb.font = Font(17);
        _contentLb.textColor = CustomGray;
        
        _time = [UILabel new];
        _time.font = Font(15);
        _time.textColor = CustomGray;

        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_contentLb];
        [self.contentView addSubview:_time];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize nameSize = [NSObject getSizeWithText:_name.text font:_name.font maxSize:CGSizeMake(100, 100)];
    CGSize timeSize = [NSObject getSizeWithText:_time.text font:_time.font maxSize:CGSizeMake(200, _time.font.lineHeight)];
    CGSize titleSize = [NSObject getSizeWithText:_title.text font:_title.font maxSize:CGSizeMake(DeviceW - ScaleW(15) * 2 - ScaleW(10) - _headImageView.image.size.width, 20)];
    
    CGFloat inset = ScaleH(10);
    CGFloat imageY = (ScaleH(120) - (_headImageView.image.size.height + nameSize.height + inset)) / 2;
    
    _headImageView.frame = CGRectMake(ScaleX(15) + ScaleX(10), imageY, _headImageView.image.size.width, _headImageView.image.size.height);

    _name.frame = CGRectMake(CGRectGetMinX(_headImageView.frame) + (_headImageView.image.size.width - nameSize.width) / 2, CGRectGetMaxY(_headImageView.frame) + inset,nameSize.width, nameSize.height);
    
    
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleX(15), ScaleH(120) / 2 - titleSize.height - ScaleH(5), titleSize.width, titleSize.height);

    _time.frame = CGRectMake(DeviceW - timeSize.width - ScaleW(15) * 2, CGRectGetMinY(_title.frame), timeSize.width, timeSize.height);

    _contentLb.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleX(15), ScaleH(120) / 2 + ScaleH(5), DeviceW - ScaleW(15) * 2 - ScaleW(10) * 2 - _headImageView.image.size.width, ScaleH(20) );
}

- (void)setDatas:(id)datas
{
  
    UIImage *image = [UIImage imageNamed:datas[@"image"]];
    NSString *name = datas[@"name"];
    NSString *title = [datas[@"title"] length]?datas[@"title"]:datas[@"name"];
    NSString *content = datas[@"content"];
    if (datas[@"date"] && [datas[@"date"] length]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:datas[@"date"]];
        NSString *time = [NSObject compareCurrentTimeToPastTime:date];
        _time.text = time;
    }
    
    _headImageView.image = image;
    _name.text = name;
    _title.text = title;
    
    _contentLb.text = content;
}

@end

#import "BaseCollectionViewCell.h"
@interface MainItem : BaseCollectionViewCell

@end

@implementation MainItem

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        _imageView = [UIImageView new];
        _title = [UILabel new];
        _title.font = NFont(15);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = CustomBlue;
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_title];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(kDefaultInset.left * 3, kDefaultInset.top, CGRectGetWidth(self.frame) - kDefaultInset.left * 6, CGRectGetWidth(self.frame) - kDefaultInset.left * 6);
    _title.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame) + kDefaultInset.top, CGRectGetWidth(self.frame), _title.font.lineHeight);
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    NSString *title = datas[@"title"];
    NSString *image = datas[@"image"];
    _imageView.image = [UIImage imageNamed:image];
    _title.text = title;
}


@end


#import "HSContactsViewController.h"

@interface MainViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_colleckDatas;
}
@property (nonatomic, strong) UICollectionView *toolView;
@end

@implementation MainViewController

- (UIButton *)leftItem
{
    _leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftItem.frame = CGRectMake(0, 0, 40, 40);
    [_leftItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_leftItem sd_setBackgroundImageWithURL:[NSURL URLWithString:__TEXT([Infomation readInfo][@"top_image"])] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pTop.png"]];
    return _leftItem;
}

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"主 页"];
                NSNotificationAdd(self, changeImg, @"changeImg", nil);
        [self.navigationItem setLeftItemView:self.leftItem];
        [self.navigationItem setRightItemWithTarget:self title:@"通讯录" action:@selector(addressbook) image:nil];
        _colleckDatas = [DataConfigManager getMainConfigList];
    }
    return self;
}

- (void)changeImg
{
    [_leftItem sd_setBackgroundImageWithURL:[NSURL URLWithString:__TEXT([Infomation readInfo][@"top_image"])] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
}

- (void)back
{
    [_menu touchesLeftItem];
}

- (void)addressbook
{
    [self pushViewController:[HSContactsViewController new]];
}

- (void)stateChangedForHome:(CGFloat)distance
{
    _leftItem.alpha = distance;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = DeviceW / 4;
    segmentBarLayout.itemSize = CGSizeMake(width,70);
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (UIView *)toolView
{
    _toolView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_table.frame), DeviceW, kDefaultInset.top * 3 + DeviceW - kDefaultInset.left * 6 + NFont(15).lineHeight) collectionViewLayout:[self segmentBarLayout]];
    _toolView.userInteractionEnabled = YES;
    _toolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_toolView registerClass:[MainItem class] forCellWithReuseIdentifier:@"cell"];
    _toolView.delegate = self;
    _toolView.dataSource = self;
    _toolView.backgroundColor = [UIColor whiteColor];
    return _toolView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    self.tableWithFrame = CGRectMake(0, 0, DeviceW, DeviceH - 70);
    [self.view addSubview:self.toolView];
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(120);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    HSMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HSMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.datas = _datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _datas[indexPath.row];
    Class class = NSClassFromString(dic[@"controller"]);
    [self pushViewController:[class new]];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _colleckDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MainItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datas = _colleckDatas[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _colleckDatas[indexPath.row];
    Class class = NSClassFromString(dic[@"controller"]);
    id viewController = [class new];
    [self pushViewController:viewController];
}



- (void)refreshDatas
{
    [self.view endEditing:YES];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *locationString=[dateFormatter stringFromDate:senddate];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"xcode"]];
    params[@"xxCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"schoolCode"]];
    params[@"informTime"] = locationString;
    params[@"hwTime"] = locationString;
    params[@"classNo"] = [Base64 textFromBase64String:[Infomation readInfo][@"classCode"]];
    
    _connection = [BaseModel POST:informAndXhwCountServlet parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       [_table.header endRefreshing];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       
                       //                       [self.view makeToast:msg];
                       [_table.header endRefreshing];
                   }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self hasLogin];
    _datas = [NSMutableArray arrayWithArray:[DataConfigManager getHSMsgList]];
    [self reloadTabData];
    
}

- (void)hasLogin
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([Infomation readInfo])
        {
            [self.table.header beginRefreshing];
            return;
        }
        [self gotoLogingWithSuccess:^(BOOL isSuccess)
         {
             
             if (isSuccess)
             {
                 [self.view makeToast:@"登录成功"];
                 [_leftItem sd_setBackgroundImageWithURL:[NSURL URLWithString:__TEXT([Infomation readInfo][@"top_image"])] forState:UIControlStateNormal];
                 NSNotificationPost(RefreshWithViews, nil, nil);
             }
         }
                              class:@"LoginViewController"];
        
    });

}

- (void)refreshWithViews
{
    [self.table.header beginRefreshing];
    
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
