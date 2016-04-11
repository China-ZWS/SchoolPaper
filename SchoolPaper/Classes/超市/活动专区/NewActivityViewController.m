//
//  NewActivityViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/24.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "NewActivityViewController.h"

@interface NewActivityViewController ()

@end

@implementation NewActivityViewController

- (id)init
{
    if ((self = [super init])) {
        self.title = @"最新活动";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)uploadDatas:(NSString *)status
{
    [super uploadDatas:@"JX"];
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
