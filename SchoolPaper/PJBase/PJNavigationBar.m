//
//  PJNavigationBar.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJNavigationBar.h"

@implementation PJNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.barTintColor = RGBA(23, 103, 223, 1);
        self.translucent = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
