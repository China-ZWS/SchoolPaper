//
//  BaseActivityViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/24.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJTableViewController.h"

@interface BaseActivityViewController : PJTableViewController
{
    NSInteger _currentPage;
    NSString *_status;
}
- (void)uploadDatas:(NSString *)status;

@end
