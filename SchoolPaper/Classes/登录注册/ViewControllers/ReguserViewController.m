//
//  ReguserViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-16.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ReguserViewController.h"
#import "ReguserInputView.h"

@interface ReguserViewController ()
{
    ReguserInputView *_inputView;
}
@end

@implementation ReguserViewController

- (id)initWithSuccess:(void(^)())success;
{
    if ((self = [super init])) {
        _success = success;
        [self.navigationItem setNewTitle:@"注 册"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ReguserViewController __weak*safeSelf = self;
    _inputView = [[ReguserInputView alloc] initWithReguser:^()
                  {
                      [safeSelf eventWithReguser];
                  }
                                                   sendMsg:^()
                  {
                      [safeSelf sendMsg];
                  }
                  ];
    [self.view addSubview:_inputView];
    
    UIButton *reguserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reguserBtn.frame = CGRectMake((DeviceW - CGRectGetWidth(_inputView.frame)) / 2, CGRectGetMaxY(_inputView.frame) + ScaleH(20), CGRectGetWidth(_inputView.frame), ScaleH(50));
    [reguserBtn getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [reguserBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    reguserBtn.titleLabel.font = Font(20);
    reguserBtn.backgroundColor = RGBA(23, 103, 223, 1);
    [reguserBtn addTarget:self action:@selector(eventWithReguser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reguserBtn];
    
    UILabel *mark = [[UILabel alloc] initWithFrame:CGRectMake((DeviceW - CGRectGetWidth(reguserBtn.frame)) / 2, CGRectGetMaxY(reguserBtn.frame) + ScaleH(18), CGRectGetWidth(reguserBtn.frame), 0)];
    mark.textColor = [UIColor lightGrayColor];
    mark.font = Font(16);
    mark.numberOfLines = 0;
    mark.text = @"点击“立即注册”,即表示您同意并愿意遵守成长超市用户协议和服务条款";
    [mark sizeToFit];
    [self.view addSubview:mark];
}

#pragma mark - 点击注册
- (void)eventWithReguser
{
    
    [self.view endEditing:YES];
    if (!_inputView.accountField.text.length) {
        [self makeToast:@"请输入手机号码"];
        return;
    }
    if (![NSObject isMobile:_inputView.accountField.text])
    {
        [self makeToast:@"请输入正确的手机号码"];
        return;
    }
    if (!_inputView.codeField.text.length) {
        [self makeToast:@"请输入手机验证码"];
        return;
    }
    if (!_inputView.pwdField.text.length) {
        [self makeToast:@"请输入密码"];
    }
    if (!_inputView.rePwdField.text.length) {
        [self makeToast:@"请输入确认密码"];
    }

    
    [MBProgressHUD showMessag:@"注册中..." toView:self.view];
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"mobile"] = _inputView.accountField.text;
    params[@"validnumber"] = _inputView.codeField.text;
    params[@"password"] = _inputView.accountField.text;
    [BaseModel POST:reguser parameter:params   class:[BaseModel class]
            success:^(id data)
     {
         _success();
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     }
            failure:^(NSString *msg, NSString *state)
     {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.view makeToast:msg];
     }];
    

}

#pragma mark - 发送验证码
- (void)sendMsg
{
    
    
    [self.view endEditing:YES];
    if (![NSObject isMobileNumber:_inputView.accountField.text])return;
    
    [MBProgressHUD showMessag:@"短信发送中..." toView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = _inputView.accountField.text;
    params[@"type"] = @"REGISTER";
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
