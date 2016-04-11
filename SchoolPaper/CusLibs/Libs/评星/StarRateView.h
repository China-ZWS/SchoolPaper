//
//  StarRateView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-11.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarRateView;
@protocol StarRateViewDelegate <NSObject>
/**
 *  通知代理改变评分到某一特定的值
 *
 *  @param starRateView 指当前评分view
 *  @param percentage   新的评分值
 */
- (void)starRateView:(StarRateView *)starRateVie didChangedScorePercentageTo:(CGFloat)percentage;
//+ (StarRateView *)setImagesDeselected:(UIImage*)deselectImage partlySelected:(UIImage *)partlyImage fullSelected:(UIImage *)fullImage
@end

@interface StarRateView : UIView

@property (nonatomic) UIImage *deselectImage;
@property (nonatomic) UIImage *partlyImage;
@property (nonatomic) UIImage *fullImage;


/**
 *  代理
 */
@property (weak, nonatomic) id<StarRateViewDelegate> delegate;
/**
 *  是否使用动画，默认为NO
 */
@property (assign, nonatomic) BOOL shouldUseAnimation;
/**
 *  是否允许非整型评分，默认为NO
 */
@property (assign, nonatomic) BOOL allowIncompleteStar;
/**
 *  是否允许用户手指操作评分,默认为YES
 */
@property (assign, nonatomic) BOOL allowUserInteraction;
/**
 *  当前评分值，范围0---1，表示的是黄色星星占的百分比,默认为1
 */
@property (assign, nonatomic) CGFloat percentage;

/**
 *  初始化方法，需传入评分星星的总数
 *
 *  @param frame 该starView的大小与位置
 *  @param count 评分星星的数量
 *
 *  @return 实例变量
 */
- (id)initWithFrame:(CGRect)frame starCount:(NSInteger)count;
/**
 *  设置当前评分为某一值,是否使用动画取决于shouldUseAnimation属性的取值
 *
 *  @param score 新的评分值
 */
- (void)setScore:(CGFloat)score;

- (void)setFrame:(CGRect)frame starCount:(NSInteger)count;

@end
