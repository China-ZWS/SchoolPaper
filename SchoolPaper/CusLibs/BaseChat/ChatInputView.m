//
//  QAChatView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-31.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//



#import "ChatInputView.h"
#import "BasePhotoPickerManager.h"
#import "VoiceManager.h"
#import "XHVoiceRecordHUD.h"
#import "Category.h"
#import "Device.h"
#import "Header.h"

typedef NS_ENUM(NSInteger, CurrentStatus)
{
    kCurrentText = 0,  /// 当前文字.
    kCurrentIamge = 1 << 0,/// 当前图片
    kCurrentSpeech = 1 << 1,/// 当前语音
};


@interface ChatInputView ()
@property (nonatomic, strong) UIButton *soundBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UIButton *recordingBtn;
@property (nonatomic) CurrentStatus currentStatus;
@property (nonatomic, strong) VoiceManager *vm;
@property (nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
@end

@implementation ChatInputView
{
    BOOL animateHeightChange;
    NSTimeInterval _animationDuration;
    UIViewAnimationCurve _animationCurve;
    CGRect _keyboardEndFrame;

    UIEdgeInsets _inset;
    BOOL _hasInitInset;
    BOOL _hasKeyboardShow;  // 键盘是否弹出
    CGRect _frameOfReference; // 参照坐标
    CGPoint _offsetOfIdentity; //原始坐标
}

- (void)dealloc
{
    [self deleteNotificationCenter];
}

#pragma mark - 初始化输入框
- (ChatField *)field
{
    if (!_field) {
        _field = [[ChatField alloc] initWithFont:_font inset:_inset];
        _field.delegate = self;
    }
    return _field;
}

#pragma mark - 初始化图片按钮
- (UIButton *)imageBtn
{
    if (!_imageBtn)
    {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_imageBtn getCornerRadius:ScaleH(3) borderColor:[UIColor clearColor] borderWidth:1.0 masksToBounds:YES];
        [_imageBtn addTarget:self action:@selector(eventWithImage) forControlEvents:UIControlEventTouchUpInside];
        [_imageBtn setBackgroundImage:[UIImage imageNamed:@"tj_n.png"] forState:UIControlStateNormal];
    }
    return _imageBtn;
}

#pragma mark - 初始化声音按钮
- (UIButton *)soundBtn
{
    if (!_soundBtn)
    {
        _soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundBtn getCornerRadius:ScaleH(3) borderColor:[UIColor clearColor] borderWidth:1.0 masksToBounds:YES];
        [_soundBtn addTarget:self action:@selector(eventWithSound) forControlEvents:UIControlEventTouchUpInside];
        [_soundBtn setBackgroundImage:[UIImage imageNamed:@"dj_n.png"] forState:UIControlStateNormal];
        [_soundBtn setBackgroundImage:[UIImage imageNamed:@"text_icon.png"] forState:UIControlStateSelected];

    }
    return _soundBtn;
}

#pragma mark - 初始化发送按钮
- (UIButton *)sendBtn
{
    if (!_sendBtn)
    {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn getCornerRadius:ScaleH(3) borderColor:[UIColor clearColor] borderWidth:1.0 masksToBounds:YES];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = Font(20);
        _sendBtn.userInteractionEnabled = NO;
        _sendBtn.backgroundColor = [UIColor lightGrayColor];
        [_sendBtn addTarget:self action:@selector(eventWithSend) forControlEvents:UIControlEventTouchUpInside];
   
    }
    return _sendBtn;
}

