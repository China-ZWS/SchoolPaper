//
//  ForgotPwdInputView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-17.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ForgotPwdInputView.h"

@interface ForgotPwdInputView ()
<BaseTextFieldDelegate>
{
    UIButton *_codeBtn;
    dispatch_source_t _timer;
}
@end

@implementation ForgotPwdInputView

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 2 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 2 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];
}

- (id)initWithNext:(void(^)())next sendMsg:(void(^)())sendMsg;
{
    if ((self = [super initWithFrame:CGRectMake(ScaleX(20), ScaleY(25), DeviceW - ScaleX(20) * 2, ScaleH(90))])) {
        self.backgroundColor = [UIColor clearColor];
        [self getCornerRadius:5 borderColor:[UIColor lightGrayColor] borderWidth:1.5 masksToBounds:YES];
        _next = next;
        _sendMsg = sendMsg;
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    CGFloat const fieldHight = ScaleH(40);
    CGFloat const fieldWidht = CGRectGetWidth(self.frame)  - 20;
    _accountField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 2 - fieldHight) / 2, fieldWidht, fieldHight)];
    _accountField.placeholder = @"手机号码";
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    _accountField.delegate = self;
    _accountField.font = Font(17);
    [self addSubview:_accountField];
    
    _code = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, CGRectGetHeight(self.frame) / 2 + (CGRectGetHeight(self.frame) / 2 - fieldHight) / 2, fieldWidht - ScaleW(80), fieldHight)];
    _code.delegate = self;
    _code.placeholder = @"验证码";
    _code.font = Font(17);
    _code.returnKeyType = UIReturnKeyGo;
    [_code setKeyboardType:UIKeyboardTypeDefault];
    
    [self addSubview:_code];

    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - ScaleW(90), CGRectGetHeight(self.frame) / 2 + (CGRectGetHeight(self.frame) / 2 - ScaleH(30)) / 2, ScaleW(80), ScaleH(30));
    [_codeBtn getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [_codeBtn setTitle:@"发至手机" forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = Font(17);
    _codeBtn.backgroundColor = [UIColor lightGrayColor];
    _codeBtn.userInteractionEnabled = NO;
    [_codeBtn addTarget:self action:@selector(eventWithGetCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_codeBtn];
    
}



- (void)eventWithGetCode
{
    
    
    _sendMsg();
    _codeBtn.backgroundColor = [UIColor lightGrayColor];
    _codeBtn.userInteractionEnabled = NO;
    
    
    UIButton __weak*safeBtn = _codeBtn;
    __block NSInteger timeout = 10; //倒计时时间
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_t __weak safeTimer = _timer;
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(safeTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if ([NSObject isMobile:_accountField.text])
                {
                    safeBtn.userInteractionEnabled = YES;
                    safeBtn.backgroundColor = RGBA(23, 103, 223, 1);
                }
                [safeBtn setTitle:@"发至手机" forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 11;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [safeBtn setTitle:[NSString stringWithFormat:@"重发(%d)", seconds] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
    
}


- (void)stopRunTimer
{
    if ([NSObject isMobile:_accountField.text])
    {
        _codeBtn.userInteractionEnabled = YES;
        _codeBtn.backgroundColor = RGBA(23, 103, 223, 1);
    }
    [_codeBtn setTitle:@"发至手机" forState:UIControlStateNormal];
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([textField isEqual:_accountField])
    {
        [textField resignFirstResponder];
        [_code becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        _next();
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    if ([textField isEqual:_accountField]) {
        if (_timer) {
            if (!dispatch_source_testcancel(_timer)) {
                return  YES;
            }
        }
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        if ([NSObject isMobile:toBeString]) {
            _codeBtn.userInteractionEnabled = YES;
            _codeBtn.backgroundColor = RGBA(23, 103, 223, 1);
        }
        else
        {
            _codeBtn.userInteractionEnabled = NO;
            _codeBtn.backgroundColor = [UIColor lightGrayColor];
        }
    }
    return YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
