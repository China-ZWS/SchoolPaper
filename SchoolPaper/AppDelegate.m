//
//  AppDelegate.m
//  SchoolPaper
//
//  Created by 周文松 on 15/9/23.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "AppDelegate.h"
#import "SliderMenuController.h"
#import "UserInfo.h"
#import "MainViewController.h"
#import "PJNavigationBar.h"
#import "PJNavigationViewController.h"
#import "APService.h"
#import "ChatTool.h"
#import "GuideViewController.h"

@interface AppDelegate ()
<ToolSingletonDelegate>
{
}
@end

@implementation AppDelegate

- (void)getinitDatas
{
    [BaseModel POST:getinitdata parameter:nil class:[BaseModel class]
            success:^(id data)
     {
         
         _getinitdata = data[@"data"];
         
     }
            failure:^(NSString *msg, NSString *state)
     {
         [self.window makeToast:msg];
     }];
    
}

-(void)getdefaultscheme
{
    
    [BaseModel POST:getdefaultscheme parameter:nil class:[BaseModel class]
            success:^(id data)
     {
         
         NSMutableArray *tmps = [NSMutableArray arrayWithArray:data[@"data"][@"stages"]];
         [tmps addObjectsFromArray:@[@{@"ageName":[Base64 base64StringFromText:@"活动专区"],@"edutypeName":[Base64 base64StringFromText:@""]},
                                     @{@"ageName":[Base64 base64StringFromText:@"本地"],@"edutypeName":[Base64 base64StringFromText:@"培训机构"]}]];
         _datas = tmps;
         [self.window makeToast:@"数据加载成功"];
     }
            failure:^(NSString *msg, NSString *state)
     {
         [self.window makeToast:msg];
     }];
}

- (void)reloadDatas:(NetworkStatus)status
{
    _networkStatus = status;
    
    switch (status)
    {
        case NotReachable:
        {
            //            [self.view makeToast:@"没有网络"];
        }
            // 没有网络连接
            break;
        case ReachableViaWWAN:
        {
            [self.window makeToast:@"蜂窝网络"];
        }
            break;
        case ReachableViaWiFi:
        {
            //            [self.view makeToast:@"wifi网络"];
        }
            // 使用WiFi网络
            break;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self getdefaultscheme];
    [self getinitDatas];

    [ToolSingleton getInstance].delegate = self;
    
    [[ToolSingleton getInstance] createNetworkSniffer];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    BOOL isNOFirst = [[kUserDefaults objectForKey:@"isNOFirst"] boolValue];
    if (isNOFirst)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];

        PJNavigationViewController *nav = [[PJNavigationViewController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
        MainViewController *main = [MainViewController new];
        nav.viewControllers = @[main];
        
        UserInfo *info = [UserInfo new];
        info.main = main;
        
        SliderMenuController *ctr = [[SliderMenuController alloc] initWithLeftView:info centerView:nav rightView:[UIViewController new]];
        ctr.leftView = info;
        ctr.homeDelegate = main;
        info.menu = ctr;
        main.menu = ctr;
        self.window.rootViewController = ctr;
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        self.window.rootViewController = [[GuideViewController alloc] initWithSuccess:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];

            PJNavigationViewController *nav = [[PJNavigationViewController alloc] initWithNavigationBarClass:[PJNavigationBar class] toolbarClass:nil];
            MainViewController *main = [MainViewController new];
            nav.viewControllers = @[main];
            
            UserInfo *info = [UserInfo new];
            info.main = main;
            
            SliderMenuController *ctr = [[SliderMenuController alloc] initWithLeftView:info centerView:nav rightView:[UIViewController new]];
            ctr.leftView = info;
            ctr.homeDelegate = main;
            info.menu = ctr;
            main.menu = ctr;
            
            self.window.rootViewController = ctr;
        }];
//        [kUserDefaults setValue:[NSNumber numberWithBool:YES] forKey:@"isNOFirst"];
//        [kUserDefaults synchronize];
    }
    
     [self.window makeKeyAndVisible];
    
#pragma mark - 极光推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];
    
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
    [self openDataBase];

    
    return YES;
}