- (UIButton *)recordingBtn
{
    if (!_recordingBtn) {
        _recordingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordingBtn getCornerRadius:ScaleH(3) borderColor:[UIColor grayColor] borderWidth:.5 masksToBounds:YES];
        [_recordingBtn setTitle:@"按住录音" forState:UIControlStateNormal];
        [_recordingBtn setTitle:@"正在录音..." forState:UIControlStateHighlighted];
        _recordingBtn.hidden = YES;
        _recordingBtn.titleLabel.font = Font(20);
        [_recordingBtn setTitleColor:CustomGray forState:UIControlStateNormal];
        _recordingBtn.backgroundColor = [UIColor whiteColor];
        
        
        
        
        [_recordingBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [_recordingBtn addTarget:self action:@selector(finishRecorded) forControlEvents:UIControlEventTouchUpInside];
        [_recordingBtn addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchUpOutside];
        [_recordingBtn addTarget:self action:@selector(resumeRecord) forControlEvents:UIControlEventTouchDragExit];
        [_recordingBtn addTarget:self action:@selector(pauseRecord) forControlEvents:UIControlEventTouchDragEnter];


    }
    return _recordingBtn;
}

#pragma mark - 对整个InputView的subviews的初始化
- (void)layoutViews
{

    if (_type == kDefult)
    {
        _inset = UIEdgeInsetsMake(ScaleY(8), ScaleX(10), ScaleH(8), ScaleW(100));
        [self addSubview:self.sendBtn];
        [self addSubview:self.field];
        _field.returnKeyType = UIReturnKeyDone;
    }
    else if (_type == (kDefult | kImage))
    {
        _inset = UIEdgeInsetsMake(ScaleY(8), ScaleX(60), ScaleH(8), ScaleW(10));
        [self addSubview:self.field];
    }
    else if (_type == (kDefult | kImage | kSpeech))
    {
        _inset = UIEdgeInsetsMake(ScaleY(8), ScaleX(60), ScaleH(8), ScaleW(60));
        [self addSubview:self.soundBtn];
        [self addSubview:self.imageBtn];
        [self addSubview:self.field];
        [self addSubview:self.recordingBtn];
        _field.returnKeyType = UIReturnKeySend;
    }
    
    
}


#pragma mark - 初始化InputView
+ (ChatInputView *)inputWithScrollView:(UIScrollView *)scrollView;
{
    ChatInputView *v = [ChatInputView new];
    v.font = Font(17);
    v.type = kDefult;
    v.beginShowType = kBeginShow;
    v.scrollView = scrollView;
    v.currentStatus = kCurrentText;
    return v;
}


#pragma mark - 构造函数
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, DeviceH, DeviceW, 0)]))
    {
        self.backgroundColor = RGBA(230, 230, 230, 1);
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addNotificationCenter];
    }
    return self;
}


- (void)willMoveToWindow:(UIWindow *)newWindow;
{
    [super willMoveToWindow:newWindow];
//    if (!self.window)
//    {
//        [self addNotificationCenter];
//    }
//    else
//    {
//        [self deleteNotificationCenter];
//    }
}








- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutViews];
    
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}


#pragma mark - 初始化通知
-(void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deleteNotificationCenter;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘调用的事件
- (void)keyboardWasShow:(NSNotification *)notification
{
    if (self.window)
    {
        [self moveTextViewForKeyboard:notification up:YES];
    }
}

#pragma mark - 键盘消失调用的事件
-(void)keyboardWasHidden:(NSNotification *)notification
{
    if (self.window)
    {
        [self moveTextViewForKeyboard:notification up:NO];
    }
}




- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up
{

    _hasKeyboardShow = up;
    NSDictionary* userInfo = [aNotification userInfo];
    // Get animation info from userInfo
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardEndFrame];
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:_animationDuration];
    [UIView setAnimationCurve:_animationCurve];
    if (up)
    {
        switch (_beginShowType)
        {
            case kBeginShow:
                self.transform = CGAffineTransformMakeTranslation(0, -_keyboardEndFrame.size.height);
                break;
            case kBeginHiden:
            {
                CGRect keyRect = [self.window convertRect:_keyboardEndFrame toView:self.superview];
                self.transform=CGAffineTransformMakeTranslation(0, -_keyboardEndFrame.size.height);

                CGFloat insetHeight = CGRectGetMaxY(self.frame) - CGRectGetMinY(keyRect);
                CGRect rect = self.frame;
                rect.origin.y -= insetHeight;
                self.frame = rect;
                

            }
                break;
            default:
                break;
        }

    }
    else
    {
        switch (_beginShowType)
        {
            case kBeginShow:
                self.transform = CGAffineTransformIdentity;
               
                  break;
            case kBeginHiden:
            {
                
                self.transform = CGAffineTransformIdentity;

                CGFloat insetHeight = CGRectGetMaxY(self.superview.frame) - CGRectGetMinY(self.frame);
                CGRect rect = self.frame;
                rect.origin.y += insetHeight;
                self.frame = rect;
                

            }
                break;
            default:
                break;
        }
    }
    

    [UIView commitAnimations];
    [self changeOffsetForKeyboard];


}


