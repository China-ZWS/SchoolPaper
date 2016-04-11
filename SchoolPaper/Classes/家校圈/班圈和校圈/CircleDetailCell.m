//
//  ClassSchoolDetailCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "CircleDetailCell.h"

@interface CSCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CSCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self.contentView addSubview:self.imageView];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    }
    return _imageView;
}


@end



@implementation CircleDetailCell


- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - .3) end:CGPointMake(DeviceW, CGRectGetHeight(rect) - .3) lineColor:CustomGray lineWidth:.3];

}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (DeviceW - ScaleW(20) - ScaleH(30) - ScaleW(20)) / 3;
    segmentBarLayout.itemSize = CGSizeMake(width,width);
    segmentBarLayout.sectionInset = UIEdgeInsetsMake(ScaleW(20) / 6, ScaleW(20) / 6, 0, ScaleW(20) / 6);
    segmentBarLayout.minimumLineSpacing = ScaleW(20) / 3;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _headImageView = [[UIImageView alloc] initWithFrame: CGRectMake(ScaleX(15), ScaleY(15), ScaleW(60), ScaleH(60))];
        
        _name = [UILabel new];
        _name.font = FontBold(19);
        _name.textColor = CustomBlue;
        
        _createTime = [UILabel new];
        _createTime.font = Font(15);
        _createTime.textColor = CustomBlack;
        
        _contentLb = [UILabel new];
        _contentLb.font = Font(17);
        _contentLb.numberOfLines = 0;
        _contentLb.textColor = CustomBlack;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self segmentBarLayout]];
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass:[CSCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _plBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _plBtn.titleLabel.font = Font(17);
        [_plBtn setTitleColor:CustomGray forState:UIControlStateNormal];
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanBtn.titleLabel.font = Font(17);
        [_zanBtn setTitleColor:CustomGray forState:UIControlStateNormal];

        _plBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-ScaleW(10),0,0);
        _zanBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-ScaleW(10),0,0);

        _plList = [[PJTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _plList.autoresizingMask = UIViewAutoresizingNone;
        _plList.delegate = self;
        _plList.dataSource = self;
        _plList.scrollEnabled = NO;
        _plList.userInteractionEnabled = NO;
        _listBack = [UIImageView new];
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_contentLb];
        [self.contentView addSubview:_createTime];
        [self.contentView addSubview:_collectionView];
        [self.contentView addSubview:_plBtn];
        [self.contentView addSubview:_zanBtn];
        [self.contentView addSubview:_listBack];
        [self.contentView addSubview:_plList];
    }
    return self;
}


- (void)setDatas:(id)datas
{
    _plList.hidden = YES;
    _plList.frame = CGRectZero;
    _listBack.hidden = YES;
    _listBack.frame = CGRectZero;

    _collectionView.hidden = YES;
    _collectionView.frame = CGRectZero;
    
    _datas = datas;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_datas[@"postTop"]] placeholderImage:[UIImage imageNamed:@"userguide_avatar_icon.png"]];
    
    [self initWithName:datas];// 对用户名的布局
    [self initWithTime:datas];// 时间布局
    [self initWithContent:datas]; // 对类容的布局
    [self initWithImages:datas]; // 对图片的布局
    [self initWithPlAndZan:datas]; // 对评论和暂布局
    [self initWithPlList:datas]; // 评论列表布局
}

#pragma mark - 用户名布局
- (void)initWithName:(NSDictionary *)datas
{
    NSString *postName = [Base64 textFromBase64String:datas[@"postName"]];
    CGSize postNameSize = [NSObject getSizeWithText:postName font:_name.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(_headImageView.frame) - ScaleW(15) * 2, ScaleW(20))];
    _name.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMidY(_headImageView.frame) - ScaleH(3) - postNameSize.height, postNameSize.width, postNameSize.height);
    _name.text = postName;
}

#pragma mark - 时间布局
- (void)initWithTime:(NSDictionary *)datas
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:datas[@"postTime"]];
    NSString *postTime = [NSObject compareCurrentTimeToPastTime:date];
    
    CGSize postTimeSize = [NSObject getSizeWithText:postTime font:_createTime.font maxSize:CGSizeMake(MAXFLOAT, ScaleH(20))];
   
    _createTime.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMidY(_headImageView.frame) + ScaleH(3), postTimeSize.width, postTimeSize.height);
    _createTime.backgroundColor = [UIColor clearColor];
    _createTime.text = postTime;
}

#pragma mark - 对类容的布局
- (void)initWithContent:(NSDictionary *)datas
{
    NSString *postContent = [Base64 textFromBase64String:datas[@"postContent"]];
    
    CGSize postContentSize = [NSObject getSizeWithText:postContent font:_contentLb.font maxSize:CGSizeMake(DeviceW - ScaleW(30), MAXFLOAT)];
    
    _contentLb.frame = CGRectMake(ScaleW(15), CGRectGetMaxY(_headImageView.frame) + ScaleH(10), postContentSize.width, postContentSize.height);
    _contentLb.text = postContent;
}

#pragma mark - 对图片的布局
- (void)initWithImages:(NSDictionary *)datas
{
    CGFloat imageHeight = 0;
    NSArray *images = datas[@"postImgs"];
    
    if (images.count)
    {
        CGFloat width = (DeviceW - ScaleW(20) - ScaleH(30)) / 3;
        imageHeight = width * ceil((float)images.count/3) ;
        _collectionView.frame = CGRectMake(ScaleX(15) + ScaleW(10), CGRectGetMaxY(_contentLb.frame) + ScaleH(5), DeviceW - ScaleW(20) - ScaleH(30), imageHeight);
        [_collectionView reloadData];
        _collectionView.hidden = NO;
    }
}

