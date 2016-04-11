//
//  ClassSchoolDetailCell.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-28.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJCell.h"
#import "PJTableView.h"

@interface CircleDetailCell : PJCell
<UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIButton *plBtn;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) PJTableView *plList;
@property (nonatomic, strong) UIImageView *listBack;
@end