#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length)
    {
        _sendBtn.userInteractionEnabled = YES;
        _sendBtn.backgroundColor = CustomBlue;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [self eventWithSend];
        return NO;
    }else {
        if ([textView.text length] <= 200) {//判断字符个数
            return YES;
        }
    }
    return NO;
}




#pragma mark - ChatFieldDelegate
- (void)setFrameWithViews:(ChatField *)textView
{
   
    [self getShadowOffset:CGSizeMake(0, -1) shadowRadius:ScaleW(2) shadowColor:CustomBlack shadowOpacity:.6 cornerRadius:0 masksToBounds:NO];
    if (_type == kDefult)
    {
        if (_sendBtn)
        {
            _sendBtn.frame = CGRectMake(DeviceW - ScaleW(90), (CGRectGetHeight(self.frame) - CGRectGetHeight(textView.frame)) / 2, ScaleW(80), CGRectGetHeight(textView.frame));
        }
    }
    else if (_type == (kImage | kSpeech))
    {
        if (_soundBtn)
        {
            _soundBtn.frame = CGRectMake((_inset.left - CGRectGetHeight(textView.frame)) / 2, (CGRectGetHeight(self.frame) - CGRectGetHeight(textView.frame)) / 2, CGRectGetHeight(textView.frame), CGRectGetHeight(textView.frame));
        }
        if (_imageBtn)
        {
            _imageBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - _inset.right + (_inset.right - CGRectGetHeight(textView.frame)) / 2, (CGRectGetHeight(self.frame) - CGRectGetHeight(textView.frame)) / 2, CGRectGetHeight(textView.frame), CGRectGetHeight(textView.frame));
        }
    }
   
    switch (_beginShowType)
    {
    
        case kBeginShow:
        {
            CGRect scrollViewRect = _scrollView.frame;
            scrollViewRect.size.height -= CGRectGetHeight(self.frame);
            _scrollView.frame = scrollViewRect;
            
            if (_hasInstantMessage)
            {
                if (_scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame) > 0)
                {
                    [_scrollView setContentOffset:CGPointMake(CGRectGetMinX(_scrollView.frame), _scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame)) animated:NO];
                }
            }
        }
            break;
        case kBeginHiden:
        {
            CGRect rect = self.frame;
            rect.origin.y = CGRectGetHeight(self.superview.frame);
            self.frame = rect;
        }
            break;
        default:
            break;
    }

}

- (void)textView:(ChatField *)textView heightChanged:(CGFloat)height;
{
    CGRect rect = self.frame;
     rect.origin.y -= height;
    rect.size.height += height;
    self.frame = rect;
}


