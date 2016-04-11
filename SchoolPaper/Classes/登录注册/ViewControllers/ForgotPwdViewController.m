//
//  ForgotPwdViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-17.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "ForgotPwdInputView.h"
#import "ResetPwdViewController.h"

@interface ForgotPwdViewController ()
{
    ForgotPwdInputView *_inputView;
}
@end

@implementation ForgotPwdViewController

- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"重置密码"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ForgotPwdViewController __weak*safeSelf = self;
    _inputView =  [[ForgotPwdInputView alloc] initWithNext:^()
                   {
                       [safeSelf eventWithNext];
                   } sendMsg:^()
                   {
                       [safeSelf sendMsg];
                   }
];
    [self.view addSubview:_inputView];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((DeviceW - CGRectGetWidth(_inputView.frame)) / 2, CGRectGetMaxY(_inputView.frame) + ScaleH(20), CGRectGetWidth(_inputView.frame), ScaleH(50));
    [nextBtn getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = Font(20);
    nextBtn.backgroundColor = RGBA(23, 103, 223, 1);
    [nextBtn addTarget:self action:@selector(eventWithNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}

- (void)eventWithNext
{
    if (![NSObject isMobile:_inputView.accountField.text])
    {
        [self makeToast:@"请输入正确的手机号码"];
        return;
    }
    else if (!_inputView.code.text.length) {
        [self makeToast:@"请输入验证码"];
        return;
    }
    [self pushViewController:[[ResetPwdViewController alloc] initWithDatas:@{@"mobile":_inputView.accountField.text, @"code":_inputView.code.text}] ];
}

- (void)sendMsg
{
    [self.view endEditing:YES];
    if (![NSObject isMobileNumber:_inputView.accountField.text])return;
    
    [MBProgressHUD showMessag:@"短信发送中..." toView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = _inputView.accountField.text;
    params[@"type"] = @"FORGETPWD";

    _connection = [BaseModel POST:getvalid parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"发送成功,请注意查收"];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [_inputView stopRunTimer];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
