//
//  ChatListViewController.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-23.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "ChatListViewController.h"
#import "AppDelegate.h"
#import "ChatInputView.h"
#import "ChatCell.h"
#import "BasePhotoPickerManager.h"
#import "VoiceManager.h"

@interface ChatListViewController ()
<ChatInputViewDelegate, AppDataSource,ChatCellDelegate>
{
    NSMutableDictionary *_dic;
    NSMutableArray *_datas;
    ChatType _chatType;
    NSInteger _pageId;

    
}
@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation ChatListViewController



- (id)initWithName:(id)datas  chatType:(ChatType)chatType;
{
    if ((self = [super init]))
    {
        _chatType = chatType;
        _dic = datas;
        _datas = [NSMutableArray array];
        NSArray *temps = nil;
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        if (_chatType == kMessage) {
            temps = [app readChatDate:_dic chatType:@"message" pageId:0];
            [_datas addObjectsFromArray:temps];
            
        }
        else if (_chatType == kGroup)
        {
            temps = [app readChatDate:_dic chatType:@"group" pageId:0];
            [_datas addObjectsFromArray:temps];
        }

        [self.navigationItem setNewTitle:datas[@"user_name"]];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"back.png"];
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)back
{
    [self dismissViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // Do any additional setup after loading the view.
    ChatInputView *input = [ChatInputView inputWithScrollView:_table];
    input.fromController = self;
    input.delegate = self;
    input.font = Font(18);
    input.type = kDefult | kImage | kSpeech;
    input.hasInstantMessage = YES;
    [self.view addSubview:input];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.delegate = self;
    sqlite3_int64 ID  = sqlite3_last_insert_rowid(app.dataBase);
    
    _pageId = (NSInteger)ID;

    
//    _header = [MJRefreshHeaderView header];
//    _header.scrollView = _table;
//    _header.delegate = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_header beginRefreshing];
//        
//    });
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat inset = ScaleH(10);
    CGFloat imgInset = ScaleW(60);
    
    id msg = _datas[indexPath.row][@"message"];
    
    CGSize msgSize = CGSizeZero;
    NSString *type = _datas[indexPath.row][@"type"];
    
    if ([type isEqualToString:@"TXT"])
    {
        msgSize = [NSObject getSizeWithText:msg font:Font(15) maxSize:CGSizeMake(DeviceW - inset * 9 - imgInset, MAXFLOAT)];
    }
    else if ([type isEqualToString:@"IMG"])
    {
        msgSize = CGSizeMake(ScaleW(150), ScaleH(150));
    }

    CGFloat backHeight = msgSize.height + inset * 2;
    
    CGFloat contentHeight = 0;
    if (backHeight > imgInset) {
        contentHeight = inset * 3 + backHeight;
    }
    else
    {
        contentHeight = inset * 3 + imgInset;
    }
    
    NSString *create_id = _datas[indexPath.row][@"create_id"];
    NSString *my_id = [[Base64 textFromBase64String:[Infomation readInfo][@"mobileTag"]] stringByAppendingString:[Base64 textFromBase64String:[Infomation readInfo][@"name"]]];
    if (![create_id isEqualToString:my_id])
    {
        contentHeight += Font(15).lineHeight + inset;
    }
    
    
    return contentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    
    cell.datas = _datas[indexPath.row];
    
    
    
    return cell;
}




- (BOOL)inputView:(ChatInputView *)inputView inputOfText:(NSString *)text;
{
//   , USER_MOBILE, USER_NAME, USER_TOP
    
    if (!text.length) {
        return NO;
    }
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    datas[@"message"] = text;
    datas[@"type"] = @"TXT";
    datas[@"msg_length"] = @"";
    datas[@"send_status"] = @"1";
    [datas addEntriesFromDictionary:_dic];
    [_datas addObject:datas];
    [self reloadTabData];
    
    
    NSMutableDictionary *db = [NSMutableDictionary dictionaryWithDictionary:datas];
    db[@"send_status"] = @"2";
    
    
    
    
    
    
    NSString *chatType = nil;
    if (_chatType == kMessage) {
        
        chatType = @"message";
    }
    else if (_chatType == kGroup)
    {
        chatType = @"group";
    }

    if (![app addChatData:db chatType:chatType])
    {
        [self.view makeToast:@"发送失败"];
        
        return NO;
    }
    sqlite3_int64 ID  = sqlite3_last_insert_rowid(app.dataBase);
    datas[@"ID"] = [NSString stringWithFormat:@"%lld",ID];
    [self sendDatas:datas file:nil chatType:chatType];

    return YES;
}





- (BOOL)inputView:(ChatInputView *)inputView inputOfImage:(UIImage *)image;
{
 
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString *locationString=[dateFormatter stringFromDate:senddate];
    [[SDImageCache sharedImageCache] storeImage:image forKey:locationString];
    
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    datas[@"message"] = locationString;
    datas[@"type"] = @"IMG";
    datas[@"msg_length"] = @"";
    datas[@"send_status"] = @"1";
    [datas addEntriesFromDictionary:_dic];
    [_datas addObject:datas];
    [self reloadTabData];

    
    NSMutableDictionary *db = [NSMutableDictionary dictionaryWithDictionary:datas];
    db[@"send_status"] = @"2";
    NSString *chatType = nil;
    if (_chatType == kMessage) {
        
        chatType = @"message";
    }
    else if (_chatType == kGroup)
    {
        chatType = @"group";
    }
    
    if (![app addChatData:db chatType:chatType])
    {
        [self.view makeToast:@"发送失败"];
        return NO;
    }
    sqlite3_int64 ID  = sqlite3_last_insert_rowid(app.dataBase);
    datas[@"ID"] = [NSString stringWithFormat:@"%lld",ID];

    [self sendDatas:datas file:image chatType:chatType];

    
    return YES;
    
 
}

- (BOOL)inputView:(ChatInputView *)inputView inputOfSound:(id )sound time:(NSString *)time;
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    datas[@"message"] = sound;
    datas[@"type"] = @"AUDIO";
    datas[@"send_status"] = @"1";
    datas[@"msg_length"] = time;
    [datas addEntriesFromDictionary:_dic];
    [_datas addObject:datas];
    [self reloadTabData];


    
    NSMutableDictionary *db = [NSMutableDictionary dictionaryWithDictionary:datas];
    db[@"send_status"] = @"2";
    NSString *chatType = nil;
    if (_chatType == kMessage) {
        
        chatType = @"message";
    }
    else if (_chatType == kGroup)
    {
        chatType = @"group";
    }
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;

    if (![app addChatData:db chatType:chatType])
    {
        [self.view makeToast:@"发送失败"];
        return NO;
    }

    sqlite3_int64 ID  = sqlite3_last_insert_rowid(app.dataBase);
    datas[@"ID"] = [NSString stringWithFormat:@"%lld",ID];

    [self sendDatas:datas file:sound chatType:chatType];
    
 
    
    return YES;
}

