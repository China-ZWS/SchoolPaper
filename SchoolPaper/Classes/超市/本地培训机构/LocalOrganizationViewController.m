//
//  LocalOrganizationViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/14.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "LocalOrganizationViewController.h"
#import "PJCell.h"
#import "LocalMoreViewController.h"
@interface LTCell : PJCell

@end

@implementation LTCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _title = [UILabel new];
        _title.font = FontBold(17);
        _title.numberOfLines = 0;
        _title.textColor = [UIColor blackColor];

        _abstracts = [UILabel new];
        _abstracts.font = Font(15);
        _abstracts.numberOfLines = 0;
        _abstracts.textColor = CustomBlack;
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    _headImageView.frame = CGRectMake(kDefaultInset.left * 2, kDefaultInset.top, ScaleW(90), ScaleH(90));
   
    NSString *name = [Base64 textFromBase64String:_datas[@"name"]];
    CGSize nameSize = [NSObject getSizeWithText:name font:_title.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(_headImageView.frame) - kDefaultInset.left * 2, MAXFLOAT)];
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kDefaultInset.right,CGRectGetMinY(_headImageView.frame), nameSize.width , nameSize.height);

    NSString *tipContent = [Base64 textFromBase64String:_datas[@"tipContent"]];
    CGSize tipSize = [NSObject getSizeWithText:tipContent font:_abstracts.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(_headImageView.frame) - kDefaultInset.left * 2, MAXFLOAT)];
    _abstracts.frame = CGRectMake(CGRectGetMinX(_title.frame), CGRectGetMaxY(_title.frame) + kDefaultInset.top, tipSize.width, tipSize.height);
}

- (void)setDatas:(id)datas
{
    _datas = datas;
    NSString *viewImg = [Base64 textFromBase64String:datas[@"viewImg"]];
    NSString *name = [Base64 textFromBase64String:datas[@"name"]];
    NSString *tipContent = [Base64 textFromBase64String:datas[@"tipContent"]];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:viewImg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
    _title.text = name;
    _abstracts.text = tipContent;
}

@end

@interface LocalCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation LocalCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _title.text = @"更多";
        _title.font = Font(20);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setDatas:(id)datas
{
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[Base64 textFromBase64String:datas[@"viewImg"]]] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
}


@end


#import "DetailOrganizationViewController.h"
#import "DetailsViewController.h"
#import "BusinessDetailViewController.h"
#import "OGCommentViewController.h"

@interface LocalOrganizationViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableDictionary *_datas;
    UICollectionView *_collectionView;
}
@end

@implementation LocalOrganizationViewController


- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"本地培训机构"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = DeviceW / 4;
    CGFloat height = width;
    segmentBarLayout.itemSize = CGSizeMake(width,height);
    segmentBarLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (UIView *)createHeaderView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DeviceW, DeviceW / 2) collectionViewLayout:[self segmentBarLayout]];
    _collectionView.userInteractionEnabled = YES;
//    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[LocalCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = YES;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    

    return _collectionView;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[@"sellers"] count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    LocalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    
    if (indexPath.row == [_datas[@"sellers"] count])
    {
        cell.backgroundColor = RGBA(125, 177, 27, 1);
        cell.imageView.hidden = YES;
        cell.title.hidden = NO;
    }
    else
    {
        [cell setDatas:_datas[@"sellers"][indexPath.row]];
        cell.imageView.hidden = NO;
        cell.title.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    if (indexPath.row == [_datas[@"sellers"] count]) {
        datas[@"seller_id"] = @"0";
    }
    else
    {
        datas[@"seller_id"] = _datas[@"sellers"][indexPath.row][@"id"];
    }
    datas[@"stage_id"] = @"0";
    datas[@"subject_id"] = @"0";
    datas[@"area_id"] = @"0";
  
    LocalMoreViewController *more = [[LocalMoreViewController alloc] initWithDatas:datas];
    [self pushViewController:more];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    

    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.tableHeaderView = [self createHeaderView];
    [_table.header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), ScaleH(30))];
    lb.text = @"猜你喜欢";
    lb.font = Font(17);
    lb.textColor = [UIColor whiteColor];
    lb.backgroundColor = CustomGray;
    return lb;
}





- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(30);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas[@"products"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSString *name = [Base64 textFromBase64String:_datas[@"products"][indexPath.row][@"name"]];
    CGSize nameSize = [NSObject getSizeWithText:name font:FontBold(17) maxSize:CGSizeMake(DeviceW - ScaleW(90) - kDefaultInset.left * 4, MAXFLOAT)];

    NSString *tipContent = [Base64 textFromBase64String:_datas[@"products"][indexPath.row][@"tipContent"]];
    CGSize tipSize = [NSObject getSizeWithText:tipContent font:Font(15) maxSize:CGSizeMake(DeviceW - ScaleW(90) - kDefaultInset.left * 4, MAXFLOAT)];

    return kDefaultInset.top * 3 + nameSize.height + tipSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    LTCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.datas = _datas[@"products"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *viewControllers = @[[DetailsViewController  new], [BusinessDetailViewController new],  [OGCommentViewController new]];
    DetailOrganizationViewController *controller = [[DetailOrganizationViewController alloc] initWithViewControllers:viewControllers andId:_datas[@"products"][indexPath.row][@"id"]];
    [self pushViewController:controller];

}


- (void)refreshDatas;
{

    _connection = [BaseModel POST:getsellers parameter:nil class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       _datas = data[@"data"];
                       [self reloadTabData];
                       [_collectionView reloadData];
                       [_table.header endRefreshing];
                       
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_table.bounds toView:_table abnormalType:NotDatas];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:self.table];
                       }
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       
                       [self.view makeToast:msg];
                       [_table.header endRefreshing];
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_table.bounds toView:_table abnormalType:NotDatas];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.table];
                           }
                           
                       }
                       else
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_table.bounds toView:_table abnormalType:NotDatas];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:self.table];
                           }
                           
                       }
                       
                   }];
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
