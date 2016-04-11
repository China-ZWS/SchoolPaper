//
//  StarRateView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-11.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#define LIGHT_STAR_IMAGE_NAME @"star_orange.png"
#define DARK_STAR_IMAGE_NAME @"start_gray.png"
#define DEFAULT_DURATION .5f
#import "StarRateView.h"


@interface StarRateView ()
@property (nonatomic) NSInteger starCount;
@property (nonatomic) CGFloat starWidth;
@property (nonatomic, strong) UIView *lightStarView;
@property (nonatomic, strong) UIView *grayStarView;
@property (nonatomic) UIPanGestureRecognizer *pan;

@end
@implementation StarRateView

- (id)init
{
    if ((self = [super init])) {
        //默认值
        self.percentage = 0.0f;
        self.shouldUseAnimation = NO;
        self.allowIncompleteStar = NO   ;
        self.allowUserInteraction = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame starCount:(NSInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        //默认值
        self.percentage = 0.0f;
        self.shouldUseAnimation = NO;
        self.allowIncompleteStar = NO   ;
        self.allowUserInteraction = YES;

        self.starCount = count;
        self.starWidth = (CGFloat)self.frame.size.width / self.starCount;
        
        [self initStarView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame starCount:(NSInteger)count
{
    self.frame = frame;
    self.starCount = count;
    self.starWidth = (CGFloat)self.frame.size.width / self.starCount;
    
    [self initStarView];

}



- (void)initStarView
{
    
    //星星视图
    if (self.lightStarView) {
        return;
    }
    else if (self.grayStarView)
    {
        return;
    }
    self.lightStarView = [self starViewWithImageName:LIGHT_STAR_IMAGE_NAME];
    self.grayStarView = [self starViewWithImageName:DARK_STAR_IMAGE_NAME];
    
    [self addSubview:self.grayStarView];
    [self addSubview:self.lightStarView];
    
    //此处用pan手势，达到用户可以滑动手指评分的效果
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:self.pan];
}
     

- (UIView *)starViewWithImageName:(NSString *)imageName
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    //添加星星
    for (int i = 0; i < self.starCount; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.starWidth, 0, self.starWidth, self.bounds.size.height)];
        iv.image = [UIImage imageNamed:imageName];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:iv];
    }
    
    return view;
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer {

    if (!_allowUserInteraction) return;
    
    
    static CGFloat startX = 0;
    CGFloat starScorePercentage = 0;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startX = [recognizer locationInView:self].x;
        starScorePercentage = startX / self.starWidth;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat location = [recognizer translationInView:self].x + startX;
        starScorePercentage = location / self.starWidth;
    } else {
        return;
    }
    
    CGFloat realScore = self.allowIncompleteStar ? starScorePercentage : ceilf(starScorePercentage);
    self.percentage = realScore / self.starCount;
}


- (void)setPercentage:(CGFloat)percentage {
    
    if (percentage >= 1) {
        _percentage = 1;
    } else if (percentage < 0) {
        _percentage = 0;
    } else {
        _percentage = percentage;
    }
    
    [self setNeedsLayout];
    
    if ([self.delegate respondsToSelector:@selector(starRateView:didChangedScorePercentageTo:)]) {
        [self.delegate starRateView:self didChangedScorePercentageTo:_percentage];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak StarRateView *weakSelf = self;
    
    CGFloat duration = self.shouldUseAnimation ? DEFAULT_DURATION : 0.0f;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.lightStarView.frame = CGRectMake(0, 0, weakSelf.percentage * weakSelf.bounds.size.width, weakSelf.bounds.size.height);
    }];
}

- (void)setScore:(CGFloat)score;
{
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
