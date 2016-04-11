//
//  BaseAGReviewViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-11.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseAGReviewViewController.h"
#import "StarRateView.h"
#import "BaseTextView.h"

@interface BaseAGTextView : BaseTextView

@end

@implementation BaseAGTextView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self getCornerRadius:ScaleH(3) borderColor:[UIColor clearColor] borderWidth:1 masksToBounds:YES];

    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(CGRectGetWidth(rect), 0) lineColor:CustomBlack lineWidth:.3];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetMaxY(rect) - .3) end:CGPointMake(CGRectGetWidth(rect),  CGRectGetMaxY(rect) - .3) lineColor:CustomBlack lineWidth:.3];
}

@end

@interface BaseAGReviewViewController ()
<StarRateViewDelegate, BaseTextViewDelegate>
{
    NSDictionary *_dic;
    NSString *_score;
    BaseAGTextView *_textView;
}
@end

@implementation BaseAGReviewViewController

- (id)initWithDatas:(id)datas;
{
    if ((self = [super init])) {
        _dic = datas;
        
        [self.navigationItem setNewTitle:@"写评论"];
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
    
    StarRateView *rate = [[StarRateView alloc] initWithFrame:CGRectMake((DeviceW - 150) / 2, ScaleH(20), 150, ScaleH(30)) starCount:5];
    rate.delegate = self;
    rate.percentage = 0;
//    rate.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rate];
    [rate setScore:5];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rate.frame), DeviceW, Font(15).lineHeight)];
//    text.backgroundColor = [UIColor whiteColor];
    text.text = @"滑动星形来评分";
    text.textAlignment = NSTextAlignmentCenter;
    text.font = Font(15);
    text.textColor = CustomBlack;
    [self.view addSubview:text];
    
    _textView  = [[BaseAGTextView alloc] initWithFrame:CGRectMake(ScaleW(20), CGRectGetMaxY(text.frame) + ScaleW(20), DeviceW -  ScaleW(40), 120)];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;
//    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
    
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [self eventWithSubmit];
        [textView resignFirstResponder];
        return NO;
    }else {
        if ([textView.text length] <= 200) {//判断字符个数
            return YES;
        }
    }
    return NO;
}



- (void)starRateView:(StarRateView *)starRateVie didChangedScorePercentageTo:(CGFloat)percentage
{
    _score = [NSString stringWithFormat:@"%f",5.0 * percentage];
}

- (void)eventWithSubmit
{
    [MBProgressHUD showMessag:Loding_text1 toView:self.view];
    
    
    NSMutableDictionary *params=[NSMutableDictionary new];   // 要传递的json数据是一个字典
    params[@"score"] = _score;
    params[@"content"] = [Base64 base64StringFromText:_textView.text];
    params[@"resource_id"] = _dic[@"id"];
    
    _connection = [BaseModel POST:submitresourceappraise parameter:params   class:[BaseModel class]
                          success:^(id data)
                   {
                       [_textView resignFirstResponder];
                       [self.view makeToast:@"提交成功"];
                       [self performSelector:@selector(back) withObject:nil afterDelay:.5];
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
