//
//  EditInputView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-18.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "EditInputView.h"

@interface EditInputView ()
<BaseTextFieldDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_location_manager;
    UIButton *_currentSex;
}

@end

@implementation EditInputView

- (void)dealloc
{
    _location_manager.delegate = nil;
    [_location_manager stopUpdatingLocation];
}


- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 6 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 6 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];
    
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 3 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 3 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];
    
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 2 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 2  - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];

    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 3 * 2 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 3 * 2  - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) / 3 * 2 + CGRectGetHeight(rect) / 6 - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) / 3 * 2 + CGRectGetHeight(rect) / 6 - .5) lineColor:[UIColor lightGrayColor] lineWidth:1];

}


- (id)initWithFinish:(void(^)())finish;
{
    if ((self = [super initWithFrame:CGRectMake(ScaleX(20), ScaleY(25), DeviceW - ScaleX(20) * 2, ScaleH(270))])) {
        _finish = finish;
        self.backgroundColor = [UIColor clearColor];
        [self getCornerRadius:5 borderColor:[UIColor lightGrayColor] borderWidth:1.5 masksToBounds:YES];
        [self layoutViews];
        [self startingGpsLocation];
    }
    return self;
}

- (void)eventWithSex:(UIButton *)currentSex
{
  
    if ([_currentSex isEqual:currentSex])
    {
        return;
    }
    [currentSex setBackgroundImage:[UIImage imageNamed:@"optionPress.png"] forState:UIControlStateNormal];
    [_currentSex setBackgroundImage:[UIImage imageNamed:@"option.png"] forState:UIControlStateNormal];
    _currentSex = currentSex;
    if (_currentSex.tag == 10)
    {
        _sexField.text = @"男";
    }
    else
    {
        _sexField.text = @"女";
    }
}



- (void)addSexBtn
{

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_sexField.frame), CGRectGetHeight(_sexField.frame))];
    view.backgroundColor = [UIColor clearColor];
    [_sexField addSubview:view];
 
    UIButton *man = [UIButton buttonWithType:UIButtonTypeCustom];
    man.tag = 10;
    man.frame = CGRectMake(ScaleX(70), (CGRectGetHeight(_sexField.frame) - 30) / 2, 30, 30);
    [man addTarget:self action:@selector(eventWithSex:) forControlEvents:UIControlEventTouchUpInside];
    [man setBackgroundImage:[UIImage imageNamed:@"option.png"] forState:UIControlStateNormal];

    [view addSubview:man];
    UILabel *manLb = [UILabel new];
    manLb.font = Font(17);
    manLb.textColor = [UIColor blackColor];
    manLb.text = @"男";
    [manLb sizeToFit];
    manLb.center = CGPointMake(CGRectGetMaxX(man.frame) + CGRectGetWidth(manLb.frame) / 2, CGRectGetHeight(_sexField.frame) / 2);
    [view addSubview:manLb];
    
    
    UIButton *lady = [UIButton buttonWithType:UIButtonTypeCustom];
    lady.tag = 11;
    lady.frame = CGRectMake(ScaleX(70) + CGRectGetMaxX(manLb.frame), (CGRectGetHeight(_sexField.frame) - 30) / 2, 30, 30);
    lady.tag = 11;
    [lady setBackgroundImage:[UIImage imageNamed:@"option.png"] forState:UIControlStateNormal];

    [lady addTarget:self action:@selector(eventWithSex:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:lady];
    UILabel *ladyLb = [UILabel new];
    ladyLb.font = Font(17);
    ladyLb.textColor = [UIColor blackColor];
    ladyLb.text = @"女";
    [ladyLb sizeToFit];
    ladyLb.center = CGPointMake(CGRectGetMaxX(lady.frame) + CGRectGetWidth(ladyLb.frame) / 2, CGRectGetHeight(_sexField.frame) / 2);
    [view addSubview:ladyLb];
    
    NSString *sex = [Base64 textFromBase64String:[Infomation readInfo][@"sex"]];
    if ([sex isEqualToString:@"男"])
    {
        [man setBackgroundImage:[UIImage imageNamed:@"optionPress.png"] forState:UIControlStateNormal];
        [lady setBackgroundImage:[UIImage imageNamed:@"option.png"] forState:UIControlStateNormal];
        _sexField.text = @"男";
        _currentSex = man;
        
    }
    else if ([sex isEqualToString:@"女"])
    {
        [man setBackgroundImage:[UIImage imageNamed:@"option.png"] forState:UIControlStateNormal];
        [lady setBackgroundImage:[UIImage imageNamed:@"optionPress.png"] forState:UIControlStateNormal];
        _sexField.text = @"女";
        _currentSex = lady;
    }
}

