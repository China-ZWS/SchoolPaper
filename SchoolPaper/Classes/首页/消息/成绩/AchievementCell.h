//
//  AchievementCell.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJCell.h"

@interface AchievementCell : PJCell
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)setDatas:(id)datas indexPath:(NSIndexPath *)indexPath;

@end
