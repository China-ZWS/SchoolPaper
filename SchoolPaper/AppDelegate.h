//
//  AppDelegate.h
//  SchoolPaper
//
//  Created by 周文松 on 15/9/23.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <sqlite3.h>

@protocol AppDataSource <NSObject>

- (void)receiveWithInfo:(NSDictionary *)datas;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
@public
    NetworkStatus _networkStatus;
}

@property (nonatomic, weak) id<AppDataSource>delegate;
@property (nonatomic, readonly, assign) sqlite3 *dataBase; // 聊天表



/**
 *  @brief  添加聊天数据
 *
 *  @param datas 参数
 *
 *  @return 返回成功或者失败
 */
- (BOOL)addChatData:(id)datas chatType:(NSString *)chatType;



/**
 *  @brief  读取聊天缓存数据
 *
 *  @param datas    参数
 *  @param chatType 类型
 *
 *  @return 数据返回
 */
- (NSArray *)readChatDate:(id)datas chatType:(NSString *)chatType pageId:(int)pageId;

/**
 *  @brief  #pragma mark 单步执行SQL
 
 *
 *  @param sql     SQL 语句
 *  @param message 作用
 */
- (BOOL)execSQL:(NSString *)sql message:(NSString *)message;


/**
 *  @brief  网络发送消息
 *
 *  @param dic  参数
 *  @param file 文件
 */
- (void)submitmsg:(NSMutableDictionary *)dic file:(id)file chatType:(NSString *)chatType success:(void(^)())success;

/**
 *  @brief  更新发送状态
 *
 *  @param db         表名称
 *  @param sendStatus 发送状态值
 *  @param success     Block 成功回调
 */
- (void)update:(NSString *)db datas:(NSDictionary *)datas sendStatus:(NSString *)sendStatus success:(void(^)())success;














@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) NSDictionary *getinitdata;
@property (nonatomic) NSArray *datas;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

