//
//  ResetPwdInputView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-17.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ResetPwdInputView.h"

@interface ResetPwdInputView ()
<BaseTextFieldDelegate>

@end

@implementation ResetPwdInputView

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 2 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 2 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];
}

- (id)initWithSuccess:(void(^)())success;
{
    if ((self = [super initWithFrame:CGRectMake(ScaleX(20), ScaleY(25), DeviceW - ScaleX(20) * 2, ScaleH(90))])) {
        self.backgroundColor = [UIColor clearColor];
        [self getCornerRadius:5 borderColor:[UIColor lightGrayColor] borderWidth:1.5 masksToBounds:YES];
        _success = success;
        [self layoutViews];
    }
    return self;
    
}

- (void)layoutViews
{
    CGFloat const fieldHight = ScaleH(40);
    CGFloat const fieldWidht = CGRectGetWidth(self.frame)  - 20;
    _pwdField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 2 - fieldHight) / 2, fieldWidht, fieldHight)];
    _pwdField.placeholder = @"设置密码";
    _rePwdField.secureTextEntry = YES;
    _pwdField.delegate = self;
    _pwdField.font = Font(17);
    [self addSubview:_pwdField];
    
    _rePwdField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, CGRectGetHeight(self.frame) / 2 + (CGRectGetHeight(self.frame) / 2 - fieldHight) / 2, fieldWidht, fieldHight)];
    _rePwdField.delegate = self;
    _rePwdField.placeholder = @"确认密码";
    _rePwdField.font = Font(17);
    _rePwdField.secureTextEntry = YES;
    _rePwdField.returnKeyType = UIReturnKeyGo;
    [_rePwdField setKeyboardType:UIKeyboardTypeDefault];
    [self addSubview:_rePwdField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([textField isEqual:_pwdField])
    {
        [textField resignFirstResponder];
        [_rePwdField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        _success();
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