- (void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    
    if ([APService registrationID]) {
        NSLog(@"get RegistrationID");
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    
    NSDictionary *userInfo = [notification userInfo];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    
    NSData *data=[extra[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *send_id = [dict[@"user_id"] stringValue];
    NSString *my_id = [[Infomation readInfo][@"id"] stringValue];
    
    if ([send_id isEqualToString:my_id])
    {
        return;
    }
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    
    NSString *type = dict[@"msg_type"];
    NSString *msg = nil;
    
    if ([type isEqualToString:@"AUDIO"])
    {
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
        NSString *date = [dateFormatter stringFromDate:[NSDate date]];
        
        //将数据保存到本地指定位置
        msg = [date stringByAppendingString:@"-MySound.mp3"];
        
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        NSString *caches = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] ;
        NSString *audioVoiceSavePath = [caches stringByAppendingPathComponent:@"Recording"];
        if(![fileManager fileExistsAtPath:audioVoiceSavePath ])
        {
            [fileManager createDirectoryAtPath:audioVoiceSavePath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error)
            {
                NSLog(@"%@",error);
            }
        }
        
        NSURL *url = [[NSURL alloc]initWithString:[Base64 textFromBase64String:dict[@"msg_content"]]];
        
        [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:url]
                                           queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             NSLog(@"bool = %d", [data writeToFile:[audioVoiceSavePath stringByAppendingPathComponent:msg] atomically:YES]);
         }];
    }
    else
    {
        msg = [Base64 textFromBase64String:dict[@"msg_content"]];
    }
    NSString *msg_length = dict[@"msg_length"];
    NSString *mobile = dict[@"user_mobile"];
    NSString *name = dict[@"user_name"];
    NSString *topImg = dict[@"user_top"];
    NSString *date = dict[@"msg_date"];
    NSString *user_id = [[Base64 textFromBase64String:[Infomation readInfo][@"mobileTag"]] stringByAppendingString:[Base64 textFromBase64String:[Infomation readInfo][@"name"]]];
    NSString *send_status = @"0";
    
    NSString *model_type = extra[@"model_type"];
    if ([model_type isEqualToString:@"MESSAGE"])
    {
        NSString *key_id = [mobile stringByAppendingString:name];
        NSString *create_id = key_id;
        
        datas[@"message"] = msg;
        datas[@"type"] = type;
        datas[@"msg_length"] = msg_length;
        datas[@"mobile"] = mobile;
        datas[@"user_name"] = name;
        datas[@"user_top"] = topImg;
        datas[@"date"] = date;
        datas[@"user_id"] = user_id;
        datas[@"create_id"] = create_id;
        datas[@"send_status"] = send_status;
        datas[@"key_id"] = key_id;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO SingleChat (message, msg_type, msg_length, user_mobile, user_name, user_top, msg_date, user_id, key_id, create_id, send_status) VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",msg, type, msg_length, mobile, name, topImg, date, user_id, key_id, create_id, send_status];
        
        
        [self execSQL:insertSQL message:@"单聊消息添加"];
        [_delegate receiveWithInfo:datas];
    }
    else if ([model_type isEqualToString:@"TAG"])
    {
        
        NSString *key_id  = [Base64 textFromBase64String:[Infomation readInfo][@"classTag"]];
        NSString *create_id = [NSString stringWithFormat:@"%@",dict[@"user_id"]];
        datas[@"message"] = msg;
        datas[@"type"] = type;
        datas[@"msg_length"] = msg_length;
        datas[@"mobile"] = mobile;
        datas[@"user_name"] = name;
        datas[@"user_top"] = topImg;
        datas[@"date"] = date;
        datas[@"user_id"] = user_id;
        datas[@"create_id"] = create_id;
        datas[@"send_status"] = send_status;
        datas[@"key_id"] = key_id;
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO GroupChat(message, msg_type, msg_length, user_mobile, user_name, user_top, msg_date, user_id, key_id, create_id, send_status) VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",msg, type, msg_length, mobile, name, topImg, date, user_id, key_id, create_id, send_status];
        [self execSQL:insertSQL message:@"群聊消息添加"];
        [_delegate receiveWithInfo:datas];
    }
    
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}



- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Required
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);

}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



#pragma mark - 数据库路径
#define baseName @"baseData.sqlite3"
- (NSString *)dataBasePath
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] ;
    return [filePath stringByAppendingPathComponent:baseName];
}

