//
//  BaseLMViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/19.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJTableViewController.h"

@interface BaseLMViewController : PJTableViewController
{
    NSInteger _currentPage;
    NSString *_stage_id;
    NSString *_subject_id;
    NSString *_area_id;
    NSString *_seller_id;
}

- (id)initWithDatas:(NSDictionary *)datas;
- (void)refreshRequest:(NSDictionary *)data;

@end
