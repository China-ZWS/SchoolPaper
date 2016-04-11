//
//  DataConfigManager.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-13.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//


@interface DataConfigManager : NSObject
+ (NSDictionary *)returnRoot;
+ (NSArray *)getMainConfigList;



/**
 *  @brief  获取设置列表本地数据
 *
 *  @return 返回设置列表本地数据
 */
+ (NSArray *)getSetConfigList;


/**
 *  @brief  获取学科答疑的所有年级选项
 *
 *  @return 返回学科答疑的所有年级选项
 */
+ (NSArray *)getLocalGrades;

/**
 *  @brief  获取学科答疑所有科目选项
 *
 *  @return 返回学科答疑所有科目选项
 */
+ (NSArray *)getLocalSubjects;

/**
 *  @brief  得到家校消息列表
 *
 *  @return 返回得到的列表
 */
+ (NSArray *)getHSMsgList;

/**
 *  @brief  归档作业最新一条数据
 *
 *  @param dic 要归档的数据
 */
+(void)archiveWithHomeWorkDatas:(NSDictionary *)dic;

/**
 *  @brief  归档评论最后一条数据
 *
 *  @param dic 要归档的数据
 */
+ (void)archiveWithHomeCommentData:(NSDictionary *)dic;

/**
 *  @brief  归档资讯时间戳
 *
 *  @param time 时间戳
 */
+ (void)archiveWithNewsTime:(NSString *)time;

/**
 *  @brief  得到时间戳
 */
+ (NSString *)getArchiveWithNewsTime;

/**
 *  @brief  归档家校资讯数据
 *
 *  @param datas 要归档的数据
 */
+ (void)archiveWithNewsDatas:(NSArray *)datas;


/**
 *  @brief  得到家校资讯归档的数据
 *
 */
+ (NSArray *)getArchiveWithNewsDatas;



/**
 *  @brief  归档通知最新一条数据
 */
+ (void)archiveWithNoticeDatas:(NSDictionary *)dic;

/**
 *  @brief  归档学科答疑提问草稿箱
 */
+ (BOOL)archiveWithDraftsDatas:(NSDictionary *)dic;

/**
 *  @brief  得到归档学科答疑提问草稿箱
 *
 *  @return 返回数据
 */
+ (NSArray *)getArchiveWithDraftsDatas;


/**
 *  @brief  归档首页轮播图的数据
 *
 *  @param datas 要归档的数据
 */
+ (void)archiveWithMainBannerDatas:(NSArray *)datas;


/**
 *  @brief  得到首页轮播图数据
 *
 *  @return 返回数据
 */
+ (NSArray *)getArchiveWithMainBannerDatas;
@end
