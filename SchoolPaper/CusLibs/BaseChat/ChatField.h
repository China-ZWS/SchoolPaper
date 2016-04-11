//
//  ChatField.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-31.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatField;

@protocol ChatFieldDelegate <UITextViewDelegate>
@optional
- (void)textView:(ChatField *)textView heightChanged:(CGFloat)height;
- (void)viewsFrameChanged:(ChatField *)textView;
- (void)setFrameWithViews:(ChatField *)textView;

@end



@interface ChatField : UITextView
{
    UIEdgeInsets _inSet;
    CGFloat _num;
    CGFloat _height;
}

- (id)initWithFont:(UIFont *)font inset:(UIEdgeInsets)inset;

@property (nonatomic, assign) id<ChatFieldDelegate>delegate;
@end
