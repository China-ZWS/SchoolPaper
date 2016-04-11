//
//  HSCircleCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "HSCircleCell.h"

@implementation HSCircleCell

- (void)drawRect:(CGRect)rect
{
    [self drawWithChamferOfRectangle:rect inset:UIEdgeInsetsMake(ScaleX(8),ScaleY(10),ScaleX(8),ScaleX(10)) radius:3 lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat lengths[] = {5,10};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetHeight(rect) / 2 - .5);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - kDefaultInset.right - ScaleW(15),CGRectGetHeight(rect) / 2 - .5);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _headImageView = [UIImageView new];
   
        _title = [UILabel new];
        _title.font = FontBold(19);
        _title.textColor = CustomBlue;
        
        _contentLb = [UILabel new];
        _contentLb.font = Font(17);
        _contentLb.textColor = CustomGray;
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_contentLb];
    }
    return self;

}

- (void)setDatas:(id)datas
{
    
    _headImageView.frame = CGRectMake(ScaleX(15) + ScaleX(10), (ScaleH(120) - ScaleH(70)) / 2 , ScaleW(70), ScaleH(70));
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:datas[@"circleTop"]] placeholderImage:[UIImage imageNamed:@"no_img.png"]];
    
    NSString *title = [Base64 textFromBase64String:datas[@"circleName"]];
    NSString *content = [Base64 textFromBase64String:datas[@"circleContent"]];
    
    CGSize titleSize = [NSObject getSizeWithText:title font:_title.font maxSize:CGSizeMake(DeviceW - ScaleW(15) * 2 - ScaleW(10) * 2 - CGRectGetWidth(_headImageView.frame), 20)];
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleX(15), ScaleH(120) / 2 - titleSize.height - ScaleH(5), titleSize.width, titleSize.height);
    _title.text = title;


    _contentLb.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleX(15), ScaleH(120) / 2 + ScaleH(5), DeviceW - (kDefaultInset.right + kDefaultInset.left + CGRectGetWidth(_headImageView.frame) + ScaleW(45)), ScaleH(20) );
    _contentLb.text = content;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
