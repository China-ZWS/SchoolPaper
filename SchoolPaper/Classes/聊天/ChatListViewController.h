//
//  ChatListViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-23.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJTableViewController.h"
typedef NS_ENUM(NSInteger, ChatType)
{
    kMessage = 0,  /// 没有网络.
    kGroup = 1 << 0,///  没有数据
};


@interface ChatListViewController : PJTableViewController

- (id)initWithName:(id)datas  chatType:(ChatType)chatType;
@end