- (UILabel *)setLabel:(NSString *)title
{
    UILabel *label = [UILabel new];
    label.font = Font(17);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.textColor = RGBA(23, 103, 223, 1);
    [label sizeToFit];
    return label;
}

- (void)layoutViews
{
    
    CGFloat const fieldHight = ScaleH(40);
    CGFloat const fieldWidht = CGRectGetWidth(self.frame)  - 20;
    _nameField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 6 - fieldHight) / 2, fieldWidht, fieldHight)];
    _nameField.leftView = [self setLabel:@"昵称:"];
    _nameField.placeholder = @"昵称/称呼";
    _nameField.delegate = self;
    _nameField.font = Font(17);
    _nameField.text = [Base64 textFromBase64String:[Infomation readInfo][@"name"]];
    [self addSubview:_nameField];
    
    _sexField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 6 - fieldHight) / 2 + CGRectGetHeight(self.frame) / 6, fieldWidht, fieldHight)];
    _sexField.leftView = [self setLabel:@"性别:"];
    _sexField.font = Font(17);
    _sexField.textColor = [UIColor clearColor];
    _sexField.text = [Base64 textFromBase64String:[Infomation readInfo][@"sex"]];
    [self addSexBtn];
    [self addSubview:_sexField];
    
    _areaField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 6 - fieldHight) / 2 + CGRectGetHeight(self.frame) / 3, fieldWidht, fieldHight)];
    _areaField.leftView = [self setLabel:@"区域:"];
    _areaField.font = Font(17);
    _areaField.enabled = NO;
    _areaField.text = @"正在获取位置...";
    [self addSubview:_areaField];
    
    _schoolField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 6 - fieldHight) / 2 + CGRectGetHeight(self.frame) / 2, fieldWidht, fieldHight)];
    _schoolField.leftView = [self setLabel:@"学校:"];
    _schoolField.font = Font(17);
    _schoolField.placeholder = @"所在学校";
    _schoolField.text = [Base64 textFromBase64String:[Infomation readInfo][@"school"]];
    [self addSubview:_schoolField];
    
    _gradeField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 6 - fieldHight) / 2 + CGRectGetHeight(self.frame) / 3 * 2, fieldWidht, fieldHight)];
    _gradeField.leftView = [self setLabel:@"学校:"];
    _gradeField.font = Font(17);
    _gradeField.placeholder = @"就读年级";
    _gradeField.text = [Base64 textFromBase64String:[Infomation readInfo][@"grade"]];
    [self addSubview:_gradeField];
    
    
    _classField = [[BaseTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - fieldWidht) / 2, (CGRectGetHeight(self.frame) / 6 - fieldHight) / 2 + CGRectGetHeight(self.frame) / 3 * 2 + CGRectGetHeight(self.frame) / 6, fieldWidht, fieldHight)];
    _classField.leftView = [self setLabel:@"学校:"];
    _classField.font = Font(17);
    _classField.placeholder = @"就读班级";
    _classField.text = [Base64 textFromBase64String:[Infomation readInfo][@"classCode"]];
    [self addSubview:_classField];
}



- (void)startingGpsLocation;
{
    
    if ([CLLocationManager locationServicesEnabled]) {
        

    _location_manager = [[CLLocationManager alloc] init];
    [_location_manager setDelegate:self];
    [_location_manager setDesiredAccuracy:kCLLocationAccuracyBest];
    _location_manager.distanceFilter = 1.;
    [_location_manager startUpdatingLocation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)        [_location_manager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}

//定位失败
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _location_manager.delegate = nil;
    [_location_manager stopUpdatingLocation];
//    _areaField.text = @"地理位置获取失败";
}



//定位数据
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   
    CLGeocoder * geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
      
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            _areaField.text = [test objectForKey:@"City"];
        }
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
