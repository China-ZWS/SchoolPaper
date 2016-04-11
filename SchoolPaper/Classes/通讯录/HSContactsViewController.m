//
//  HSContactsViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-1.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "HSContactsViewController.h"
#import "MJRefresh.h"
#import "pinyin.h"
#import "HSContactsCell.h"
#import "HSSearchBarViewController.h"
#import "UserDetailViewController.h"
#import "ChatListViewController.h"

#define ALPHA	@"班师ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

@interface HSContactsViewController ()
<UISearchBarDelegate>
{
    NSMutableDictionary *_students;
    NSArray *_teachers;
    NSArray *_keys;
    NSMutableArray *_searchDatas;
    UISearchDisplayController *_searchDC;
    UISearchBar *_searchBar;
    
}
@end

@implementation HSContactsViewController

- (id)init
{
    if ((self = [super init]))
    {
        [self.navigationItem setNewTitle:@"通讯录"];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        _students = [NSMutableDictionary dictionary];
        _searchDatas = [NSMutableArray array];
    }
    return self;
}

- (void)back
{
    [self popViewController];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _table.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_table.header beginRefreshing];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, DeviceW, 44)];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.delegate = self;
    _table.tableHeaderView = _searchBar;
    
    _searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDC.searchResultsDataSource = self;
    _searchDC.searchResultsDelegate = self;
    
}

#pragma mark - SearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [searchBar resignFirstResponder];
    if (!_searchDatas.count)
    {
        [self.view makeToast:@"查不到这个用户" duration:.5 position:@"center"];
        return;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    [self filterContentForSearchText:searchBar.text];
}

-(void)filterContentForSearchText:(NSString*)searchText
{
    [_searchDatas removeAllObjects];
    NSMutableArray *students = [NSMutableArray array];
    NSMutableArray *teachers = [NSMutableArray array];
    if (!searchText.length)
    {
        return;
    }
    
    NSString *letter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([searchText characterAtIndex:0])] uppercaseStringWithLocale:[NSLocale currentLocale]];
    
    for (NSDictionary *dic in _teachers)
    {
        if([[__TEXT(dic[@"tacName"]) lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound )
        {
            [teachers addObject:dic];
        }
    }
    
    
    NSArray *list = [_students objectForKey:letter];
    for (NSDictionary *dic in list)
    {
        if([[__TEXT(dic[@"stuName"]) lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound )
        {
            [students addObject:dic];
        }
    }
    
    if (teachers.count)
    {
        NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
        searchDic[@"key"] = @"老师";
        searchDic[@"datas"] = teachers;
        [_searchDatas addObject:searchDic];
    }
    
    if (students.count)
        
    {
        NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
        searchDic[@"key"] = letter;
        searchDic[@"datas"] = students;
        [_searchDatas addObject:searchDic];
    }
}


#pragma mark - tableViewDelegate OR tableViewSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    if (tableView == _table) return 1 + (_teachers.count?1:0) + _keys.count;
    return _searchDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _table) {
        if (section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return _teachers.count;
        }
        else
        {
            NSString *key=[_keys objectAtIndex:section - 2];
            NSArray *row=[_students objectForKey:key];
            return row.count;
        }

    }
    
    return [_searchDatas[section][@"datas"] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleH(30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *headerView = [UIView new] ;
    headerView.backgroundColor = RGBA(230, 230, 230, 1);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(ScaleX(20), 0, DeviceW, ScaleH(30))];
    title.font = Font(15);
    title.textColor = CustomBlack;
    title.backgroundColor = [UIColor clearColor];
    [headerView addSubview:title];
    if (tableView == _table) {
        if (section == 0)
        {
            title.text = @"班级";
        }
        else if (section == 1)
        {
            title.text = @"老师";
        }
        else
        {
            title.text = [_keys objectAtIndex:section - 2];
        }
    }
    else
    {
        title.text = _searchDatas[section][@"key"];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(60);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    HSContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HSContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (tableView == _table) {
        [cell setIndexPath:indexPath keys:_keys teachers:_teachers students:_students];
    }
    else
    {
        cell.datas = _searchDatas[indexPath.section][@"datas"][indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView  == _table)
    {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 1)
            {
                
            }
            else
            {
                NSMutableDictionary *datas = [NSMutableDictionary dictionary];
                datas[@"user_name"] = [NSString stringWithFormat:@"%@群聊",[Base64 textFromBase64String:[Infomation readInfo][@"grade"]]];
                datas[@"tag_id"] = [Infomation readInfo][@"classTag"];
                datas[@"key_id"] = [Base64 textFromBase64String:[Infomation readInfo][@"classTag"]];
                datas[@"user_id"] = [[Base64 textFromBase64String:[Infomation readInfo][@"mobileTag"]] stringByAppendingString:[Base64 textFromBase64String:[Infomation readInfo][@"name"]]];
                datas[@"create_id"] = datas[@"user_id"];
                
                [self addNavigationWithPresentViewController:[[ChatListViewController alloc] initWithName:datas chatType:kGroup]];
                
            }
        }
        else if (indexPath.section == 1)
        {
            [self pushViewController:[[UserDetailViewController alloc] initWithDatas:_teachers[indexPath.row] type:kTeachers]];
        }
        else
        {
            NSString *key=[_keys objectAtIndex:indexPath.section - 2];
            //获取键所对应的值（数组）。
            NSArray *row=[_students objectForKey:key];
            
            [self pushViewController:[[UserDetailViewController alloc] initWithDatas:row[indexPath.row] type:kStudents]];
        }

    }
    else
    {
        NSDictionary *dic = _searchDatas[indexPath.section][@"datas"][indexPath.row];
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        if (dic[@"tacName"])
        {
                mDic[@"user_name"] = [Base64 textFromBase64String:dic[@"tacName"]] ;
                mDic[@"mobile"] = dic[@"teacPhone"];
                mDic[@"key_id"] = [mDic[@"mobile"] stringByAppendingString:mDic[@"user_name"]];
                mDic[@"user_id"] = [[Base64 textFromBase64String:[Infomation readInfo][@"mobileTag"]] stringByAppendingString:[Base64 textFromBase64String:[Infomation readInfo][@"name"]]];
                mDic[@"create_id"] = mDic[@"user_id"];

        }
        else
        {
            mDic[@"user_name"] = [[Base64 textFromBase64String:dic[@"stuName"]] stringByReplacingOccurrencesOfString:@"家长" withString:@""];
            mDic[@"mobile"] = dic[@"stuPhone"];
            mDic[@"key_id"] = [mDic[@"mobile"] stringByAppendingString:mDic[@"user_name"]];
            mDic[@"user_id"] = [[Base64 textFromBase64String:[Infomation readInfo][@"mobileTag"]] stringByAppendingString:[Base64 textFromBase64String:[Infomation readInfo][@"name"]]];
            mDic[@"create_id"] = mDic[@"user_id"];
        }
        [self addNavigationWithPresentViewController:[[ChatListViewController alloc] initWithName:mDic chatType:kMessage]];
    }
    
    
}


#pragma mark - 添加索引
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    
    tableView.sectionIndexBackgroundColor= [UIColor clearColor];
    tableView.sectionIndexColor = CustomBlue;
    NSMutableArray *keys = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    if (_keys.count)
    {
        [keys addObject:@"班"];
        [keys addObject:@"师"];
        [keys addObjectsFromArray:_keys];
    }
    return keys;
}


#pragma mark - 点击索引
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch)
    {
        [tableView scrollRectToVisible:_searchBar.frame animated:NO];
        [self.view makeToast:@"搜索" duration:.5 position:@"center"];
        return -1;
    }
    
    [self.view makeToast:title duration:.5 position:@"center"];
    return index - 1;
}


