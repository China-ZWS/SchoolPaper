//
//  BaseAGTextViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-9.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJViewController.h"

@interface BaseAGTextViewController : PJViewController
{
    UITextView *_textView;
}
- (void)lodingWithText:(NSString *)text;
@end