#pragma mark - 对评论和暂控件布局
- (void)initWithPlAndZan:(NSDictionary *)datas
{
    UIImage *talkImg = [UIImage imageNamed:@"icon_talk.png"];
    UIImage *zan = [UIImage imageNamed:@"icon_heart.png"];
    UIImage *zan_h = [UIImage imageNamed:@"icon_heart_checked.png"];
    
    NSInteger talkNum = [datas[@"comments"] count];
    NSString *zanNum = datas[@"zan"];
    if (!_collectionView.hidden)
    {
        _plBtn.frame = CGRectMake(ScaleW(15), CGRectGetMaxY(_collectionView.frame) + ScaleH(10), ScaleW(50), ScaleW(30));
        _zanBtn.frame = CGRectMake(DeviceW - ScaleW(15) - ScaleW(50), CGRectGetMaxY(_collectionView.frame) + ScaleH(10), ScaleW(50), ScaleH(30));
    }
    else if (CGRectGetHeight(_contentLb.frame))
    {
        _plBtn.frame = CGRectMake(ScaleW(15), CGRectGetMaxY(_contentLb.frame) + ScaleH(10), ScaleW(50), ScaleW(30));
        _zanBtn.frame = CGRectMake(DeviceW - ScaleW(15) - ScaleW(50), CGRectGetMaxY(_contentLb.frame) + ScaleH(10), ScaleW(50), ScaleH(30));
    }
    [_plBtn setImage:talkImg forState:UIControlStateNormal];
    [_plBtn setTitle:[NSString stringWithFormat:@"%d",talkNum] forState:UIControlStateNormal];
    if (![zanNum integerValue]) {
        [_zanBtn setImage:zan forState:UIControlStateNormal];
    }
    else
    {
        [_zanBtn setImage:zan_h forState:UIControlStateNormal];
    }
    [_zanBtn setTitle:zanNum forState:UIControlStateNormal];
    _zanBtn.bindingInfo = @{@"data":datas};

}

#pragma mark - 对评论列表布局
- (void)initWithPlList:(NSDictionary *)datas
{
    NSInteger talkNum = [datas[@"comments"] count];
    
    
    if (talkNum) {
        
        _listBack.hidden = NO;
        _plList.hidden = NO;
        CGFloat tabHeight = 0;
        for (NSDictionary *dic in datas[@"comments"])
        {
            NSString *title = [[[Base64 textFromBase64String:dic[@"commentName"]] stringByAppendingString:@":"] stringByAppendingString:[Base64 textFromBase64String:dic[@"comment"]]];
            CGSize size = [NSObject getSizeWithText:title font:Font(17) maxSize:CGSizeMake(DeviceW - ScaleW(15) * 2, MAXFLOAT)];
            tabHeight += (size.height + ScaleH(6));
        }
        _plList.frame = CGRectMake(CGRectGetMinX(_plBtn.frame), CGRectGetMaxY(_zanBtn.frame) + ScaleH(10), DeviceW - ScaleW(30), tabHeight);
        [_plList reloadData];
        
        UIImage *image = [UIImage imageNamed:@"tip.png"];
        CGFloat top = 10; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 25; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        image = [image resizableImageWithCapInsets:insets ];
        
        _listBack.frame = CGRectMake(CGRectGetMinX(_plList.frame) - ScaleW(5), CGRectGetMinY(_plList.frame) - ScaleH(10), CGRectGetWidth(_plList.frame) + ScaleW(10), CGRectGetHeight(_plList.frame) + ScaleH(15));
        _listBack.image = image;
    }

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datas[@"postImgs"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSString * image = _datas[@"postImgs"][indexPath.row];
    
    if ([image isKindOfClass:[NSString class]])
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:image ] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
        
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - tableViewDelegate and tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas[@"comments"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _datas[@"comments"][indexPath.row];
    NSString *title = [[[Base64 textFromBase64String:dic[@"commentName"]] stringByAppendingString:@":"] stringByAppendingString:[Base64 textFromBase64String:dic[@"comment"]]];
    CGSize size = [NSObject getSizeWithText:title font:Font(17) maxSize:CGSizeMake(CGRectGetWidth(tableView.frame), MAXFLOAT)];
    return size.height + ScaleH(6);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    PJCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    if (!cell)
    {
        cell = [[PJCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentLb = [UILabel new];
        cell.contentLb.font = Font(16);
        cell.contentLb.numberOfLines = 0;
        [cell.contentView addSubview:cell.contentLb];
    }
    
    NSDictionary *dic = _datas[@"comments"][indexPath.row];
    NSString *title = [[[Base64 textFromBase64String:dic[@"commentName"]] stringByAppendingString:@":"] stringByAppendingString:[Base64 textFromBase64String:dic[@"comment"]]];
    CGSize size = [NSObject getSizeWithText:title font:cell.contentLb.font maxSize:CGSizeMake(CGRectGetWidth(tableView.frame), MAXFLOAT)];
    
    NSMutableAttributedString *attTitle =  [[NSMutableAttributedString alloc] initWithString:title];
    [attTitle addAttribute:NSForegroundColorAttributeName value:CustomBlue range:NSMakeRange(0,attTitle.length - [[Base64 textFromBase64String:dic[@"commentName"]] length] + 1)];
    [attTitle addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([[Base64 textFromBase64String:dic[@"commentName"]] length] + 1, [[Base64 textFromBase64String:dic[@"comment"]] length])];
    
    cell.contentLb.frame = CGRectMake(0, ScaleH(3), size.width, size.height);
    cell.contentLb.attributedText = attTitle;
    return cell;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


