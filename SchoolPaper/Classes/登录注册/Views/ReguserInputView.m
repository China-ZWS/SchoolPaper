//
//  ReguserInputView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-17.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ReguserInputView.h"

@interface ReguserInputView ()
<BaseTextFieldDelegate>
{
    UIButton *_codeBtn;
    dispatch_source_t _timer;
    
}
@end

@implementation ReguserInputView

- (void)dealloc
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 4 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 4 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];
    
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 2 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 2 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];

    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 4 * 3 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 4 * 3 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];
}


- (id)initWithReguser:(void(^)())reguser sendMsg:(void(^)())sendMsg;
{
    if ((self = [super initWithFrame:CGRectMake(ScaleX(20), ScaleY(25), DeviceW - ScaleX(20) * 2, ScaleH(180))]))
    {
        self.backgroundColor = [UIColor clearColor];
        _reguser = reguser;
        _sendMsg = sendMsg;
        [self getCornerRadius:5 borderColor:[UIColor lightGrayColor] borderWidth:1.5 masksToBounds:YES];
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    CGFloat const fieldHight = ScaleH(40);
    CGFloat const fieldWidht = CGRectGetWidth(self.frame)  - 20;
    
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - ScaleW(90), CGRectGetHeight(self.frame) / 4 + (CGRectGetHeight(self.frame) / 4 - ScaleH(30)) / 2, ScaleW(80), ScaleH(30));
    [_codeBtn getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [_codeBtn setTitle:@"发至手机" forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = Font(17);
    _codeBtn.backgroundColor = [UIColor lightGrayColor];
    _codeBtn.userInteractionEnabled = NO;
    [_codeBtn addTarget:self action:@selector(eventWithGetCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_codeBtn];
    
    _accountField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 4 - fieldHight) / 2, fieldWidht , fieldHight)];
    _accountField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone_num.png"]];
    _accountField.placeholder = @"手机号码";
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    _accountField.delegate = self;
    _accountField.font = Font(17);
    [self addSubview:_accountField];
    
    _codeField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 4 - fieldHight) / 2 + CGRectGetHeight(self.frame) / 4, fieldWidht -  CGRectGetWidth(_codeBtn.frame), fieldHight)];
    _codeField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sendphone_icon.png"]];
    _codeField.placeholder = @"手机验证码";
    _pwdField.returnKeyType = UIReturnKeyNext;
    _codeField.delegate = self;
    _codeField.font = Font(17);
    [self addSubview:_codeField];

    _pwdField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, CGRectGetHeight(self.frame) / 2 + (CGRectGetHeight(self.frame) / 4 - fieldHight) / 2, fieldWidht, fieldHight)];
    _pwdField.delegate = self;
    _pwdField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon.png"]];
    _pwdField.placeholder = @"设置密码";
    _pwdField.font = Font(17);
    _pwdField.secureTextEntry = YES;
    _pwdField.returnKeyType = UIReturnKeyNext;
    [_pwdField setKeyboardType:UIKeyboardTypeDefault];
    [self addSubview:_pwdField];

    _rePwdField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, CGRectGetHeight(self.frame) / 4 * 3 + (CGRectGetHeight(self.frame) / 4 - fieldHight) / 2, fieldWidht, fieldHight)];
    _rePwdField.delegate = self;
    _rePwdField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkpassword_icon.png"]];
    _rePwdField.placeholder = @"确认密码";
    _rePwdField.font = Font(17);
    _rePwdField.secureTextEntry = YES;
    _rePwdField.returnKeyType = UIReturnKeyGo;
    [_rePwdField setKeyboardType:UIKeyboardTypeDefault];
    [self addSubview:_rePwdField];
    
}


- (void)eventWithGetCode
{
    

    _sendMsg();
    _codeBtn.backgroundColor = [UIColor lightGrayColor];
    _codeBtn.userInteractionEnabled = NO;

    
    UIButton __weak*safeBtn = _codeBtn;
    __block NSInteger timeout = 60; //倒计时时间
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
            int seconds = timeout % 61;
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
        [_codeField becomeFirstResponder];
    }
    else if ([textField isEqual:_codeField])
    {
        [textField resignFirstResponder];
        [_pwdField becomeFirstResponder];
    }
    else if ([textField isEqual:_pwdField])
    {
        [textField resignFirstResponder];
        [_rePwdField becomeFirstResponder];
    }
    else if ([textField isEqual:_rePwdField])
    {
        [textField resignFirstResponder];
        _reguser();
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
