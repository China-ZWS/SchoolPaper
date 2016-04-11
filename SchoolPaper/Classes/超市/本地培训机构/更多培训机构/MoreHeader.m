//
//  MoreHeader.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15/8/19.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "MoreHeader.h"
#import "PJButton.h"
#import "AppDelegate.h"

@interface MoreHeader ()
<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _areasRow;
    NSInteger _subjectsRow;
    NSInteger _stagesRow;
    NSArray *_currentArray;
}
@property (nonatomic, strong) PJButton *areasBtn;
@property (nonatomic, strong) PJButton *subjectsBtn;
@property (nonatomic, strong) PJButton *stagesBtn;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *subjects;
@property (nonatomic, strong) NSArray *stages;
@property (nonatomic, strong) UITableView *list;

@end

@implementation MoreHeader

- (void)drawRect:(CGRect)rect
{
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(),rect);
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect)/3 - .5, 5) end:CGPointMake(CGRectGetWidth(rect)/3 - .5, CGRectGetHeight(rect) - 5) lineColor:[UIColor lightGrayColor] lineWidth:1];
    
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect)/3*2 - .5, 5) end:CGPointMake(CGRectGetWidth(rect)/3*2 - .5, CGRectGetHeight(rect) - 5) lineColor:[UIColor lightGrayColor] lineWidth:1];
    
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) - .5) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - .5) lineColor:[UIColor lightGrayColor] lineWidth:.5];
}

- (id)initWithFrame:(CGRect)frame selected:(void(^)(id data))selected;
{
    if (([super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        _selected = selected;
    }
    [self setDatas];
    [self layoutViews];
    return self;
}

- (PJButton *)areasBtn
{
    if (!_stagesBtn) {
        _stagesBtn = [PJButton buttonWithType:UIButtonTypeCustom];
        _stagesBtn.frame = CGRectMake(5, 5, DeviceW / 3 - 10, CGRectGetHeight(self.frame) - 10);
        [_stagesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _stagesBtn.titleLabel.font = FontBold(15);
        _stagesBtn.showBorder = NO;
        [_stagesBtn setTitle:_stagesRow?[Base64 textFromBase64String:_stages[_stagesRow][@"ageName"]]:_stages[_stagesRow][@"ageName"] forState:UIControlStateNormal];
        [_stagesBtn setTitleColor:CustomBlack forState:UIControlStateNormal];
        [_stagesBtn addTarget:self action:@selector(eventWithOption:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stagesBtn;
}

- (PJButton *)subjectsBtn
{
    if (!_subjectsBtn) {
        _subjectsBtn = [PJButton buttonWithType:UIButtonTypeCustom];
        _subjectsBtn.frame = CGRectMake(DeviceW / 3 + 5, 5, DeviceW / 3 - 10, CGRectGetHeight(self.frame) - 10);
        [_subjectsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _subjectsBtn.titleLabel.font = FontBold(15);
        _subjectsBtn.showBorder = NO;
        [_subjectsBtn setTitle:_subjectsRow?[Base64 textFromBase64String:_subjects[_subjectsRow][@"name"]]:_subjects[_subjectsRow][@"name"] forState:UIControlStateNormal];
        [_subjectsBtn setTitleColor:CustomBlack forState:UIControlStateNormal];
        [_subjectsBtn addTarget:self action:@selector(eventWithOption:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _subjectsBtn;
}

- (PJButton *)stagesBtn
{
    if (!_areasBtn) {
        _areasBtn = [PJButton buttonWithType:UIButtonTypeCustom];
        _areasBtn.frame = CGRectMake(DeviceW / 3 * 2 + 5, 5, DeviceW / 3 - 10, CGRectGetHeight(self.frame) - 10);
        [_areasBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _areasBtn.titleLabel.font = FontBold(15);
        _areasBtn.showBorder = NO;
        [_areasBtn setTitle:_areasRow?[Base64 textFromBase64String:_areas[_areasRow][@"name"]]:_areas[_areasRow][@"name"] forState:UIControlStateNormal];
        [_areasBtn setTitleColor:CustomBlack forState:UIControlStateNormal];
        [_areasBtn addTarget:self action:@selector(eventWithOption:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areasBtn;
}

- (void)layoutViews
{
    [self addSubview:self.stagesBtn];
    [self addSubview:self.subjectsBtn];
    [self addSubview:self.areasBtn];
}

- (void)setDatas
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    _stages = [[NSMutableArray arrayWithArray:app.getinitdata[@"stages"]] insertObject:@{@"ageName":@"阶段",@"id":@"0"} atIndex:0];
    NSMutableArray *stages = [NSMutableArray arrayWithArray:app.getinitdata[@"stages"]];
    [stages insertObject:@{@"ageName":@"阶段",@"id":@"0"} atIndex:0];
    NSMutableArray *subjects = [NSMutableArray arrayWithArray:app.getinitdata[@"subjects"]];
    [subjects insertObject:@{@"name":@"科目",@"id":@"0"} atIndex:0];
    NSMutableArray *areas = [NSMutableArray arrayWithArray:app.getinitdata[@"areas"]];
    [areas insertObject:@{@"name":@"区域",@"id":@"0"} atIndex:0];

    _stages = stages;
    _subjects = subjects;
    _areas = areas;
    _areasRow = 0;
    _subjectsRow= 0;
    _stagesRow = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _currentArray.count;
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
    
    NSDictionary *dic = _currentArray[indexPath.row];
    
    if ([_currentArray isEqualToArray:_stages]) {
        cell.textLabel.text = indexPath.row?[Base64 textFromBase64String:dic[@"ageName"]]:dic[@"ageName"];
    }
    else
    {
        cell.textLabel.text = indexPath.row?[Base64 textFromBase64String:dic[@"name"]]:dic[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _currentArray[indexPath.row];
    
    
    if ([_currentArray isEqualToArray:_stages])
    {
        _stagesRow = indexPath.row;
        [_stagesBtn setTitle:_stagesRow?[Base64 textFromBase64String:_stages[_stagesRow][@"ageName"]]:_stages[_stagesRow][@"ageName"] forState:UIControlStateNormal];
    }
    else if ([_currentArray isEqualToArray:_subjects])
    {
        _subjectsRow = indexPath.row;
        [_subjectsBtn setTitle:_subjectsRow?[Base64 textFromBase64String:_subjects[_subjectsRow][@"name"]]:_subjects[_subjectsRow][@"name"] forState:UIControlStateNormal];
    }
    else if ([_currentArray isEqualToArray:_areas])
    {
        _areasRow = indexPath.row;
        [_areasBtn setTitle:_areasRow?[Base64 textFromBase64String:_areas[_areasRow][@"name"]]:_areas[_areasRow][@"name"] forState:UIControlStateNormal];
    }
   
    NSDictionary *selectedDatas = @{@"stage_id":_stages[_stagesRow][@"id"],@"subject_id":_subjects[_subjectsRow][@"id"],@"area_id":_areas[_areasRow][@"id"]};
    _selected(selectedDatas);
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



- (void)eventWithOption:(UIButton *)button
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

    NSInteger currentRow = 0;
    if ([button isEqual:_stagesBtn]) {
        currentRow = _stagesRow;
        _currentArray = _stages;
        
    }
    else if ([button isEqual:_subjectsBtn])
    {
        currentRow = _subjectsRow;
        _currentArray = _subjects;
    }
    else if ([button isEqual:_areasBtn])
    {
        currentRow = _areasRow;
        _currentArray = _areas;
    }
    [_list reloadData];
    [_list selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
