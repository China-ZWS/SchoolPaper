//
//  SupermarketViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "SupermarketViewController.h"
#import "MJRefresh.h"
#import "AgeGroupViewController.h"
#import "AGPlayerViewController.h"
#import "AGDocumentViewController.h"
#import "LocalOrganizationViewController.h"
#import "AppDelegate.h"

#import "ActivityAreaViewController.h"
#import "NewActivityViewController.h"
#import "OldActivityViewController.h"

@interface SupermarketCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *abstracts;
@property (nonatomic) id datas;
@end

@implementation SupermarketCell


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor whiteColor];
        _title.font = FontBold(20);
        
        _abstracts = [UILabel new];
        _abstracts.textColor = [UIColor whiteColor];
        _abstracts.textAlignment = NSTextAlignmentCenter;
        _abstracts.font = Font(17);
        
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = (DeviceW - ScaleW(40)) / 2;
    CGFloat height = width/1.3 / 2;

    _title.frame = CGRectMake(0, height - _title.font.lineHeight - ScaleH(2), CGRectGetWidth(self.frame), _title.font.lineHeight);
    _abstracts.frame = CGRectMake(0, height + ScaleH(2), CGRectGetWidth(self.frame), _abstracts.font.lineHeight);
}


- (void)setDatas:(id)datas
{
    NSString *ageName = [Base64 textFromBase64String:datas[@"ageName"]];
    NSString *edutypeName = [Base64 textFromBase64String:datas[@"edutypeName"]];
    _title.text = ageName;
    _abstracts.text =  edutypeName;
}
@end


@interface SupermarketViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    NSArray *_datas;
}
@end

@implementation SupermarketViewController

- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"超 市"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];

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
    CGFloat width = (DeviceW - ScaleW(40)) / 2;
    CGFloat height = width/1.3;
    segmentBarLayout.itemSize = CGSizeMake(width,height);
    segmentBarLayout.sectionInset = UIEdgeInsetsMake(ScaleW(15), ScaleW(15), ScaleW(15), ScaleW(15));
    segmentBarLayout.minimumLineSpacing = ScaleW(10);
    segmentBarLayout.minimumInteritemSpacing = ScaleW(10);
    return segmentBarLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self segmentBarLayout]];
    _collectionView.userInteractionEnabled = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[SupermarketCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical  = YES;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    
    _collectionView.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (!app.datas)
    {
        [_collectionView.header beginRefreshing];

    }
    else
    {
        _datas = app.datas;

    }
 
    


}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    SupermarketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = CustomAlphaPurple;
    cell.datas = _datas[indexPath.row];
    
    
    switch (indexPath.row % 5) {
        case 0:
            cell.backgroundColor = RGBA(23, 103, 223, 1);
            break;
        case 1:
            cell.backgroundColor = RGBA(237, 121, 38, 1);
            break;
        case 2:
            cell.backgroundColor = RGBA(125, 177, 27, 1);
            break;
        case 3:
            cell.backgroundColor = RGBA(208, 22, 100, 1);
            break;
        case 4:
            cell.backgroundColor = RGBA(184, 92, 148, 1);
            break;
        default:
            break;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < _datas.count - 2)
    {
        NSDictionary *dic = _datas[indexPath.row];
        NSArray *viewControllers = @[[[AGPlayerViewController alloc] initWithStageId:dic[@"id"]], [[AGDocumentViewController alloc] initWithStageId:dic[@"id"]]];
        AgeGroupViewController *controller = [[AgeGroupViewController alloc] initWithViewControllers:viewControllers datas:dic];
        [self pushViewController:controller];

    }
    else if (indexPath.row == 5)
    {
        NSArray *viewControllers = @[[NewActivityViewController  new], [OldActivityViewController new]];
        ActivityAreaViewController *controller = [[ActivityAreaViewController alloc] initWithViewControllers:viewControllers];
        [self pushViewController:controller];
    }
    else
    {
        LocalOrganizationViewController *ctr = [LocalOrganizationViewController new];
        [self pushViewController:ctr];
    }
    
 }


- (void)refreshDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _connection = [BaseModel POST:getdefaultscheme parameter:params class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       NSMutableArray *tmps = [NSMutableArray arrayWithArray:data[@"data"][@"stages"]];
                       [tmps addObjectsFromArray:@[@{@"ageName":[Base64 base64StringFromText:@"活动专区"],@"edutypeName":[Base64 base64StringFromText:@""]},
                                                   @{@"ageName":[Base64 base64StringFromText:@"本地"],@"edutypeName":[Base64 base64StringFromText:@"培训机构"]}]];
                       _datas = tmps;
                       if (!_datas.count)
                       {
                           [AbnormalView setRect:_collectionView.frame toView:_collectionView abnormalType:NotDatas];
                           [AbnormalView setDelegate:self toView:_collectionView];
                       }
                       else
                       {
                           [AbnormalView hideHUDForView:_collectionView];
                           AppDelegate *app = [UIApplication sharedApplication].delegate;
                           app.datas = _datas;
                           [_collectionView reloadData];
                       }
                       [_collectionView.header endRefreshing];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [_collectionView.header endRefreshing];
                       
                       if ([state isEqualToString:kNetworkAnomaly])
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_collectionView.bounds toView:_collectionView abnormalType:NotNetWork];
                               [AbnormalView setDelegate:self toView:_collectionView];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_collectionView];
                           }
                       }
                       else
                       {
                           if (!_datas.count)
                           {
                               [AbnormalView setRect:_collectionView.frame toView:_collectionView abnormalType:kError];
                               [AbnormalView setDelegate:self toView:_collectionView];
                           }
                           else
                           {
                               [AbnormalView hideHUDForView:_collectionView];
                           }
                       }
                   }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController  setToolbarHidden:YES animated:YES];
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
