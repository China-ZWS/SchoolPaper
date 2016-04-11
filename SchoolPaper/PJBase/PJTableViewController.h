//
//  PJTableViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MJRefresh.h"
@interface PJTableViewController : BaseTableViewController
{
    NSMutableArray *_datas;
}
- (id)initWithTableViewStyle:(UITableViewStyle)style;

@property (nonatomic) NSMutableArray *datas;
@end
