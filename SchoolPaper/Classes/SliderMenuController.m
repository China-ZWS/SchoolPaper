//
//  SliderMenuController.m
//  SchoolPaper
//
//  Created by 周文松 on 15/9/23.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "SliderMenuController.h"

typedef enum : NSInteger {
    
    kMoveDirectionNone = 0,
    kMoveDirectionRight,
    kMoveDirectionLeft
    
} MoveDirection;

CGFloat const gestureMinimumTranslation = 0 ;
CGFloat const kDuration = .3f;
static const CGFloat menuStartNarrowRatio  = 0.70;

@interface SliderMenuController ()
{
    MoveDirection _direction;
    CGFloat _showWidth;
    CGFloat _minWidth;
    CGFloat _scalef;
    UIView *_menuView;
}
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (nonatomic, strong) UIView *cover;
@end

@implementation SliderMenuController

- (id)initWithLeftView:(UIViewController *)leftView centerView:(UIViewController *)centerView rightView:(UIViewController *)rightView;
{
    if ((self = [super init])) {
        // 设置遮盖

        self.leftView = leftView, self.centerView = centerView, self.rightView = rightView;
        _showWidth = DeviceW * viewSlideHorizonRatio;
        _minWidth = DeviceW * 2 / 5;
        self.distance = 0;
        self.menuCenterXStart = _minWidth / 2;
        self.menuCenterXEnd = self.view.center.x;
        self.view.backgroundColor = [UIColor clearColor];
        
        self.cover = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.cover.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:_cover belowSubview:_centerView.view];
    }
    return self;
}


- (void)setLeftView:(UIViewController *)leftView
{
    if (leftView) {
        _leftView = leftView;
        _leftView.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:leftView];
    }
}

- (void)setCenterView:(UIViewController *)centerView
{
    if (centerView) {
        _centerView = centerView;
        [self addChildViewController:centerView];
        [self.view addSubview:centerView.view];
        centerView.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:centerView.view.frame].CGPath;
        centerView.view.layer.shadowOffset = CGSizeZero;
        centerView.view.layer.shadowOpacity = .8f;
        centerView.view.layer.cornerRadius = 4.0f;
        centerView.view.layer.shadowRadius = 4.0f;
//        centerView.view.layer.shadowColor = [[UIColor blackColor] CGColor];
        
    }
}

- (void)setRightView:(UIViewController *)rightView
{
    if (rightView) {
        _rightView = rightView;
        _rightView.view.backgroundColor = [UIColor redColor];
        [self addChildViewController:rightView];
    }
}

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer)
    {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    }
    return _tapRecognizer;
}

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
        //无论最大还是最小都只允许一个手指
        _panGestureRecognizer.minimumNumberOfTouches = 1;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
    }
    return _panGestureRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //滑动手势
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}


#pragma mark -  显示右边
- (void)willShowRightView
{
    if (!_leftView || _leftView.view.superview) {
        return;
    }
    _menuView = _leftView.view;
    [self.view insertSubview:_leftView.view belowSubview:_cover];
    
    if (_rightView && _rightView.view.superview)
    {
        [_rightView.view removeFromSuperview];
    }
}

#pragma mark -  显示左边
- (void)willShowLeftView
{
    if (!_rightView || _rightView.view.superview) {
        return;
    }
    _menuView = _rightView.view;
    [self.view insertSubview:_rightView.view belowSubview:_cover];
    if (_leftView && _leftView.view.superview)
    {
        [_leftView.view removeFromSuperview];
    }
}


#pragma mark -  滑动过程中
- (void)homeMoving:(CGFloat)dis proportion:(CGFloat)proportion direction:(MoveDirection)direction
{
    _centerView.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y);
    _centerView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    _cover.alpha = 1 - dis / _showWidth;
    [self stateChangedForHome:1 - dis / _showWidth];
    
}

- (void)menuMoving:(CGFloat)dis proportion:(CGFloat)proportion menuCenterMove:(CGFloat)menuCenterMove direction:(MoveDirection)direction
{
        _menuView.center = CGPointMake(self.menuCenterXStart + menuCenterMove, self.view.center.y);
        _menuView.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
}

