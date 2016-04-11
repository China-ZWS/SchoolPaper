//
//  ResetPwdViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-17.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "ResetPwdInputView.h"

@interface ResetPwdViewController ()
{
    ResetPwdInputView *_inputView;
    NSDictionary *_datas;
}
@end

@implementation ResetPwdViewController

- (id)initWithDatas:(id)datas;
{
    if ((self = [super init])) {
        _datas = datas;
        [self.navigationItem setNewTitle:@"重置密码"];
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
    ResetPwdViewController __weak*safeSelf = self;
    _inputView =  [[ResetPwdInputView alloc] initWithSuccess:^()
                   {
                       [safeSelf eventWithSuccess];
                   }];
    [self.view addSubview:_inputView];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((DeviceW - CGRectGetWidth(_inputView.frame)) / 2, CGRectGetMaxY(_inputView.frame) + ScaleH(20), CGRectGetWidth(_inputView.frame), ScaleH(50));
    [nextBtn getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [nextBtn setTitle:@"确 定" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = Font(20);
    nextBtn.backgroundColor = RGBA(23, 103, 223, 1);
    [nextBtn addTarget:self action:@selector(eventWithFinish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}

- (void)eventWithFinish
{
 
    if (!_inputView.pwdField.text.length || !_inputView.rePwdField.text.length) {
        [self makeToast:@"请输入完整"];
        return;
    }
    if (![_inputView.pwdField.text isEqualToString:_inputView.rePwdField.text]) {
        [self makeToast:@"2次密码一致"];
        return;
    }
    
    [MBProgressHUD showMessag:@"修改中..." toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = _datas[@"mobile"];
    params[@"valid_code"] = _datas[@"code"];
    params[@"password"] = _inputView.pwdField.text;
    _connection = [BaseModel POST:@"resetpassword" parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"修改成功"];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [self back];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       [self.view makeToast:msg];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];

}

- (void)eventWithSuccess
{
    
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
