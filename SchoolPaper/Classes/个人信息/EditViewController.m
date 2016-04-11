//
//  EditViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "EditViewController.h"
#import "EditInputView.h"

@interface EditViewController ()
{
    EditInputView *_inputView;
    UIButton *_finishBtn;
}
@end

@implementation EditViewController



- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"资料编辑"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    
    [self popViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 登录输入框
    EditViewController __weak*safeSelf = self;
    _inputView =  [[EditInputView alloc] initWithFinish:^()
                   {
                       [safeSelf eventWithFinish];
                   }];
    [self.view addSubview:_inputView];

    NSString *xxt = [Base64 textFromBase64String:[Infomation readInfo][@"xxt"]];
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.frame = CGRectMake((DeviceW - CGRectGetWidth(_inputView.frame)) / 2, CGRectGetMaxY(_inputView.frame) + ScaleH(20), CGRectGetWidth(_inputView.frame), ScaleH(50));
    [_finishBtn getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [_finishBtn setTitle:@"提 交" forState:UIControlStateNormal];
    _finishBtn.titleLabel.font = Font(20);
    _finishBtn.backgroundColor = RGBA(23, 103, 223, 1);
    [_finishBtn addTarget:self action:@selector(eventWithFinish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishBtn];

    
    if ([xxt integerValue] == 1)
    {
        _inputView.userInteractionEnabled = NO;
        _finishBtn.backgroundColor = [UIColor lightGrayColor];
        _finishBtn.userInteractionEnabled = NO;
    }

    // Do any additional setup after loading the view.
}

- (void)eventWithFinish
{
    [self.view endEditing:YES];
        
    [MBProgressHUD showMessag:Loding_text1 toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!_inputView.nameField.text.length) {
        [self makeToast:@"昵称不能为空"];
        return;
    }
    
    params[@"nick_name"] = [Base64 base64StringFromText:_inputView.nameField.text];
    params[@"use_sex"] = [Base64 base64StringFromText:_inputView.sexField.text];
    params[@"area"] = [Base64 base64StringFromText:_inputView.areaField.text];
    params[@"school"] = [Base64 base64StringFromText:_inputView.schoolField.text];
    params[@"grade"] = [Base64 base64StringFromText:_inputView.gradeField.text];
    params[@"classes"] = [Base64 base64StringFromText:_inputView.classField.text];
    
    _connection = [BaseModel POST:submituserinfo parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       
                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Infomation readInfo]];
                       [dic addEntriesFromDictionary:params];
                       dic[@"classCode"] = params[@"classes"];
                       dic[@"name"] = params[@"nick_name"];
                       dic[@"sex"] = params[@"use_sex"];
                       [Infomation writeInfo:dic];

                       [self.view makeToast:@"修改成功"];
                       NSNotificationPost(RefreshWithViews, nil, nil);
                       [self performSelector:@selector(back) withObject:nil afterDelay:1];
                       _finishBtn.userInteractionEnabled = NO;
                       _finishBtn.backgroundColor = [UIColor lightGrayColor];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       
                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       
                       [self.view makeToast:msg];
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
