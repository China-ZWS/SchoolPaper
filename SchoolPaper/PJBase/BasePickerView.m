//
//  BasePickerView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-5-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BasePickerView.h"
#define kToolViewHeight 44
@interface BasePickerView ()
{
    BOOL _isShowToolBar;
    BOOL _row;
}
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic) BOOL removeFromSuperViewOnHide;
@end

@implementation BasePickerView

#pragma mark - 构造函数
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}


+ (id)setDatas:(id)datas showToolBar:(BOOL)isShowToolBar delegate:(id)delegate;
{
    [self hidePickerView];

    BasePickerView *picker = [BasePickerView new];
 
    if ([datas isKindOfClass:[NSArray class]] || [datas isKindOfClass:[NSMutableArray class]])
    {
        picker->_array = datas;
        picker->_isShowToolBar = isShowToolBar;
        picker.delegate = delegate;
        [picker show];
    }
    return picker;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

+ (BOOL)hidePickerView
{
    BasePickerView *picker = [self abnormalForView];
    if (picker != nil) {
        picker.removeFromSuperViewOnHide = YES;
        [picker hide];
        return YES;
    }
    return NO;

}

+ (BasePickerView *)abnormalForView
{
    NSEnumerator *subviewsEnum = [[UIApplication sharedApplication].keyWindow.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (BasePickerView *)subview;
        }
    }
    return nil;

}

- (void)hide
{
    if (_removeFromSuperViewOnHide)
        [self removeFromSuperview];

}



#pragma mark -初始化pickerView;
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self layoutViews];
    [self setFrameWithSelf];
}


- (void)setFrameWithSelf
{
    CGRect rect = self.frame;
    if (_isShowToolBar) {
        rect.origin.x = 0;
        rect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(_picker.frame) - CGRectGetHeight(_toolBar.frame);
        rect.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
        rect.size.height = CGRectGetHeight(_picker.frame) + CGRectGetHeight(_toolBar.frame);
    }
    else
    {
        rect.origin.x = 0;
        rect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(_picker.frame);
        rect.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
        rect.size.height = CGRectGetHeight(_picker.frame);
    }
    self.frame = rect;
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DeviceW, kToolViewHeight)];
        UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
        
        UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
        _toolBar.items=@[lefttem,centerSpace,right];
    }
    return _toolBar;
}



- (UIPickerView *)picker
{
    if (!_picker)
    {
        _picker = [UIPickerView new] ;
        if (_isShowToolBar)
        {
            _picker.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY(_picker.frame) + kToolViewHeight);
        }
        _picker.backgroundColor = [UIColor clearColor];
        _picker.delegate=self;
        _picker.dataSource=self;
    }
    return _picker;
}

- (void)layoutViews
{
    if (_isShowToolBar)
    {
        [self addSubview:self.toolBar];
    }
    [self addSubview:self.picker];
}

# pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _array.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [Base64 textFromBase64String:_array[row][@"name"]];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _row = row;
}

-(void)remove
{
    [self removeFromSuperview];
}

- (void)doneClick
{
    if ([self.delegate respondsToSelector:@selector(toolBardoneClick:row:)]) {
        [self.delegate toolBardoneClick:self row:_row];
    }
    [self removeFromSuperview];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
