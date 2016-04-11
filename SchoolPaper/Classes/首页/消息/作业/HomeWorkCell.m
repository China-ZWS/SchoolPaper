//
//  HomeWorkCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "HomeWorkCell.h"

@implementation HomeWorkCell

- (void)drawRect:(CGRect)rect
{
    
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat lengths[] = {5,10};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 10, CGRectGetHeight(rect) - .5);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - 10,CGRectGetHeight(rect) - .5);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        UIImage *image = [UIImage imageNamed:@"homework_icon.png"];
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScaleX(15), ScaleY(15), image.size.width, image.size.height)];
        _headImageView.image = image;
        
        
        _weekDay = [UILabel new];;
        _weekDay.textAlignment = NSTextAlignmentCenter;
        _weekDay.backgroundColor = [UIColor clearColor];
        _weekDay.font = Font(14);
        _weekDay.textColor = CustomGray;
        
        _hour = [UILabel new];
        _hour.textAlignment = NSTextAlignmentCenter;
        _hour.backgroundColor = [UIColor clearColor];
        _hour.font = Font(14);
        _hour.textColor = CustomGray;
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMinY(_headImageView.frame), 150, 0)];
        _name.font = FontBold(19);
        _name.textColor = CustomBlue;
        
        _createTime = [UILabel new];
        _createTime.font = Font(17);
        _createTime.textColor = CustomGray;
        
        _title = [UILabel new];
        _title.font = Font(17);
        _title.textColor = [UIColor blackColor];
        _title.numberOfLines = 0;
        
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_weekDay];
        [self.contentView addSubview:_hour];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_createTime];
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)setDatas:(id)datas
{
    
    _datas = datas;
    NSString *name = datas[@"jName"];
    _name.text = name;
    [_name sizeToFit];
    
    
    NSString *weekDay = [NSObject getWeekDay:datas[@"hwDate"] format:@"yyyy-MM-dd"];
    _weekDay.text = weekDay;
    [_weekDay sizeToFit];
    _weekDay.frame = CGRectMake((CGRectGetWidth(_headImageView.frame) + 2*ScaleW(15) - CGRectGetWidth(_weekDay.frame)) / 2, CGRectGetMaxY(_headImageView.frame) + ScaleH(5), CGRectGetWidth(_weekDay.frame), CGRectGetHeight(_weekDay.frame));
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *yearDate=[dateFormatter dateFromString:datas[@"hwDate"]];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *hour = [dateFormatter stringFromDate:yearDate];

    _hour.text = hour;
    [_hour sizeToFit];
    _hour.frame = CGRectMake((CGRectGetWidth(_headImageView.frame) + 2*ScaleW(15) - CGRectGetWidth(_hour.frame)) / 2, CGRectGetMaxY(_weekDay.frame) + ScaleH(5), CGRectGetWidth(_hour.frame), CGRectGetHeight(_hour.frame));
    
    NSString *createTime = [datas[@"hwDate"] componentsSeparatedByString:@" "][0];
    CGSize createTimeSize = [NSObject getSizeWithText:createTime font:Font(17) maxSize:CGSizeMake(MAXFLOAT, 20)];
    _createTime.text = createTime;
    _createTime.frame = CGRectMake(DeviceW - createTimeSize.width - ScaleW(15), CGRectGetMinY(_headImageView.frame), createTimeSize.width, createTimeSize.height);
    
    
    NSString *hwName = datas[@"hwName"];
    NSString *hwNr = [Base64 textFromBase64String:datas[@"hwNr"]];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[[hwName stringByAppendingString:@"："]stringByAppendingString:hwNr]];
    [content addAttribute:NSForegroundColorAttributeName value:CustomBlue range:NSMakeRange(0,content.length - [hwNr length])];
    [content addAttribute:NSForegroundColorAttributeName value:CustomGray range:NSMakeRange([hwName length] + 1, [hwNr length])];
    [content addAttribute:NSFontAttributeName value:Font(17) range:NSMakeRange(0, [hwName length])];
    
    CGSize contentSize = [NSObject getSizeWithText:[[hwName stringByAppendingString:@"："]stringByAppendingString:hwNr] font:_title.font maxSize:CGSizeMake(DeviceW - (CGRectGetMaxX(_headImageView.frame) + ScaleW(15) + ScaleW(5)), MAXFLOAT)];
  
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + ScaleW(15), CGRectGetMaxY(_name.frame) + ScaleH(5), contentSize.width, contentSize.height);
    _title.attributedText= content;
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
