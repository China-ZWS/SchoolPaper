//
//  BaseAGCell.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJCell.h"

@interface BaseAGCell : PJCell
{
    UILabel *_level;
    UILabel *_useCount;
    UILabel *_price;
    UILabel *_type;
}
@property (nonatomic, strong) UILabel *level;
@property (nonatomic, strong) UILabel *useCount;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *type;

@end
