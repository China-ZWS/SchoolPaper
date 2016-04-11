//
//  BaseAGViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJTableViewController.h"

@interface BaseAGViewController : PJTableViewController
{
    BOOL _allowRefresh;
    NSInteger _currentPage;
    NSString *_search_key;
    NSString *_scheme_id;
    NSString *_scheme_type_id;
    NSString *_subject_id;
    NSString *_stage_id;
}

- (id)initWithStageId:(NSString *)stageId;
- (void)refreshWithSeleted;

@end
