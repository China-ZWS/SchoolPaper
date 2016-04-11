//
//  BaseAGTextViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-9.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseAGTextViewController.h"
@interface BaseAGTextViewController ()
{
}
@end

@implementation BaseAGTextViewController

- (id)init
{
    if ((self = [super init]))
    {
        self.title = @"详 情";
        
    }
    return self;
}

- (void)lodingWithText:(NSString *)text;
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView = [[UITextView alloc] initWithFrame:self.view.frame];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.editable = NO;
    _textView.font = Font(17);
    [self.view addSubview:_textView];
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