#pragma mark - 打开数据库或（创建数据库）
- (void)openDataBase
{
    NSString *name = [self dataBasePath];
    if (sqlite3_open([name UTF8String], &_dataBase) != SQLITE_OK)
    {
        NSLog(@"error to create dataBase");
        _dataBase = NULL;
    }
    char *errMsg = NULL;
    
    
    
    
    NSString *singleChat = @"CREATE TABLE IF NOT EXISTS SingleChat (ID INTEGER PRIMARY KEY AUTOINCREMENT, message TEXT, msg_type TEXT, msg_length TEXT, user_mobile TEXT, user_name TEXT,user_top TEXT, msg_date TEXT, user_id TEXT, key_id TEXT, create_id TEXT, send_status TEXT)";
    /**
     *  在iOS 中执行sql语句
     */
    if (sqlite3_exec(_dataBase, [singleChat UTF8String], NULL, NULL, &errMsg))
    {
        NSLog(@"singleChat error to exec sql %s", errMsg);
    }
    
    NSString *groupChat = @"CREATE TABLE IF NOT EXISTS GroupChat (ID INTEGER PRIMARY KEY AUTOINCREMENT, message TEXT, msg_type TEXT, msg_length TEXT, user_mobile TEXT, user_name TEXT,user_top TEXT, msg_date TEXT, user_id TEXT, key_id TEXT, create_id TEXT, send_status TEXT)";
    
    /**
     *  在iOS 中执行sql语句
     */
    if (sqlite3_exec(_dataBase, [groupChat UTF8String], NULL, NULL, &errMsg))
    {
        NSLog(@"groupChat error to exec sql %s", errMsg);
    }
}

#pragma mark - 关闭数据库
- (void)closeDatabase
{
    if (_dataBase)
    {
        sqlite3_close(_dataBase);
    }
}

- (void)saveAllChatListData:(id)datas
{
    
}

- (NSArray *)readChatDate:(id)datas chatType:(NSString *)chatType pageId:(int)pageId;
{
    
    
    NSString *sql = nil;
    if ([chatType isEqualToString:@"message"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM SingleChat WHERE key_id = ? and user_id = ?"];
    }
    else if ([chatType isEqualToString:@"group"])
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM GroupChat WHERE key_id = ? and user_id = ?"];
    }
    
    sqlite3_stmt *statment = NULL;
    
    NSMutableArray *array = [NSMutableArray array];
    if (sqlite3_prepare_v2(_dataBase, [sql UTF8String], -1, &statment, NULL) ==  SQLITE_OK)
    {
        
        sqlite3_bind_text(statment, 1, [datas[@"key_id"] UTF8String], -1, NULL);
        sqlite3_bind_text(statment, 2, [datas[@"user_id"] UTF8String], -1, NULL);
        
        while (sqlite3_step(statment) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"ID"]=[NSString stringWithFormat:@"%d",sqlite3_column_int(statment, 0)];//取nsstring数据
            dic[@"message"]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 1)];//取nsstring数据
            dic[@"type"]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 2)];//取nsstring数据
            dic[@"msg_length"] = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 3)];//取nsstring数据
            dic[@"user_name"]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 5)];//取nsstring数据
            dic[@"topImg"]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 6)];//取nsstring数据
            dic[@"date"]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 7)];//取nsstring数据
            dic[@"user_id"]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 8)];//取nsstring数据
            dic[@"key_id"]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 9)];//取nsstring数据
            dic[@"create_id"] = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 10)];//取nsstring数据
            dic[@"send_status"] = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 11)];//取nsstring数据
            [array addObject:dic];
        }
    }
    
    return array;
}



