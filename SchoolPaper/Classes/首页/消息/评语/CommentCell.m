//
//  CommentCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "CommentCell.h"
@implementation CommentCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        UIImage *image = [UIImage imageNamed:@"comment_icon.png"];
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScaleX(15) + ScaleW(10), ScaleY(15) + ScaleH(8), image.size.width, image.size.height)];
        _headImageView.image = image;
        _name = [UILabel new];
        _name.font = FontBold(19);
        _name.textColor = CustomBlue;
        
        _title = [UILabel new];
        _title.textColor = [UIColor redColor];
        _title.font = Font(17);
        
        _contentLb = [UILabel new];
        _contentLb.numberOfLines = 0;
        _contentLb.font = Font(17);
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_contentLb];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [self drawWithChamferOfRectangle:rect inset:UIEdgeInsetsMake(ScaleX(8),ScaleY(10),ScaleX(8),ScaleX(10)) radius:3 lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];

    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat lengths[] = {5,10};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, CGRectGetMinX(_name.frame),_lineHeight);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect)  - ScaleW(10),_lineHeight);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
}

- (void)setDatas:(id)datas
{

    NSString *commentType = [Base64 textFromBase64String:datas[@"commentType"]];
    NSString *comment = [Base64 textFromBase64String:datas[@"comment"]];
    NSString *score = [NSString stringWithFormat:@"总评分：%@",datas[@"score"]];

    CGSize scoreSize = [NSObject getSizeWithText:score font:_title.font maxSize:CGSizeMake(MAXFLOAT, 25)];
    _title.frame = CGRectMake(DeviceW - ScaleY(10)*2 - scoreSize.width,(CGRectGetHeight(_headImageView.frame) - scoreSize.height) / 2 + CGRectGetMinY(_headImageView.frame), scoreSize.width, scoreSize.height);
    _title.text = score;
    
    CGSize commentTypeSize = [NSObject getSizeWithText:commentType font:_name.font maxSize:CGSizeMake(DeviceW - ScaleY(10) * 2 - scoreSize.width - CGRectGetMaxX(_headImageView.frame), 25)];
    _name.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(10), (CGRectGetHeight(_headImageView.frame) - commentTypeSize.height) / 2 + CGRectGetMinY(_headImageView.frame), commentTypeSize.width, commentTypeSize.height);
    _name.text = commentType;
    
    _lineHeight = CGRectGetMaxY(_name.frame) + ScaleH(5);
    
    CGSize contentSize = [NSObject getSizeWithText:comment font:_contentLb.font maxSize:CGSizeMake(DeviceW - ScaleY(10) * 3 - CGRectGetMaxX(_headImageView.frame), MAXFLOAT)];
    _contentLb.frame = CGRectMake(CGRectGetMinX(_name.frame), _lineHeight + ScaleH(5), contentSize.width, contentSize.height);
    _contentLb.text = comment;
    [self setNeedsDisplay];

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
