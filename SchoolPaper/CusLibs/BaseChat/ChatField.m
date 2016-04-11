//
//  ChatField.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-31.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ChatField.h"
#define MaxHeight 120
#import "Device.h"
#import "Header.h"
#import "Category.h"

@implementation ChatField
{
    BOOL _isShow;
}

- (void)dealloc
{
    [self resignFirstResponder];
}

- (id)initWithFont:(UIFont *)font inset:(UIEdgeInsets)inset;
{
    
    
    if ((self = [super initWithFrame:CGRectZero]))
    {
        _inSet = inset;
        self.font = font;
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    if (self.contentSize.height > MaxHeight)
    {
        return;
    }
    
    if(_height  - (_inSet.top + _inSet.bottom) != self.contentSize.height)
    {
        if([self.delegate respondsToSelector:@selector(textView:heightChanged:)])
        {
            [self.delegate textView:self heightChanged:self.contentSize.height + _inSet.top + _inSet.bottom - _height];
        }
    }
    else
    {
        return;
    }

    _height = self.contentSize.height + _inSet.top + _inSet.bottom;
    
    CGRect r = self.bounds;
    r.origin.y = (CGRectGetHeight(self.superview.frame) - self.contentSize.height) / 2;
    r.origin.x = _inSet.left;
    r.size.width = DeviceW - _inSet.left - _inSet.right;
    r.size.height = self.contentSize.height;
    self.frame = r;
    
    
}


- (void)setFrame:(CGRect)frame
{

    [super setFrame:frame];
    [self getCornerRadius:ScaleH(3) borderColor:[UIColor grayColor] borderWidth:.5 masksToBounds:YES];
    
//    NSLog(@"%f",CGRectGetHeight(frame));
//    NSLog(@"%f",ceilf(self.textContainerInset.top + self.textContainerInset.bottom + self.font.lineHeight));
    
    
    if (CGRectGetHeight(frame) == ceilf(self.textContainerInset.top + self.textContainerInset.bottom + self.font.lineHeight) && !_isShow && ceilf(self.textContainerInset.top + self.textContainerInset.bottom + self.font.lineHeight))
    {
        _isShow = YES;
        if([self.delegate respondsToSelector:@selector(setFrameWithViews:)])
        {
            [self.delegate setFrameWithViews:self];
        }
    }
}



- (void)didMoveToWindow
{
//    if([self.delegate respondsToSelector:@selector(setFrameWithViews:)])
//    {
//        [self.delegate setFrameWithViews:self];
//    }

//    CGRect r = self.bounds;
//    r.origin.y = (CGRectGetHeight(self.superview.frame) - self.contentSize.height) / 2;
//    r.origin.x = _inSet.left;
//    r.size.width = DeviceW - _inSet.left - _inSet.right;
//    r.size.height = self.contentSize.height;
//    self.frame = r;

}

- (void)setContentSize:(CGSize)contentSize
{
    
 

    [super setContentSize:contentSize];
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
