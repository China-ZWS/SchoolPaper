
//
//  AboutListCell.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-20.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "FeedBackCell.h"

@implementation FeedBackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
    }
    return self;
}

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
