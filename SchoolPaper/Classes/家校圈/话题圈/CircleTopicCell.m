//
//  CircleTopicCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-5-4.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "CircleTopicCell.h"

@implementation CircleTopicCell


- (void)drawRect:(CGRect)rect
{
    [self drawWithChamferOfRectangle:rect inset:kDefaultInset radius:3 lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat lengths[] = {5,10};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMidY(_headImageView.frame));
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - kDefaultInset.right - ScaleW(15),CGRectGetMidY(_headImageView.frame) );
    CGContextClosePath(context);
    CGContextStrokePath(context);

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
        _headImageView = [[UIImageView alloc] initWithFrame: CGRectMake(kDefaultInset.left + ScaleX(15), kDefaultInset.top + ScaleY(15), ScaleW(60), ScaleH(60))];
        _type = [UIImageView new];
        
        
        _topic = [UILabel new];
        _topic.font = FontBold(19);
        _topic.textColor = CustomBlue;
        
        _name = [UILabel new];
        _name.font = Font(17);
        _name.textColor = CustomGray;
        
        _createTime = [UILabel new];
        _createTime.font = Font(15);
        _createTime.textColor = CustomGray;
        
        _contentLb = [UILabel new];
        _contentLb.font = Font(17);
        _contentLb.numberOfLines = 0;
        _contentLb.textColor = CustomGray;
        
        
        _plBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _plBtn.titleLabel.font = Font(17);
        [_plBtn setTitleColor:CustomGray forState:UIControlStateNormal];
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanBtn.titleLabel.font = Font(17);
        [_zanBtn setTitleColor:CustomGray forState:UIControlStateNormal];
        
        _plBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-ScaleW(10),0,0);
        _zanBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-ScaleW(10),0,0);
        
        [self.contentView addSubview:_type];
        [self.contentView addSubview:_topic];
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_contentLb];
        [self.contentView addSubview:_createTime];
        [self.contentView addSubview:_plBtn];
        [self.contentView addSubview:_zanBtn];
    }
    return self;
}

- (void)setDatas:(id)datas
{
    
    _type.hidden = YES;
    _type.frame = CGRectZero;
    _collectionView.hidden = YES;
    _collectionView.frame = CGRectZero;

    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_datas[@"boardTop"]] placeholderImage:[UIImage imageNamed:@"userguide_avatar_icon.png"]];

    [self initWithType:datas]; // 对状态的布局
    [self initWithTopic:datas];// 对用户名的布局
    [self initWithName:datas];// 对用户名的布局
    [self initWithTime:datas];// 时间布局
    [self initWithContent:datas]; // 对类容的布局
    [self initWithPlAndZan:datas]; // 对评论和暂布局

}

- (void)initWithType:(NSDictionary *)datas
{
    if ([datas[@"istop"] integerValue])
    {
        UIImage *image = [UIImage imageNamed:@"ic_top.png"];
        _type.frame = CGRectMake(DeviceW - kDefaultInset.right - ScaleW(15) - image.size.width, CGRectGetMidY(_headImageView.frame) - image.size.height - ScaleH(3), image.size.width, image.size.height);
        _type.image = image;
        _type.hidden = NO;
    }
    else if ([datas[@"isimg"] integerValue])
    {
        UIImage *image = [UIImage imageNamed:@"ic_has_img.png"];
        _type.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMidY(_headImageView.frame) - image.size.height - ScaleH(3), image.size.width, image.size.height);
        _type.image = image;
        _type.hidden = NO;
    }
}

- (void)initWithTopic:(NSDictionary *)datas
{
    NSString *boardTitle = [Base64 textFromBase64String:datas[@"boardtitle"]];
    CGSize boardTitleSize = [NSObject getSizeWithText:boardTitle font:_topic.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(_headImageView.frame) - ScaleW(15) * 2, ScaleW(20))];
    
    if ([datas[@"isimg"] integerValue])
    {
        _topic.frame = CGRectMake(CGRectGetMaxX(_type.frame) + ScaleW(15), CGRectGetMidY(_headImageView.frame) - boardTitleSize.height - ScaleH(3), boardTitleSize.width, boardTitleSize.height);
    }
    else
    {
        _topic.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMidY(_headImageView.frame) - boardTitleSize.height - ScaleH(3), boardTitleSize.width, boardTitleSize.height);
    }

    _topic.text = boardTitle;
}

- (void)initWithName:(NSDictionary *)datas
{
    NSString *boardName = [Base64 textFromBase64String:datas[@"boardName"]];
    CGSize boardNameSize = [NSObject getSizeWithText:boardName font:_name.font maxSize:CGSizeMake(DeviceW - CGRectGetMaxX(_headImageView.frame) - ScaleW(15) * 2, ScaleW(20))];
    
     _name.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMidY(_headImageView.frame) + ScaleH(3), boardNameSize.width, boardNameSize.height);

    _name.text = boardName;

}

- (void)initWithTime:(NSDictionary *)datas
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:datas[@"boardTime"]];
    NSString *postTime = [NSObject compareCurrentTimeToPastTime:date];
    
    CGSize boardTimeSize = [NSObject getSizeWithText:postTime font:_createTime.font maxSize:CGSizeMake(MAXFLOAT, ScaleH(20))];
    
    _createTime.frame = CGRectMake(DeviceW - kDefaultInset.right - boardTimeSize.width - ScaleW(15), CGRectGetMidY(_headImageView.frame) + ScaleH(3), boardTimeSize.width, boardTimeSize.height);
    _createTime.backgroundColor = [UIColor clearColor];
    _createTime.text = postTime;
}

- (void)initWithContent:(NSDictionary *)datas
{
    NSString *postContent = [Base64 textFromBase64String:datas[@"boardContent"]];
    
    _contentLb.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMaxY(_headImageView.frame), DeviceW - (kDefaultInset.right + kDefaultInset.left + CGRectGetWidth(_headImageView.frame) + ScaleW(45)), _contentLb.font.lineHeight * 2);
    _contentLb.backgroundColor = [UIColor clearColor];
    _contentLb.text = postContent;
}



- (void)initWithPlAndZan:(NSDictionary *)datas
{
    UIImage *talkImg = [UIImage imageNamed:@"icon_talk.png"];
    UIImage *zan = [UIImage imageNamed:@"icon_heart.png"];
    UIImage *zan_h = [UIImage imageNamed:@"icon_heart_checked.png"];
    
    NSInteger talkNum = [datas[@"comments"] count];
    NSString *zanNum = datas[@"zan"];
    _plBtn.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMaxY(_contentLb.frame) + ScaleH(5), ScaleW(50), ScaleW(30));
    _zanBtn.frame = CGRectMake(DeviceW - ScaleW(15) - ScaleW(50), CGRectGetMaxY(_contentLb.frame) + ScaleH(5), ScaleW(50), ScaleH(30));
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




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
