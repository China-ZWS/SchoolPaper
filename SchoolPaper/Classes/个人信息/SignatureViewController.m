//
//  SignatureViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-19.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "SignatureViewController.h"
#import "BaseTextView.h"

@interface SignatureViewController ()
<BaseTextViewDelegate>
{
    UITextView *_textView;
    UIButton *_finishBtn;
}
@end

@implementation SignatureViewController

- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"个性签名"];
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
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(ScaleX(20), ScaleY(25), DeviceW - ScaleX(20) * 2, ScaleH(220))];
    _textView.font = Font(17);
    [_textView getCornerRadius:5 borderColor:[UIColor lightGrayColor] borderWidth:1.5 masksToBounds:YES];
    _textView.delegate = self;
    _textView.text = [Base64 textFromBase64String:[Infomation readInfo][@"autograph"]];
    [self.view addSubview:_textView];

    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.frame = CGRectMake((DeviceW - CGRectGetWidth(_textView.frame)) / 2, CGRectGetMaxY(_textView.frame) + ScaleH(20), CGRectGetWidth(_textView.frame), ScaleH(50));
    [_finishBtn getCornerRadius:5 borderColor:RGBA(23, 103, 223, 1) borderWidth:0 masksToBounds:YES];
    [_finishBtn setTitle:@"提 交" forState:UIControlStateNormal];
    _finishBtn.titleLabel.font = Font(20);
    [_finishBtn addTarget:self action:@selector(eventWithFinish) forControlEvents:UIControlEventTouchUpInside];
    _finishBtn.userInteractionEnabled = NO;
    _finishBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_finishBtn];
}

- (void)eventWithFinish
{
    [self.view endEditing:YES];
    
    [MBProgressHUD showMessag:Loding_text1 toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"autograph"] = [Base64 base64StringFromText:_textView.text];
    _connection = [BaseModel POST:submitautograph parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Infomation readInfo]];
                       [dic addEntriesFromDictionary:params];
                       [Infomation writeInfo:dic];

                       [self.view makeToast:@"修改成功"];
                       NSNotificationPost(RefreshWithViews, nil, nil);
                       _finishBtn.userInteractionEnabled = NO;
                       _finishBtn.backgroundColor = [UIColor lightGrayColor];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [self performSelector:@selector(back) withObject:nil afterDelay:1];

                   }
                          failure:^(NSString *msg, NSString *state)
                   {
                       
                       
                       [self.view makeToast:msg];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    if (toBeString.length) {
        _finishBtn.backgroundColor = RGBA(23, 103, 223, 1);
        _finishBtn.userInteractionEnabled = YES;
    }
    else
    {
        _finishBtn.userInteractionEnabled = NO;
        _finishBtn.backgroundColor = [UIColor lightGrayColor];
    }
    return YES;
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
