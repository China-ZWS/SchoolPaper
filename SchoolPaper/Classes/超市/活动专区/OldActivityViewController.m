//
//  OldActivityViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/24.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "OldActivityViewController.h"

@interface OldActivityViewController ()

@end

@implementation OldActivityViewController

- (id)init
{
    if ((self = [super init])) {
        self.title = @"过往活动";
        
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)uploadDatas:(NSString *)status
{
    [super uploadDatas:@"GQ"];
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
