//
//  AchievementCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AchievementCell.h"

@implementation AchievementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawWithChamferOfRectangle:rect inset:UIEdgeInsetsMake(ScaleX(8),ScaleY(10),ScaleX(8),ScaleX(10)) radius:3 lineWidth:.3 lineColor:CustomGray backgroundColor:[UIColor whiteColor]];
    
    NSString *time = nil;
    NSString *subject = nil;
    NSString *score = nil;
    NSString *rank = nil;
    UIColor *textColor = nil;
    UIFont *font = nil;
    
    CGFloat width = (CGRectGetWidth(rect) - ScaleH(20))  / 4;
    CGFloat height = CGRectGetHeight(rect);
    CGFloat inset = 10;
    
    if (_indexPath.row == 0)
    {
        time = @"时 间";
        subject = @"科 目";
        score = @"分 数";
        rank = @"班级排名";
        font = FontBold(19);
        textColor = CustomBlue;
    }
    else
    {
        time = _datas[@"kssj"];
        subject = _datas[@"kcName"];
        score = _datas[@"kscj"];
        rank = _datas[@"pmClass"];
        font = Font(16);
        textColor = RGBA(30, 30, 30, 1);
    }
    
    
    CGSize timeSize = [NSObject getSizeWithText:time font:font maxSize:CGSizeMake(width, CGRectGetHeight(rect))];
    CGSize subjectSize = [NSObject getSizeWithText:subject font:font maxSize:CGSizeMake(width, CGRectGetHeight(rect))];
    CGSize scoreSize = [NSObject getSizeWithText:score font:font maxSize:CGSizeMake(width, CGRectGetHeight(rect))];
    CGSize rankSize = [NSObject getSizeWithText:rank font:font maxSize:CGSizeMake(width, CGRectGetHeight(rect))];
    
    [self drawTextWithText:time rect:CGRectMake(ScaleX(10) + (width - timeSize.width) / 2 + inset, (height - timeSize.height) / 2,timeSize.width, timeSize.height) color:textColor font:font];
    [self drawTextWithText:subject rect:CGRectMake(ScaleX(10) + width + (width - subjectSize.width) / 2 + inset, (height - subjectSize.height) / 2, subjectSize.width, subjectSize.height) color:textColor font:font];
    [self drawTextWithText:score rect:CGRectMake(ScaleX(10) + width * 2 + (width - scoreSize.width) / 2 , (height - scoreSize.height) / 2, scoreSize.width, scoreSize.height) color:textColor font:font];
    [self drawTextWithText:rank rect:CGRectMake(ScaleX(10) + width * 3 + (width - rankSize.width) / 2, (height - rankSize.height) / 2, rankSize.width, rankSize.height) color:textColor font:font];
}

- (void)setDatas:(id)datas indexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _datas = datas;
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