#pragma mark - 拉取数据
- (void)refreshDatas;
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xxCode"] = [Base64 textFromBase64String:[Infomation readInfo][@"schoolCode"]];
    params[@"classNo"] = [Base64 textFromBase64String:[Infomation readInfo][@"classCode"]];
    
    [BaseModel POST:addressServlet parameter:params   class:[BaseModel class]
            success:^(id data)
     {
         _students = [self setStudents:data[@"data"][@"students"]];
         _teachers = data[@"data"][@"teachers"];
         [_table.header endRefreshing];
         [self reloadTabData];
     }
            failure:^(NSString *msg, NSString *state)
     {
         
         
         [_table.header endRefreshing];
     }];
}

#pragma mark - 优化学生数据
- (NSMutableDictionary *)setStudents:(NSArray *)students
{
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    NSMutableArray *keys = [NSMutableArray array];
    
    for (NSDictionary *listData in students)
    {
        
        NSString *name = [Base64 textFromBase64String:listData[@"stuName"]];
        NSString *letter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])] uppercaseStringWithLocale:[NSLocale currentLocale]];
        if ([keys containsObject:letter]) {
            continue;
        }
        [keys addObject:letter];
    }
    _keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
    for (NSString *key in _keys)
    {
        
        NSMutableArray *values = [NSMutableArray array];
        for (NSDictionary *listData in students)
        {
            NSString *name = [Base64 textFromBase64String:listData[@"stuName"]];
            
            NSString *letter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])] uppercaseStringWithLocale:[NSLocale currentLocale]];
            if ([key isEqualToString:letter])
            {
                [values addObject:listData];
            }
        }
        
        if (values.count) {
            datas[key] = values;
        }
    }
    return datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
