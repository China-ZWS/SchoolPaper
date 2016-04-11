//
//  UserDetailViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-22.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJTableViewController.h"
#define kTeachers @"teachers"
#define kStudents @"students"
@interface UserDetailViewController : PJTableViewController

- (id)initWithDatas:(id)datas type:(NSString *)type;
@end
