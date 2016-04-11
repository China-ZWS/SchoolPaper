//
//  UserInfo.h
//  SchoolPaper
//
//  Created by 周文松 on 15/9/24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJTableViewController.h"
#import "SliderMenuController.h"
#import "MainViewController.h"
@protocol UserInfoDelegate <NSObject>



@end

@interface UserInfo : PJTableViewController
<LeftDelegate>
@property (nonatomic, weak) MainViewController *main;
@property (nonatomic, weak) SliderMenuController *menu;
@property (nonatomic, weak) id<UserInfoDelegate>delegate;

@end
