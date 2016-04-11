//
//  MineCell.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJCell.h"

@interface MineCell : PJCell
{
    NSIndexPath *_indexPath;
    NSInteger _rowNum;
    UILabel *_phoneNum;
}
- (void)dic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath rowNum:(NSInteger)rowNum;

@end
