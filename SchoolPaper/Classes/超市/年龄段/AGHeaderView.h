//
//  AGHeaderView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-3.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGHeaderView : UIView
{
    void(^_selected)(id datas);
}
- (id)initWithFrame:(CGRect)frame datas:(NSArray *)datas selected:(void(^)(id data))selected;
@end
