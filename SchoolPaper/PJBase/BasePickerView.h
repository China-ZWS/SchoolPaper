//
//  BasePickerView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-5-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BasePickerView;
@protocol BasePickerViewDelegate <NSObject>

@optional
-(void)toolBardoneClick:(BasePickerView *)pickView row:(NSInteger)row;


@end

@interface BasePickerView : UIView
<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, assign) id<BasePickerViewDelegate>delegate;
@property (nonatomic, readonly) NSArray *array;

+ (id)setDatas:(id)datas showToolBar:(BOOL)isShowToolBar delegate:(id)delegate;
+ (BOOL)hidePickerView;

@end
