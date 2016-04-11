//
//  ReguserViewController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-16.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "PJViewController.h"

@interface ReguserViewController : PJViewController
{
    void(^_success)();
}
- (id)initWithSuccess:(void(^)())success;
@end