#pragma 对应homeView的变化
- (void)stateChangedForHome:(CGFloat)distance
{
    if ([_homeDelegate respondsToSelector:@selector(stateChangedForHome:) ]&& [_homeDelegate conformsToProtocol:@protocol(HomeDelegate)]) {
        [_homeDelegate stateChangedForHome:distance];
    }
}

#pragma mark - 抽屉滑动
-(void)handlePanGestures:(UIPanGestureRecognizer *)recognizer
{

    CGPoint translatedPoint = [recognizer translationInView:recognizer.view.superview];

    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.panStartX = [recognizer locationInView:self.view].x;
        _direction = [self determineDirectionIfNeeded:translatedPoint];
      
        switch (_direction) {
            case kMoveDirectionRight:
            {
                [self willShowRightView];
            }
                break ;
            case kMoveDirectionLeft:
            {
                [self willShowLeftView];
            }
                break ;
            default :
                break ;
        }

    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {

        CGFloat dis = self.distance + translatedPoint.x;
        CGFloat proportion = (viewHeightNarrowRatio - 1) * dis / _showWidth + 1;
        if (proportion < viewHeightNarrowRatio || proportion > 1) {
            return;
        }
        [self homeMoving:dis proportion:proportion direction:_direction];

        CGFloat menuProportion = dis * (1 - menuStartNarrowRatio) / _showWidth + menuStartNarrowRatio;
        
        
        CGFloat menuCenterMove = dis * (self.menuCenterXEnd - self.menuCenterXStart) / _showWidth;
        
        [self menuMoving:dis proportion:menuProportion menuCenterMove:menuCenterMove direction:_direction];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded )
    {
        CGPoint point =  _centerView.view.frame.origin;
        if (point.x >= _minWidth || point.x <= -_minWidth)
        {
            [self showMenu];
        }
        else
        {
            [self showHome];
        }
    }
}


- (void)showMenu
{
    self.distance = _showWidth;
   if (!_tapRecognizer) [_centerView.view addGestureRecognizer:self.tapRecognizer];
    [self stateChangedForHome:0];
    [self doSlide:viewHeightNarrowRatio];
}

- (void)showHome
{
    self.distance = 0;
    [_centerView.view removeGestureRecognizer:_tapRecognizer];
    self.tapRecognizer = nil;
    [self stateChangedForHome:1];
    [self doSlide:1];
}

- (void)doSlide:(CGFloat)proportion
{
    [UIView animateWithDuration:kDuration animations:^{
        _centerView.view.center = CGPointMake(_distance + self.view.center.x,self.view.center.y);
        _centerView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
  
        _cover.alpha = proportion == 1 ? 1 : 0;
        CGFloat menuCenterX;
        CGFloat menuProportion;
        if (proportion == 1) {
            menuCenterX = self.menuCenterXStart;
            menuProportion = menuStartNarrowRatio;
        } else {
            menuCenterX = self.menuCenterXEnd;
            menuProportion = 1;
        }
        _menuView.center = CGPointMake(menuCenterX, self.view.center.y);
        _menuView.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
    }];

}


#pragma mark -单击 关闭抽屉
- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    [self showHome];
}

#pragma mark - 外用方法
- (void)touchesLeftItem
{
    CGPoint point =  _centerView.view.frame.origin;
    if (point.x == 0)
    {
        [self willShowRightView];
        [self showMenu];
    }
    else
    {
        [self showHome];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MoveDirection )determineDirectionIfNeeded:( CGPoint )translation

{
    
    // 确定横向轻扫只有当你满足一些最小速度
    if (fabs(translation.x) > gestureMinimumTranslation)
    {
        BOOL gestureHorizontal = NO;
        if (translation.y == 0.0 )
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) > 0.0 );
        
        if (gestureHorizontal)
        {
            if (translation.x > 0.0 && CGRectGetMinX(_centerView.view.frame) >= 0)
                return kMoveDirectionRight;
            else if (translation.x < 0.0 && CGRectGetMinX(_centerView.view.frame) <= 0)
                return kMoveDirectionLeft;
        }
    }
    return _direction;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
