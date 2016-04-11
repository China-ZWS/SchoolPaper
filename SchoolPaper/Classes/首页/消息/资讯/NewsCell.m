//
//  NewsCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-3.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()
{
    NSInteger _maxRow;
    NSIndexPath *_indexPath;
    
}

@end

@implementation NewsCell

- (void)drawRect:(CGRect)rect
{
    UIEdgeInsets inset = UIEdgeInsetsMake(ScaleX(.5), ScaleY(10), ScaleW(.5), ScaleH(10));

    if (_maxRow)
    {
        if (_indexPath.row == 0)
        {
            [self drawCellWithRound:rect cellStyle:kUpCell inset:inset radius:ScaleW(5) lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
            CGContextRef context =UIGraphicsGetCurrentContext();
            CGContextBeginPath(context);
            CGContextSetLineWidth(context, .5);
            CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
            CGFloat lengths[] = {5,10};
            CGContextSetLineDash(context, 0, lengths,2);
            CGContextMoveToPoint(context, ScaleW(100)+ ScaleW(15), CGRectGetHeight(rect)  - .3);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect) - 10,CGRectGetHeight(rect)  - .3);
            CGContextClosePath(context);
            CGContextStrokePath(context);
        }
        else if (_indexPath.row == _maxRow)
        {
            [self drawCellWithRound:rect cellStyle:kDownCell inset:inset radius:ScaleW(5) lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
        }
        else
        {
            [self drawCellWithRound:rect cellStyle:kCenterCell inset:inset radius:ScaleW(5) lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
            CGContextRef context =UIGraphicsGetCurrentContext();
            CGContextBeginPath(context);
            CGContextSetLineWidth(context, .5);
            CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
            CGFloat lengths[] = {5,10};
            CGContextSetLineDash(context, 0, lengths,2);
            CGContextMoveToPoint(context, ScaleW(100) + ScaleW(15), CGRectGetHeight(rect)  - .3);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect) - 10,CGRectGetHeight(rect)  - .3);
            CGContextClosePath(context);
            CGContextStrokePath(context);
        }
    }
    else
    {
        [self drawCellWithRound:rect cellStyle:kRoundCell inset:inset radius:ScaleW(5) lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        _headImageView = [UIImageView new];
        _title = [UILabel new];
        _contentLb = [UILabel new];
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_contentLb];
    }
    return self;
}


- (void)setDatas:(id)datas indexPath:(NSIndexPath *)indexPath;
{
    _maxRow = [datas count] - 1;
    _indexPath = indexPath;
    [self setNeedsDisplay];
    NSDictionary *dic = datas[indexPath.row];
    NSString *newsimg = dic[@"newsImg"];
    if (indexPath.row == 0)
    {
        _contentLb.hidden = YES;
        _headImageView.frame = CGRectMake(ScaleW(15), ScaleY(10), DeviceW - ScaleW(15) * 2, (DeviceW - ScaleW(10) * 2) / 1.3322);
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:newsimg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
        _title.frame = CGRectMake(ScaleW(15), CGRectGetHeight(_headImageView.frame) - ScaleH(40) + ScaleY(10), DeviceW - ScaleW(15) * 2, ScaleH(40));
        _title.backgroundColor = RGBA(10, 10, 10, .6);
        _title.font = FontBold(20);
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.text = dic[@"newsTitle"];
    }
    else
    {
        _contentLb.hidden = NO;
        _headImageView.frame = CGRectMake(ScaleW(15), ScaleY(10), ScaleW(100), ScaleH(100) / 1.3322);
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:newsimg] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
        
        
        _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleH(15), ScaleY(10), DeviceW - (CGRectGetMaxX(_headImageView.frame) + ScaleH(15) * 2), ScaleH(20));
        _title.backgroundColor = [UIColor clearColor];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.textColor = CustomBlue;
        _title.font = FontBold(18);
        _title.text = dic[@"newsTitle"];
        
        _contentLb.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleH(15), CGRectGetMaxY(_title.frame) + ScaleH(10), DeviceW - (CGRectGetMaxX(_headImageView.frame) + ScaleH(15) * 2), ScaleH(40));
        _contentLb.backgroundColor = [UIColor clearColor];
        _contentLb.textAlignment = NSTextAlignmentLeft;
        _contentLb.textColor = CustomGray;
        _contentLb.numberOfLines = 0;
        _contentLb.font = Font(17);
        _contentLb.text = dic[@"newsTitle"];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