#pragma mark - 发送消息
- (void)sendDatas:(id)datas file:(id)file chatType:(NSString *)chatType
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [app submitmsg:datas file:file  chatType:chatType success:^()
     {
         [self reloadTabData];
     }];
    
}

#pragma mark - 从新发送消息
- (void)reSend:(id)datas 
{
  
    NSString *db = nil;

    NSString *chatType = nil;
    if (_chatType == kMessage)
    {
        
        chatType = @"message";
        db = @"SingleChat";
    }
    else if (_chatType == kGroup)
    {
        chatType = @"group";
        datas[@"tag_id"] = [Infomation readInfo][@"classTag"];
        db = @"GroupChat";

    }

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [app update:db datas:datas sendStatus:@"1" success:^{
    
        datas[@"send_status"] = @"1";
        [self reloadTabData];
    }];
    [app submitmsg:datas file:datas[@"message"]  chatType:chatType success:^()
     {
         [self reloadTabData];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveWithInfo:(NSDictionary *)datas
{
   
    if (![datas[@"key_id"] isEqualToString:_dic[@"key_id"]])
    {
        //如果接受的消息不是这个key 就不刷新；
        return;
    }
    [_datas addObject:datas];
    [self reloadTabData];
    if (_table.contentSize.height - CGRectGetHeight(_table.frame) > 0)
    {
        [_table setContentOffset:CGPointMake(CGRectGetMinX(_table.frame), _table.contentSize.height - CGRectGetHeight(_table.frame)) animated:YES];
    }

}

- (void)playSound:(NSString *)sound
{
    
    VoiceManager *vm = [VoiceManager shared];
    [vm getVoiceDuration:sound];
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
