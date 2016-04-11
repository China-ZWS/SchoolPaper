//
//  AchievementHeader.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-14.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "AchievementHeader.h"
#import "PJTableView.h"
#import "PJButton.h"
#import "PJCell.h"
static NSArray const*semesterDatas = nil;
static NSArray const*subjectDatas = nil;

@interface ListCell : PJCell


@end

@implementation ListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIView *view_bg = [UIView new];
        view_bg.backgroundColor = CustomGray;
        self.selectedBackgroundView = view_bg;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect) -.3) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) - .3) lineColor:CustomGray lineWidth:.3];
}

@end

@interface AchievementHeader ()
<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _semester;
    NSInteger _type;
    NSInteger _subject;
    NSInteger _currentNum;
    PJButton *_semesterBtn;
    PJButton *_typeBtn;
    PJButton *_subjectBtn;
}
@property (nonatomic,getter=list)UITableView *list;
@end

@implementation AchievementHeader

- (id)initWithFrame:(CGRect)frame ;
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
        semesterDatas = @[@{@"title":@"2015-2016上学期"},
                          @{@"title":@"2015-2016下学期"}];
        
        
        subjectDatas = @[@{@"title":@"全部科目",@"type":@""},
                         @{@"title":@"语文",@"type":@"002"},
                         @{@"title":@"数学",@"type":@"003"},
                         @{@"title":@"英语",@"type":@"009"},
                         @{@"title":@"政治",@"type":@"001"},
                         @{@"title":@"物理",@"type":@"004"},
                         @{@"title":@"化学",@"type":@"005"},
                         @{@"title":@"生物",@"type":@"006"},
                         @{@"title":@"地理",@"type":@"007"},
                         @{@"title":@"历史",@"type":@"008"}];
        [self layoutViews];
        [self getShadowOffset:CGSizeMake(0, ScaleH(5)) shadowRadius:ScaleH(5) shadowColor:RGBA(249, 249, 249, 1) shadowOpacity:1 cornerRadius:0 masksToBounds:NO];
    }
    return self;
}

- (void)layoutViews
{
    CGFloat inset = ScaleW(15);
    CGFloat semesterWidth = (DeviceW - inset * 4)  / 2;
    CGFloat subjectWidth = semesterWidth / 3 * 2;
    CGFloat searchWidth = semesterWidth / 3;
    
    _semesterBtn = [PJButton buttonWithType:UIButtonTypeCustom];
    _semesterBtn.frame = CGRectMake(inset, (CGRectGetHeight(self.frame) - ScaleH(40)) / 2, semesterWidth, ScaleH(40));
    [_semesterBtn setTitle:semesterDatas[_semester][@"title"] forState:UIControlStateNormal];
    _semesterBtn.titleLabel.font = Font(17);
    [_semesterBtn setTitleColor:RGBA(30, 30, 30, 1) forState:UIControlStateNormal];
    _semesterBtn.backgroundColor = [UIColor whiteColor];
    _semesterBtn.tag = 10;
    [_semesterBtn addTarget:self action:@selector(eventWithChangeTab:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_semesterBtn];

    _subjectBtn = [PJButton buttonWithType:UIButtonTypeCustom];
    _subjectBtn.tag = 11;
    _subjectBtn.frame = CGRectMake(CGRectGetMaxX(_semesterBtn.frame) + inset, CGRectGetMinY(_semesterBtn.frame), subjectWidth, ScaleH(40));
    [_subjectBtn setTitleColor:RGBA(30, 30, 30, 1) forState:UIControlStateNormal];
    [_subjectBtn setTitle:subjectDatas[_subject][@"title"] forState:UIControlStateNormal];
    _subjectBtn.titleLabel.font = Font(17);
    _subjectBtn.backgroundColor = [UIColor whiteColor];
    [_subjectBtn addTarget:self action:@selector(eventWithChangeTab:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_subjectBtn];

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(_subjectBtn.frame) + inset, CGRectGetMinY(_subjectBtn.frame), searchWidth, ScaleH(40));
    searchBtn.backgroundColor = CustomBlue;
    [searchBtn addTarget:self action:@selector(eventWithSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [searchBtn getCornerRadius:ScaleH(5) borderColor:CustomGray borderWidth:.5 masksToBounds:YES];
    [self addSubview:searchBtn];
}

- (void)eventWithChangeTab:(UIButton *)button
{
    _currentNum = button.tag - 10;
    
    
    CGRect rect = [self convertRect:button.frame fromView:self.superview];
    CGRect changeRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) + ScaleH(5), CGRectGetWidth(button.frame), ((_currentNum == 0)?ScaleH(50)*2:ScaleH(300)));
    
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
    
    [_list reloadData];
    NSInteger row = 0;
    switch (_currentNum) {
        case 0:
            row = _semester;
            break;
        case 1:
            row = _subject;
            break;
        default:
            break;
    }
    
    [_list selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_currentNum) {
        case 0:
            return semesterDatas.count;
            break;
        case 1:
            return subjectDatas.count;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentLb = [UILabel new];
        cell.contentLb.font = Font(17);
        cell.contentLb.textAlignment = NSTextAlignmentCenter;
        cell.contentLb.numberOfLines = 0;
        cell.contentLb.highlightedTextColor = [UIColor whiteColor];
        cell.contentLb.textColor = CustomBlue;
        [cell.contentView addSubview:cell.contentLb];
    }
    NSDictionary *dic = nil;
    switch (_currentNum) {
        case 0:
            dic = semesterDatas[indexPath.row];
            break;
        case 1:
            dic = subjectDatas[indexPath.row];
            break;
        default:
            break;
    }
    
    cell.contentLb.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), ScaleH(50));
    cell.contentLb.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_currentNum) {
        case 0:
        {
            _semester = indexPath.row;
            [_semesterBtn setTitle:semesterDatas[_semester][@"title"]forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            _subject = indexPath.row;
            [_subjectBtn setTitle:subjectDatas[_subject][@"title"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    
    
    [UIView animateWithDuration:.1 animations:^()
     {
         CGRect rect = tableView.frame;
         rect.size.height = 0;
         tableView.frame = rect;
     }];

}


- (void)eventWithSearch
{
    [UIView animateWithDuration:.1 animations:^()
     {
         CGRect listRect = _list.frame;
         listRect.size.height = 0;
         _list.frame = listRect;
     }];

    if ([_delegate respondsToSelector:@selector(returnDatas:)])
    {
        [_delegate returnDatas:@{@"semester":semesterDatas[_semester][@"title"],@"kc":subjectDatas[_subject][@"type"]}];
    }
}

- (UITableView *)list
{
    if (!_list)
    {
        _list = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _list.delegate = self;
        _list.dataSource = self;
        _list.backgroundColor = [UIColor whiteColor];
        [self.superview addSubview:_list];
        [_list getCornerRadius:ScaleH(3) borderColor:[UIColor grayColor] borderWidth:.3 masksToBounds:YES];
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
