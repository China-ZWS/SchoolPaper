//
//  LoginViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-16.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "LoginViewController.h"
#import "ReguserViewController.h"
#import "LoginInputView.h"
#import "ReguserViewController.h"
#import "ForgotPwdViewController.h"
#import "BasePickerView.h"

#import "APService.h"

@interface LoginViewController ()
<UIPickerViewDataSource, UIPickerViewDelegate, BasePickerViewDelegate>
{
    LoginInputView *_inputView;
    UIPickerView *_picker;
    NSArray *_datas;
}
@end

@implementation LoginViewController

- (id)initWithLoginSuccess:(SuccessLoginBlock)success;
{
    if ((self = [super initWithLoginSuccess:success]))
    {
        [self.navigationItem setNewTitle:@"登 录"];
        [self.navigationItem setRightItemWithTarget:self title:@"注 册" action:@selector(reguser) image:nil];
    }
    return self;
}




- (void)reguser
{
    [self pushViewController:[[ReguserViewController alloc] initWithSuccess:^()
                              {
                                  [self.view makeToast:@"注册成功"];
                              }]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
// 登录输入框
    LoginViewController __weak*safeSelf = self;
   _inputView =  [[LoginInputView alloc] initWithlogin:^()
    {
        [safeSelf gotoLoging];
    }];
    [self.view addSubview:_inputView];
    
    
    
//    创建2个按钮；
    UIButton *getdynapwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getdynapwdBtn.frame = CGRectMake(CGRectGetMinX(_inputView.frame), CGRectGetMaxY(_inputView.frame) + ScaleH(20), CGRectGetWidth(_inputView.frame) / 2 - ScaleW(15), ScaleH(50));
    getdynapwdBtn.backgroundColor = CustomBlue;
    [getdynapwdBtn getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(2) shadowColor:[UIColor blackColor] shadowOpacity:.6 cornerRadius:5 masksToBounds:NO];
    [getdynapwdBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
    getdynapwdBtn.titleLabel.font = Font(20);
    [getdynapwdBtn addTarget:self action:@selector(eventWithGetCode) forControlEvents:UIControlEventTouchUpInside];

    loginBtn.frame = CGRectMake(CGRectGetMidX(_inputView.frame) + ScaleW(15), CGRectGetMaxY(_inputView.frame) + ScaleH(20), CGRectGetWidth(_inputView.frame) / 2 - ScaleW(15), ScaleH(50));
    loginBtn.backgroundColor = RGBA(23, 101, 228, 1);
    [loginBtn getShadowOffset:CGSizeMake(1, 1) shadowRadius:ScaleW(2) shadowColor:[UIColor blackColor] shadowOpacity:.6 cornerRadius:5 masksToBounds:NO];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font(20);
    [loginBtn addTarget:self action:@selector(gotoLoging) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:getdynapwdBtn];
    [self.view addSubview:loginBtn];

    
    UILabel *mark = [[UILabel alloc] initWithFrame:CGRectMake((DeviceW - CGRectGetWidth(_inputView.frame)) / 2, CGRectGetMaxY(getdynapwdBtn.frame) + ScaleH(18), CGRectGetWidth(_inputView.frame), 0)];
    mark.textColor = [UIColor lightGrayColor];
    mark.font = Font(17);
    mark.numberOfLines = 0;
    mark.text = @"和教育用户请使用和教育用户名及密码进行登录即可";
    [mark sizeToFit];
    [self.view addSubview:mark];

    UIButton *fogotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fogotBtn.frame = CGRectMake(CGRectGetMaxX(_inputView.frame) - ScaleW(80), CGRectGetMaxY(mark.frame) + ScaleH(5), ScaleW(80), 30);
    fogotBtn.backgroundColor = [UIColor clearColor];
    [fogotBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [fogotBtn setTitleColor:RGBA(23, 103, 223, 1)  forState:UIControlStateNormal];
    fogotBtn.titleLabel.font = Font(15);
    [fogotBtn addTarget:self action:@selector(eventWithGotoForgotPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fogotBtn];
    
}





- (void)eventWithGotoForgotPwd
{
    [self pushViewController:[ForgotPwdViewController new]];
}

- (void)eventWithGetCode
{
    [self.view endEditing:YES];
    [MBProgressHUD showMessag:@"短信发送中..." toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = _inputView.accountField.text;
    params[@"type"] = @"DYNAPWD";
    
   [BaseModel POST:getvalid parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"发送成功,请注意查收"];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       

                       [self.view makeToast:msg];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];

}

- (void)gotoLoging
{
 

    [MBProgressHUD showMessag:Loding_text1 toView:self.view];


    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"mobile"] = _inputView.accountField.text;
    params[@"password"] = _inputView.pwdField.text;
    _connection = [BaseModel POST:login parameter:params   class:[BaseModel class]
            success:^(id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if ([data[@"data"] count] > 1)
         {
             _datas = data[@"data"];
            [BasePickerView setDatas:data[@"data"] showToolBar:YES  delegate:self];
             return ;
         }        
         [Infomation writeInfo:data[@"data"][0]];
         [APService setTags:[NSSet setWithObjects:[Base64 textFromBase64String:data[@"data"][0][@"classTag"]],nil] alias:params[@"mobile"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];

         _successLogin(self,YES);
     }
            failure:^(NSString *msg, NSString *state)
     {
         [self.view makeToast:msg];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    

}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)toolBardoneClick:(BasePickerView *)pickView row:(NSInteger)row
{
    [Infomation writeInfo:_datas[row]];
//    [APService setTags:[NSSet setWithObjects:[Base64 textFromBase64String:_datas[row][@"classTag"]],nil] alias:_inputView.accountField.text callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];

    _successLogin(self,YES);
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
