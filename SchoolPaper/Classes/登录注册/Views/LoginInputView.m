//
//  LoginInputView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-16.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "LoginInputView.h"

@interface LoginInputView ()
<BaseTextFieldDelegate>

@end

@implementation LoginInputView

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 2 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 2 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];
}

- (id)initWithlogin:(void(^)())login;
{
    if ((self = [super initWithFrame:CGRectMake(ScaleX(20), ScaleY(25), DeviceW - ScaleX(20) * 2, ScaleH(90))])) {
        self.backgroundColor = [UIColor clearColor];
        [self getCornerRadius:5 borderColor:[UIColor lightGrayColor] borderWidth:1.5 masksToBounds:YES];
        _login = login;
        
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    CGFloat const fieldHight = ScaleH(40);
    CGFloat const fieldWidht = CGRectGetWidth(self.frame)  - 20;
    _accountField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 2 - fieldHight) / 2, fieldWidht, fieldHight)];
    _accountField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"body_icon.png"]];
    _accountField.placeholder = @"手机号码";
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    _accountField.delegate = self;
    _accountField.font = Font(17);
//    _accountField.text = @"13360606506"; //正式
//    _accountField.text = @"13411350151";
//    _accountField.text = @"13411350151"; //正式
    _accountField.text = @"13425080808"; //正式
//    _accountField.text = @"13042687435"; // 测试
//    _accountField.text = @"18569530609";
//    _accountField.text = @"13162311844";

    [self addSubview:_accountField];

    _pwdField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, CGRectGetHeight(self.frame) / 2 + (CGRectGetHeight(self.frame) / 2 - fieldHight) / 2, fieldWidht, fieldHight)];
    _pwdField.delegate = self;
    _pwdField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon.png"]];
    _pwdField.placeholder = @"登录密码或动态码";
    _pwdField.font = Font(17);
    _pwdField.secureTextEntry = YES;
    _pwdField.returnKeyType = UIReturnKeyGo;
    [_pwdField setKeyboardType:UIKeyboardTypeDefault];
    _pwdField.text = @"6666";
    [self addSubview:_pwdField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([textField isEqual:_accountField])
    {
        [textField resignFirstResponder];
        [_pwdField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        _login();
    }
    return YES;
}// called when 'return' key pressed. return NO to ignore.



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
