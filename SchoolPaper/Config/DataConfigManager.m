

//
//  DataConfigManager.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "DataConfigManager.h"


@implementation DataConfigManager


+ (NSDictionary *)returnRoot
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *root=[[NSDictionary alloc] initWithContentsOfFile:path];
    return root;
}

#pragma 得到本地tabbar 数据
+(NSArray *)getMainConfigList;
{
        
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"MainTab"]];
    return data;
}

#pragma 得到本地设置数据
+ (NSArray *)getSetConfigList;
{
    NSDictionary * root = [self returnRoot];
    NSArray *data=[[NSArray alloc] initWithArray:[root objectForKey:@"Set"]];
    return data;
}





#pragma mark - 根目录
+ (NSString *)rootFilePath
{
    NSString *user = [NSString stringWithFormat:@"%@",[Infomation readInfo][@"id"]?[Infomation readInfo][@"id"]:@"游客"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] ;
    filePath = [filePath stringByAppendingPathComponent:user];
    
    
    if(![fileManager fileExistsAtPath:filePath ])
    {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            NSLog(@"%@",error);
        }
    }
    return filePath;
}


#pragma mark ----------------------------家校--------------------------------

#pragma mark - 获取家校消息固定列表
+ (NSArray *)getHSMsgList;
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"HSData" ];
    NSArray *datas;
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSDictionary * root = [self returnRoot];
        datas = root[@"HSData"];
        [NSKeyedArchiver archiveRootObject:datas toFile:path];
    }
    else
    {
        datas = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
     return datas;
}

#pragma mark - 归档作业最新一条数据
+(void)archiveWithHomeWorkDatas:(NSDictionary *)dic
{
    if (!dic) {
        return;
    }
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"HomeWorkDatas"];
    [NSKeyedArchiver archiveRootObject:dic toFile:path];
    
    NSMutableArray *datas = [NSMutableArray array];
    NSArray *list = [self getHSMsgList];
    
    for (int i = 0; i < list.count; i ++)
    {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:list[i]];
        if (i == 0) {
            tempDic[@"content"] = [Base64 textFromBase64String:dic[@"hwNr"]];
            tempDic[@"title"] = dic[@"hwName"];
            tempDic[@"date"] = dic[@"hwDate"];
        }
        [datas addObject:tempDic];
    }
    
    NSString *HSDataPath = [[self rootFilePath] stringByAppendingPathComponent:@"HSData" ];
    [NSKeyedArchiver archiveRootObject:datas toFile:HSDataPath];
}


#pragma mark - 解档作业最新一条数据
+ (NSDictionary *)getArchiveWithHomeWorkDatas
{
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"HomeWorkDatas"];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}


#pragma mark - 归档资讯的时间戳
+ (void)archiveWithNewsTime:(NSString *)time
{
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"newsTime"];
    if (!time)
    {
        NSDate *senddate=[NSDate date];
        NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *locationString=[dateFormatter stringFromDate:senddate];
        [NSKeyedArchiver archiveRootObject:locationString toFile:path];
        return;
    }
    
    [NSKeyedArchiver archiveRootObject:time toFile:path];

}

#pragma mark - 得到资讯时间戳
+ (NSString *)getArchiveWithNewsTime
{
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"newsTime"];
    NSString *time = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!time.length) {
        time = @"";
    }
    
    return time;
}

#pragma mark - 归档家校资讯最后一条数据
+ (void)archiveWithNewsDatas:(NSArray *)datas
{
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"newsDats"];
    [NSKeyedArchiver archiveRootObject:datas toFile:path];
    
    
    NSMutableArray *HSDataDatas = [NSMutableArray array];
    NSArray *list = [self getHSMsgList];
    
    for (int i = 0; i < list.count; i ++)
    {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:list[i]];
        if (i == 3) {
            NSDictionary *newDic = datas[0][@"news"][0];
            tempDic[@"content"] = datas[0][@"mainTime"];
            tempDic[@"title"] = newDic[@"newsTitle"];
        }
        [HSDataDatas addObject:tempDic];
    }
    
    NSString *HSDataPath = [[self rootFilePath] stringByAppendingPathComponent:@"HSData" ];
    [NSKeyedArchiver archiveRootObject:HSDataDatas toFile:HSDataPath];
}



#pragma mark - 得到家校资讯归档的数据
+ (NSArray *)getArchiveWithNewsDatas;
{
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"newsDats"];
    NSArray *datas = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return datas;
}


#pragma mark - 归档老师说最新一条数据
+ (void)archiveWithNoticeDatas:(NSDictionary *)dic
{
    if (!dic) {
        return;
    }
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"NoticeDatas"];
    [NSKeyedArchiver archiveRootObject:dic toFile:path];
    
    NSMutableArray *datas = [NSMutableArray array];
    NSArray *list = [self getHSMsgList];
    
    for (int i = 0; i < list.count; i ++)
    {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:list[i]];
        if (i == 2) {
            tempDic[@"content"] = dic[@"msg"];
            tempDic[@"title"] = dic[@"subject"];
            tempDic[@"date"] = dic[@"informtime"];
        }
        [datas addObject:tempDic];
    }
    
    NSString *HSDataPath = [[self rootFilePath] stringByAppendingPathComponent:@"HSData" ];
    [NSKeyedArchiver archiveRootObject:datas toFile:HSDataPath];    
}

#pragma mark - 解档通知最新一条数据
+ (NSDictionary *)getArchiveWithNoticeDatas
{
    NSString *path = [[self rootFilePath] stringByAppendingPathComponent:@"NoticeDatas"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}















@end