#pragma mark - 因为改变contentOffset的偏移量
- (void)changeOffsetForKeyboard
{
    
    if (_hasInstantMessage)
    {
        if (_hasKeyboardShow)
        {
            CGFloat inset = 0;
            if (CGRectGetHeight(_scrollView.frame) - _scrollView.contentSize.height >0 )
            {
                inset = CGRectGetHeight(_scrollView.frame) - _scrollView.contentSize.height;
                if (inset > _keyboardEndFrame.size.height)
                {
                    inset = _keyboardEndFrame.size.height;
                }
            }
            
            _scrollView.transform = CGAffineTransformMakeTranslation(0, -_keyboardEndFrame.size.height + inset);
        }
        else
        {
            _scrollView.transform = CGAffineTransformIdentity;
        }
    }
    else
    {
        if (_hasKeyboardShow) //键盘弹出
        {
            if (CGRectGetMaxY(_frameOfReference) - CGRectGetMinY(self.frame) > 0) // 被遮挡
            {
                CGPoint bottomOffset = CGPointMake(_scrollView.contentOffset.x,CGRectGetMaxY(_frameOfReference) - CGRectGetMinY(self.frame));
                
                
                [_scrollView setContentOffset:bottomOffset animated:YES];
            }
        }
        else
        { // 键盘收起
            
            if (!CGPointEqualToPoint(_scrollView.contentOffset , _offsetOfIdentity))
            {
                // 如果键盘收起前，contentOffset有落差，就恢复之前的contentOffset
                [_scrollView setContentOffset:_offsetOfIdentity animated:YES];
            }
        }
    }
}



#pragma mark - 发送纯文本事件
- (void)eventWithSend
{
   
    if ([_delegate respondsToSelector:@selector(inputView:inputOfText:)] && [_delegate conformsToProtocol:@protocol(ChatInputViewDelegate)])
    {
        if ([_delegate inputView:self inputOfText:_field.text])
        {
            _field.text = @"";
            
            
            if (_hasInstantMessage)
            {

                if (_scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame) > 0)
                {
                    [_scrollView setContentOffset:CGPointMake(CGRectGetMinX(_scrollView.frame), _scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame)) animated:YES];
                }
                else
                {
                    CGFloat inset = 0;
                    if (CGRectGetHeight(_scrollView.frame) - _scrollView.contentSize.height >0 )
                    {
                        inset = CGRectGetHeight(_scrollView.frame) - _scrollView.contentSize.height;
                        if (inset > _keyboardEndFrame.size.height)
                        {
                            inset = _keyboardEndFrame.size.height;
                        }
                    }
                    
                    _scrollView.transform = CGAffineTransformMakeTranslation(0, -_keyboardEndFrame.size.height + inset);
                }
            }
        };
    }
    
}

#pragma mark - 发图片
- (void)eventWithImage
{
    _currentStatus = kCurrentSpeech;
    
    [[BasePhotoPickerManager shared] showActionSheetInView:_fromController.view fromController:_fromController completion:^(UIImage *img)
     {
         if ([_delegate respondsToSelector:@selector(inputView:inputOfImage:)] && [_delegate conformsToProtocol:@protocol(ChatInputViewDelegate)])
         {
             if ([_delegate inputView:self inputOfImage:img])
             {
                 if (_hasInstantMessage)
                 {
                     
                     if (_scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame) > 0)
                     {
                         [_scrollView setContentOffset:CGPointMake(CGRectGetMinX(_scrollView.frame), _scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame)) animated:YES];
                     }
                     else
                     {
                         CGFloat inset = 0;
                         if (CGRectGetHeight(_scrollView.frame) - _scrollView.contentSize.height >0 )
                         {
                             inset = CGRectGetHeight(_scrollView.frame) - _scrollView.contentSize.height;
                             if (inset > _keyboardEndFrame.size.height)
                             {
                                 inset = _keyboardEndFrame.size.height;
                             }
                         }
                         
                         _scrollView.transform = CGAffineTransformMakeTranslation(0, -_keyboardEndFrame.size.height + inset);
                     }
                 }

             }
         }
     }
                                               cancelBlock:^()
     {
         [_fromController.view makeToast:@"已取消"];
     }];

}

#pragma  mark - 发音频
- (void)eventWithSound
{
    
    _currentStatus = kCurrentIamge;
    _soundBtn.selected = !_soundBtn.selected;
   
    if (_soundBtn.selected)
    {
        [_field resignFirstResponder];
        _recordingBtn.frame = _field.frame;
        _field.hidden = YES;
        _recordingBtn.hidden = NO;
    }
    else
    {
        [_field becomeFirstResponder];
        _field.hidden = NO;
        _recordingBtn.frame = CGRectZero;
        _recordingBtn.hidden = YES;
    }
}