#pragma mark - 添加新消息
- (BOOL)addChatData:(id)datas chatType:(NSString *)chatType;
{
    
    NSString *db = nil;
    if ([chatType isEqualToString:@"message"]) {
        db = @"SingleChat";
    }
    else if ([chatType isEqualToString:@"group"])
    {
        db = @"GroupChat";
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@(message, msg_type, msg_length, user_mobile, user_name, user_top, msg_date, user_id, key_id, create_id, send_status) VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", db, datas[@"message"], datas[@"type"], datas[@"msg_length"], datas[@"mobile"], datas[@"user_name"], datas[@"topImg"], date, datas[@"user_id"], datas[@"key_id"], datas[@"create_id"], datas[@"send_status"]];
    
    return [self execSQL:insertSQL message:@"聊天数据addChatData"];
}




- (BOOL)execSQL:(NSString *)sql message:(NSString *)message
{
    // 执行SQL语句
    
    char *errmsg = NULL;
    if ( sqlite3_exec(_dataBase, [sql UTF8String], NULL, NULL, &errmsg) == SQLITE_OK) {
        DLog(@"%@成功!", message);
        return YES;
    } else {
        // C语言中字符串输出应该用%s
        DLog(@"%@失败 - %s", message, errmsg);
        
        return NO;
    }
    
    
}


- (void)submitmsg:(NSMutableDictionary *)dic file:(id)file chatType:(NSString *)chatType success:(void(^)())success;
{
    
    
    NSString *account = [Infomation readInfo][@"id"];
    NSString *secret_key = [Infomation readInfo][@"secret_key"];
    NSString *code = @"1";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"code"] = code;
    params[@"secret_key"] =secret_key;
    params[@"account"] = account;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = dic[@"type"];
    param[@"name"] = [Base64 base64StringFromText:dic[@"user_name"]];
    
    NSString *db = nil;
    NSString *url = nil;
    if ([chatType isEqualToString:@"message"])
    {
        db = @"SingleChat";
        param[@"mobile"] = dic[@"mobile"];
        url = submitmsg;
    }
    else
    {
        db = @"GroupChat";
        param[@"tag_id"] = dic[@"tag_id"];
        url = submittagmsg;
    }
    
    
    if ([dic[@"type"] isEqualToString:@"TXT"])
    {
      
        param[@"content"] = [Base64 base64StringFromText:dic[@"message"]];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        params[@"param"] = jsonString;
        [ZWSRequest postRequestWithURL:[serverUrl stringByAppendingString:url] postParems:params images:nil  success:^(id datas)
         {
             dic[@"send_status"] = @"0";
             
             [self update:db datas:dic sendStatus:@"0" success:^()
              {
                  success();
              }];
         }
                               failure:^(NSString *msg)
         {
             dic[@"send_status"] = @"2";
             NSLog(@"%@",msg);
             success();
         }];
    }
    else if ([dic[@"type"] isEqualToString:@"IMG"])
    {
        param[@"content"] = [Base64 base64StringFromText:@""];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        params[@"param"] = jsonString;
        [ZWSRequest postRequestWithURL:[serverUrl stringByAppendingString:url] postParems:params images:@[file]  success:^(id datas)
         {
             dic[@"send_status"] = @"0";
             [self update:db datas:dic sendStatus:@"0" success:^()
              {
                  success();
              }];
         }
                               failure:^(NSString *msg)
         {
             dic[@"send_status"] = @"2";
             success();
         }];
    }
    else if ([dic[@"type"] isEqualToString:@"AUDIO"])
    {
        
        
        param[@"content"] = [Base64 base64StringFromText:dic[@"msg_length"]];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        params[@"param"] = jsonString;
        NSString *caches = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] ;
        NSString *audioVoiceSavePath = [caches stringByAppendingPathComponent:@"Recording"];
        NSString *soundPath = [audioVoiceSavePath stringByAppendingPathComponent:file];
        NSData *data = [NSData dataWithContentsOfFile:soundPath];
        [ZWSRequest postRequestWithURL:[serverUrl stringByAppendingString:url] filename:@"fsdsada" mimeType:@"audio/mpeg" data:data parmas:params success:^(id datas)
         {
             dic[@"send_status"] = @"0";
             [self update:db datas:dic sendStatus:@"0" success:^()
              {
                  success();
              }];
         }
                               failure:^(NSString *msg)
         {
             NSLog(@"%@",msg);
             
             dic[@"send_status"] = @"2";
             success();
         }];
    }
    
}

- (void)update:(NSString *)db datas:(NSDictionary *)datas sendStatus:(NSString *)sendStatus success:(void(^)())success
{
    //    sqlite3_int64 ID  = sqlite3_last_insert_rowid(_dataBase);
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set send_status = '%@' where ID = '%@'",db,sendStatus,datas[@"ID"]];
    
    if ([self execSQL:sql message:@"跟新聊天数据"]) {
        success();
    }
    
}




- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.talkweb.SchoolPaper" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SchoolPaper" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SchoolPaper.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
