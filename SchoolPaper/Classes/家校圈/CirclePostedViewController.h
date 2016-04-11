//
//  CirclePostedViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-30.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJViewController.h"

typedef NS_ENUM(NSInteger, PostedType)
{
    kSchoolAndClass = 0,  /// 班圈、校圈.
    kTopic= 1 << 0,///话题圈
};


@interface CirclePostedViewController : PJViewController
- (id)initWithDatas:(id)datas postedType:(PostedType)postedType;

@end
