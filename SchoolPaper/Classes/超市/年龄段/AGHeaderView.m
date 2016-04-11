

//
//  AGHeaderView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-6-3.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AGHeaderView.h"
#import "PJButton.h"




@interface AGHeaderView ()
<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_datas;
    NSArray *_currentOptions;
    NSInteger _currentSchemeIndex;
    NSInteger _currentSubjectIndex;
    NSMutableDictionary *_selectedDatas;
    BOOL _selectedLeft;
}
@property (nonatomic) NSMutableArray *options;
@property (nonatomic, strong) PJButton *schemeBtn;
@property (nonatomic, strong) PJButton *subjectBtn;;
@property (nonatomic, strong) UITableView *list;
@end
@implementation AGHeaderView

- (void)drawRect:(CGRect)rect
{
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(),rect);
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect)/2 - .5, 5) end:CGPointMake(CGRectGetWidth(rect)/2 - .5, CGRectGetHeight(rect) - 5) lineColor:[UIColor lightGrayColor] lineWidth:1];
}

- (id)initWithFrame:(CGRect)frame datas:(NSArray *)datas selected:(void(^)(id data))selected;
{
    if (([super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        
        _options = [NSMutableArray array];
        _selectedDatas = [NSMutableDictionary dictionary];
        _selected = selected;
        NSMutableDictionary *subject = [NSMutableDictionary dictionary];
        subject[@"id"] = @"";
        subject[@"schemetypeId"] = @"";
        subject[@"subjectId"] = @"0";
        subject[@"subjectName"] = @"全部";

        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"id"] = @"0";
        dic[@"schemeId"] = @"1";
        dic[@"stageId"] = @"";
        dic[@"typeName"] = [Base64 base64StringFromText:@"全部"];
        dic[@"viewImg"] = @"";
        dic[@"schemetypesubjects"] = @[subject];
        [_options addObject:dic];
        
        _selectedDatas[@"schemeId"] = dic[@"schemeId"];
        _selectedDatas[@"scheme_type_id"] = dic[@"id"];
        _selectedDatas[@"stage_id"] = dic[@"stageId"];
        _selectedDatas[@"subject_id"] = dic[@"schemetypesubjects"][0][@"subjectId"];

        
        
        for (NSDictionary *sechemetype in datas)
        {
            
            NSMutableDictionary *sechemetypeDic = [NSMutableDictionary dictionaryWithDictionary:sechemetype];
            
            NSMutableArray *schemetypesubject = [NSMutableArray arrayWithArray:sechemetype[@"schemetypesubjects"]];
           
            NSMutableDictionary *subject = [NSMutableDictionary dictionary];
            subject[@"id"] = @"";
            subject[@"schemetypeId"] = @"";
            subject[@"subjectId"] = @"0";
            subject[@"subjectName"] = @"全部";
            [schemetypesubject insertObject:subject atIndex:0];
            
            sechemetypeDic[@"schemetypesubjects"] = schemetypesubject;
            [_options addObject:sechemetypeDic];
        }
    }
    
    [self layoutViews];
    return self;
}

- (PJButton *)schemeBtn
{
    if (!_schemeBtn)
    {
        _schemeBtn = [PJButton buttonWithType:UIButtonTypeCustom];
        _schemeBtn.frame = CGRectMake(5, 5, DeviceW / 2 - 10, CGRectGetHeight(self.frame) - 10);
        [_schemeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _schemeBtn.titleLabel.font = FontBold(15);
        _schemeBtn.showBorder = NO;
        [_schemeBtn addTarget:self action:@selector(eventWithScheme:) forControlEvents:UIControlEventTouchUpInside];
    }
    
  
    [_schemeBtn setTitle:[Base64 textFromBase64String:_options[_currentSchemeIndex][@"typeName"]] forState:UIControlStateNormal];
   
    return _schemeBtn;
}

- (PJButton *)subjectBtn
{
    if (!_subjectBtn)
    {
        _subjectBtn = [PJButton buttonWithType:UIButtonTypeCustom];
        _subjectBtn.frame = CGRectMake(DeviceW / 2 + 5, 5, DeviceW / 2 - 10, CGRectGetHeight(self.frame) - 10);
        [_subjectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _subjectBtn.titleLabel.font = FontBold(15);
        _subjectBtn.showBorder = NO;
        [_subjectBtn addTarget:self action:@selector(eventWithSubject:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_subjectBtn setTitle:_options[_currentSchemeIndex][@"schemetypesubjects"][_currentSubjectIndex][@"subjectName"] forState:UIControlStateNormal];
    return _subjectBtn;
}

- (void)layoutViews
{
    [self addSubview:self.schemeBtn];
    [self addSubview:self.subjectBtn];
}

- (UITableView *)list
{
    if (!_list)
    {
        _list = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _list.delegate = self;
        _list.dataSource = self;
        _list.backgroundColor = [UIColor whiteColor];
        [_list getCornerRadius:ScaleH(3) borderColor:[UIColor grayColor] borderWidth:.3 masksToBounds:YES];
        [self.superview addSubview:_list];
    }
    return _list;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return _currentOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(15);
        cell.textLabel.highlightedTextColor = CustomBlue;
    }
    
    NSDictionary *dic = _currentOptions[indexPath.row];
    
    cell.textLabel.text = _selectedLeft?[Base64 textFromBase64String:dic[@"typeName"]]:dic[@"subjectName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _currentOptions[indexPath.row];

    if (_selectedLeft)
    {
        _currentSchemeIndex = indexPath.row;
        _currentSubjectIndex = 0;

        [_schemeBtn setTitle:[Base64 textFromBase64String:dic[@"typeName"]] forState:UIControlStateNormal];
        [_subjectBtn setTitle:dic[@"schemetypesubjects"][_currentSubjectIndex][@"subjectName"] forState:UIControlStateNormal];
        
        _selectedDatas[@"schemeId"] = dic[@"schemeId"];
        _selectedDatas[@"scheme_type_id"] = dic[@"id"];
        _selectedDatas[@"stage_id"] = dic[@"stageId"];
       
        _selectedDatas[@"subject_id"] = dic[@"schemetypesubjects"][_currentSubjectIndex][@"subjectId"];

        _selected(_selectedDatas);
    }
    else
    {
        _currentSubjectIndex = indexPath.row;
        [_subjectBtn setTitle:dic[@"subjectName"] forState:UIControlStateNormal];
        _selectedDatas[@"subject_id"] = dic[@"subjectId"];
        _selected(_selectedDatas);
        
    }
    
    
    if (CGRectGetHeight(_list.frame))
    {
        [UIView animateWithDuration:.1 animations:^()
         {
             CGRect listRect = _list.frame;
             listRect.size.height = 0;
             _list.frame = listRect;
         }];
    }

    
}


- (void)eventWithScheme:(UIButton *)button
{
    CGRect rect = [self convertRect:button.frame fromView:self.superview];
    CGRect changeRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) + ScaleH(5), CGRectGetWidth(button.frame), ScaleH(50) * 5);
    
    if (CGRectGetHeight(_list.frame))
    {
        [UIView animateWithDuration:.1 animations:^()
         {
             CGRect listRect = _list.frame;
             listRect.size.height = 0;
             _list.frame = listRect;
         }];
        return;
    }
    
    _selectedLeft = YES;
    self.list.frame = changeRect;
    _currentOptions = _options;
    [_list reloadData];

    [_list selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSchemeIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)eventWithSubject:(UIButton *)button
{
    CGRect rect = [self convertRect:button.frame fromView:self.superview];
    CGRect changeRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) + ScaleH(5), CGRectGetWidth(button.frame), ScaleH(50) * 5);
    
    if (CGRectGetHeight(_list.frame))
    {
        [UIView animateWithDuration:.1 animations:^()
         {
             CGRect listRect = _list.frame;
             listRect.size.height = 0;
             _list.frame = listRect;
         }];
        return;
    }
    
    self.list.frame = changeRect;
    _selectedLeft = NO;
    _currentOptions = _options[_currentSchemeIndex][@"schemetypesubjects"];
    [_list reloadData];
    [_list selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSubjectIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