#pragma mark - 有参照系的弹出键盘
- (void)presentWithKeyboard:(UIView *)view
{
    UITableViewCell *cell = nil;
    for (UIView* next = [view superview]; next; next =
         next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableViewCell
                                          class]])
        {
            cell = (UITableViewCell *)nextResponder;
            break;
        }
    }
    _frameOfReference = [_scrollView convertRect:cell.frame toView:_scrollView];
//    _frameOfReference = cell.frame;
    
    _offsetOfIdentity = _scrollView.contentOffset;
    [_field becomeFirstResponder];
}

#pragma mark - 弹出键盘
- (void)presentWithKeyboard
{
    _frameOfReference.origin = _scrollView.frame.origin;
    _frameOfReference.size = _scrollView.contentSize;
    _offsetOfIdentity = _scrollView.contentOffset;
    
    [_field becomeFirstResponder];
}




- (VoiceManager *)vm
{
    if (!_vm)
    {
        WEAKSELF;
        _vm = [VoiceManager shared];
        _vm.maxTimeStopRecorderCompletion = ^{
            DLog(@"已经达到最大限制时间了，进入下一步的提示");
            [weakSelf finishRecorded];
        };
        _vm.peakPowerForChannel = ^(float peakPowerForChannel)
        {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _vm.maxRecordTime = 60;
    }
    return _vm;
}


- (XHVoiceRecordHUD *)voiceRecordHUD
{
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}



#pragma mark - 按下录音按钮开始录音
- (void)startRecord
{
    
    _recordingBtn.highlighted = YES;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    
    [self.voiceRecordHUD startRecordingHUDAtView:[UIApplication sharedApplication].keyWindow];
    [self.vm startRecordingWithPath:date startRecorderCompletion:^{
    }];
    

}

#pragma mark - 松开手指完成录音
- (void)finishRecorded
{
    
    WEAKSELF;
//    if (!_hasOverMinDate) {
//        
//        [self.voiceRecordHUD resaueRecord];
//
//        return;
//    }
//    _hasOverMinDate = NO;
    _recordingBtn.highlighted = NO;
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished)
    {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.vm stopRecordingWithStopRecorderCompletion:^(NSString *recorderPath, NSString *time)
    {
        if ([_delegate respondsToSelector:@selector(inputView:inputOfSound:time:)] && [_delegate conformsToProtocol:@protocol(ChatInputViewDelegate)])
        {
            if ([_delegate inputView:self inputOfSound:recorderPath time:time])
            {
                if (_hasInstantMessage)
                {
                    
                    if (_scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame) > 0)
                    {
                        [_scrollView setContentOffset:CGPointMake(CGRectGetMinX(_scrollView.frame), _scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame)) animated:YES];
                    }
                    else
                    {
                        CGFloat inset = 0;
                        if (CGRectGetHeight(_scrollView.frame) - _scrollView.contentSize.height >0 )
                        {
                            inset = CGRectGetHeight(_scrollView.frame) - _scrollView.contentSize.height;
                            if (inset > _keyboardEndFrame.size.height)
                            {
                                inset = _keyboardEndFrame.size.height;
                            }
                        }
                        
                        _scrollView.transform = CGAffineTransformMakeTranslation(0, -_keyboardEndFrame.size.height + inset);
                    }
                }

            }

            
        }
        
    }
     failure:^()
     {
         [self.superview  makeToast:@"时间太短"];
     }];
}

#pragma mark - 手指向上滑动取消录音
- (void)cancelRecord
{
    WEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.vm cancelledDeleteWithCompletion:^{
        
    }];
}

#pragma mark - 当手指离开按钮的范围内时，主要为了通知外部的HUD
- (void)resumeRecord
{
    [self.voiceRecordHUD resaueRecord];
}

#pragma mark - 当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}


@end
