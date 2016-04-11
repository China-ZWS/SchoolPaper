//
//  TopicDetailsCell.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-5-5.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJCell.h"
#import "PJTableView.h"
@interface TopicDetailsCell : PJCell
<UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) PJTableView *plList;
@property (nonatomic, strong) UIImageView *listBack;
@end
