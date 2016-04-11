//
//  AchievementHeader.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-14.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AchievementHeaderDelegate <NSObject>

- (void)returnDatas:(NSDictionary *)dic;

@end
@interface AchievementHeader : UIView
@property (nonatomic) id<AchievementHeaderDelegate>delegate;
@end
