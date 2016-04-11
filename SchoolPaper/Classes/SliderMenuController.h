//
//  SliderMenuController.h
//  SchoolPaper
//
//  Created by 周文松 on 15/9/23.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJViewController.h"
static const CGFloat viewSlideHorizonRatio = 0.75;
static const CGFloat viewHeightNarrowRatio = 0.80;

@protocol HomeDelegate <NSObject>
@optional
- (void)stateChangedForHome:(CGFloat)distance;
@end
@protocol LeftDelegate <NSObject>
@optional
- (void)stateChangedForLetf:(CGFloat)distance;

@end
@protocol RifhtDelegate <NSObject>
@optional
- (void)stateChangedForRight:(CGFloat)distance;
@end

@interface SliderMenuController :PJViewController
@property (nonatomic, weak) id<HomeDelegate>homeDelegate;
@property (nonatomic, weak) id<LeftDelegate>leftDelegate;
@property (nonatomic, weak) id<RifhtDelegate>rightDelegte;

@property (nonatomic, weak) UIViewController *leftView;
@property (nonatomic, weak) UIViewController *centerView;
@property (nonatomic, weak) UIViewController *rightView;

- (id)initWithLeftView:(UIViewController *)leftView centerView:(UIViewController *)centerView rightView:(UIViewController *)rightView;
- (void)touchesLeftItem;

@end
