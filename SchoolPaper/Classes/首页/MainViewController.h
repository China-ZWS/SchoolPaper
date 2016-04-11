//
//  MainViewController.h
//  SchoolPaper
//
//  Created by 周文松 on 15/9/24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewController.h"
#import "SliderMenuController.h"

@interface MainViewController : PJTableViewController
<HomeDelegate>
@property (nonatomic, strong) UIButton *leftItem;
@property (nonatomic, weak) SliderMenuController *menu;
- (void)hasLogin;

@end
