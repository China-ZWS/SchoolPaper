//
//  FeedBackViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-19.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FBListViewController.h"
#import "PJButton.h"
#import "BaseTextView.h"
@interface MyButton : UIButton

@end

@implementation MyButton

- (void)drawRect:(CGRect)rect
{
    
}

@end

@interface FeedBackViewController ()
<BaseTextViewDelegate>
{
    UITextView *_textView;
    UIButton *_finishBtn;
    NSString *_type;
    PJButton *_chooseBtn;
}
@end

@implementation FeedBackViewController

- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"问题反馈"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
        _type = @"";
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
    
    _chooseBtn = [PJButton buttonWithType:UIButtonTypeCustom];
    _chooseBtn.frame = CGRectMake(ScaleX(20), ScaleY(20), DeviceW - ScaleX(20) * 2, ScaleH(35));
    [_chooseBtn addTarget:self action:@selector(eventWithChoose) forControlEvents:UIControlEventTouchUpInside];
    [_chooseBtn setTitle:@"选择反馈问题类型" forState:UIControlStateNormal];
    [_chooseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:_chooseBtn];

    
    _textView = [[BaseTextView alloc] initWithFrame:CGRectMake(ScaleX(20), ScaleY(15) + CGRectGetMaxY(_chooseBtn.frame) , DeviceW - ScaleX(20) * 2, ScaleH(220))];
    _textView.font = Font(17);
    _textView.delegate = self;
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
    params[@"type"] = _type;
    params[@"content"] = [Base64 base64StringFromText:_textView.text];
    _connection = [BaseModel POST:submitfeedback parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [self.view makeToast:@"提交成功"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (void)eventWithChoose
{
    [self pushViewController:[[FBListViewController alloc] initWithOptions:^(NSString *type)
                              {
                                  _type = type;
                                  [_chooseBtn setTitle:_type forState:UIControlStateNormal];
                              }]];
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
