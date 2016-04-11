//
//  QAChatView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-31.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatField.h"

typedef NS_ENUM(NSInteger, SupportedTypes)
{
    kDefult = 0,  /// 默认.
    kImage = 1 << 0,///图片
    kSpeech = 1 << 1,///  语音
};


typedef NS_ENUM(NSInteger, BeginShowTypes)
{
    kBeginShow = 0,  /// 开始显示输入框.
    kBeginHiden = 1 << 0,///开始影藏输入框
};


@class ChatInputView;
@protocol ChatInputViewDelegate <NSObject>

@optional
- (BOOL)inputView:(ChatInputView *)inputView inputOfText:(NSString *)text;
- (BOOL)inputView:(ChatInputView *)inputView inputOfImage:(UIImage *)image;
- (BOOL)inputView:(ChatInputView *)inputView inputOfSound:(id )sound time:(NSString *)time;

@end

@interface ChatInputView : UIView
<ChatFieldDelegate>
+ (ChatInputView *)inputWithScrollView:(UIScrollView *)scrollView;
/**
 *  @brief  有参照系的弹出键盘
 *
 *  @param view 参照系
 */
- (void)presentWithKeyboard:(UIView *)view;

/**
 *  @brief  弹出键盘
 */
- (void)presentWithKeyboard;



/**
 *  @brief  第一次input显示类型
 */
@property (nonatomic) BeginShowTypes beginShowType;
@property (nonatomic) SupportedTypes type;
@property (nonatomic, weak) UIViewController *fromController;

@property (nonatomic) UIFont *font;
@property (nonatomic, strong) ChatField *field;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic, assign) id<ChatInputViewDelegate>delegate;
/**
 *  @brief  聊天模式
 */
@property (nonatomic) BOOL hasInstantMessage;
@end
