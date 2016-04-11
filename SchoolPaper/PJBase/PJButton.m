//
//  PJButton.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-14.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJButton.h"

@implementation PJButton

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self getCornerRadius:ScaleH(5) borderColor:CustomGray borderWidth:.5 masksToBounds:YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);    
    CGContextMoveToPoint(context,
                         CGRectGetWidth(rect), CGRectGetHeight(rect) - ScaleH(10));//设置起点
    
    
    CGContextAddLineToPoint(context,
                            CGRectGetWidth(rect), CGRectGetHeight(rect) - 1);
    
    CGContextAddLineToPoint(context,
                            CGRectGetWidth(rect) - ScaleH(10), CGRectGetHeight(rect) - 1);
    
    CGContextClosePath(context);
    
    
    [CustomGray setFill];
    
    
    [CustomGray setStroke];    
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path

    
}


- (void)setShowBorder:(BOOL)showBorder
{
    if (!showBorder) {
        [self getCornerRadius:0 borderColor:[UIColor clearColor] borderWidth:0 masksToBounds:YES];
    }
    else
    {
        [self getCornerRadius:ScaleH(5) borderColor:CustomGray borderWidth:.5 masksToBounds:YES];
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
