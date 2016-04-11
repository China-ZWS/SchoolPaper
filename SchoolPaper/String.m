//
//  String.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-16.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "String.h"


/**
 *  @brief  线上服务地址
 */
NSString *const serverUrl = @"http://api.czcs100.com/";
//NSString *const serverUrl = @"http://192.168.143.35:8855/";
//NSString *const serverUrl = @"http://222.247.54.24:8855/";
//http://222.247.54.24:8855/
/**
 *  @brief  专家查询
 */


NSString *const findmanager = @"findmanager";
/**
 *  @brief  专家答疑-热门列表
 */
NSString *const getquizhots = @"getquizhots"; //参数：page_size(每页多少条),page_number（当前多少页）,key(搜索关键字段)

/**
 *  @brief 专家答疑-我参与的列表
 */
NSString *const getquizpartakes = @"getquizpartakes"; //参数：page_size(每页多少条),page_number（当前多少页）,key(搜索关键字段)

/**
 *  @brief  专家答疑-我的提问列表
 */
NSString *const getquizmys = @"getquizmys"; //参数：page_size(每页多少条),page_number（当前多少页）,key(搜索关键字段)

/**
 *  @brief  专家答疑评论列表
 */
NSString *const getquizbyid = @"getquizbyid"; //参数：quiz_id（答疑ID）

/**
 *  @brief  提交专家答疑评论
 */
NSString *const submitquizcomment = @"submitquizcomment"; //参数：quiz_id（答疑ID） comment_content(内容)

/**
 *  @brief  专家提问-提交问题
 */
NSString *const submitquiz = @"submitquiz";



/**
 *  @brief  学科答疑-我的问题列表
 */
NSString *const getstudys = @"getstudys";

/**
 *  @brief  学科答疑-提交问题
 */
NSString *const submitstudy = @"submitstudy";




/**
 *  @brief  注册
 */
NSString *const reguser = @"reguser";

/**
 *  @brief  获取动态密码
 */
NSString *const getdynapwd = @"getdynapwd";

/**
 *  @brief  登录
 */
NSString *const login = @"login";

/**
 *  @brief  获取验证码
 */
NSString *const getvalid = @"getvalid";


/**
 *  @brief  获取默认的方案
 */
NSString *const getdefaultscheme = @"getdefaultscheme";

/**
 *  @brief  加载活动信息
 */
NSString *const getactivitys = @"getactivitys";

/**
 *  @brief  活动报名
 */
NSString *const enrollactivity = @"enrollactivity";

/**
 *  @brief  分组加载资源
 */
NSString *const getres = @"getres";

/**
 *  @brief  加载应用详情
 */
NSString *const getapp = @"getapp";

/**
 *  @brief  加载视频详情
 */
NSString *const getvideo = @"getvideo";

/**
 *  @brief  加载音频详情;
 */
NSString *const getaudio = @"getaudio";

/**
 *  @brief  获取文档详情
 */
NSString *const getdocument = @"getdocument";


/**
 *  @brief  获取好友列表
 */
NSString *const getfriend = @"getfriend";

/**
 *  @brief  删除好友
 */
NSString *const deletefriend = @"deletefriend";

/**
 *  @brief  账号查找用户
 */
NSString *const findfriend = @"findfriend";

/**
 *  @brief  申请添加好友
 */
NSString *const requestfriend = @"requestfriend";

/**
 *  @brief  获取好友申请记录
 */
NSString *const getfriendrequest = @"getfriendrequest";

/**
 *  @brief  处理好友申请
 */
NSString *const disposefriendlog = @"disposefriendlog";

/**
 *  @brief  加载基础数据
 */
NSString *const getinitdata = @"getinitdata";

/**
 *  @brief  加载全部方案
 */
NSString *const getschemes = @"getschemes";

/**
 *  @brief  加载本地培训机构
 */
NSString *const getsellers = @"getsellers";

/**
 *  @brief  获取培训机构商品详情
 */
NSString *const getsellerproductbyid = @"getsellerproductbyid";

/**
 *  @brief  搜索培训机构商品信息
 */
NSString *const findsellerproduct = @"findsellerproduct";

/**
 *  @brief  获取好友动态
 */
NSString *const getfrienddynamic = @"getfrienddynamic";

/**
 *  @brief  发布好友动态
 */
NSString *const submitdynamic = @"submitdynamic";

/**
 *  @brief  发送即时消息
 */
NSString *const submitmsg = @"submitmsg";

/**
 *  @brief  发送群聊即时消息
 */
NSString *const submittagmsg = @"submittagmsg";


/**
 *  @brief  培训机构团购评价信息
 */
NSString *const sellerappraise = @"sellerappraise";

/**
 *  @brief  提交消费评价
 */
NSString *const submitsellerappraise = @"submitsellerappraise";

/**
 *  @brief  获取资源评价
 */
NSString *const getresappraise = @"getresappraise";

/**
 *  @brief  提交资源评价
 */
NSString *const submitresourceappraise = @"submitresourceappraise";

/**
 *  @brief  加载推荐资源
 */
NSString *const getrecommendres = @"getrecommendres";

/**
 *  @brief  上传头像
 */
NSString *const submittopimg = @"submittopimg";

/**
 *  @brief  资料编辑
 */
NSString *const submituserinfo = @"submituserinfo";

/**
 *  @brief  更新个性签名
 */
NSString *const submitautograph = @"submitautograph";


/**
 *  @brief  意见反馈
 */
NSString *const submitfeedback = @"submitfeedback";

/**
 *  @brief  删除好友动态
 */
NSString *const deletedynamic = @"deletedynamic";

/**
 *  @brief  获取广告
 */
NSString *const getadvertisement = @"getadvertisement";


/**
 *  @brief  获取课程列表
 */
NSString *const xClassSheduleServlet = @"xClassSheduleServlet";

/**
 *  @brief  获取学生作业信息
 */
NSString *const xHwServlet = @"xHwServlet";

/**
 *  @brief  获取通讯录信息
 */
NSString *const addressServlet = @"addressServlet";

/**
 *  @brief  获取学生考试成绩信息
 */
NSString *const xKscjServlet = @"xKscjServlet";

/**
 *  @brief 获通知信息
 */
NSString *const informServlet = @"informServlet";

/**
 *  @brief  获通知和作业新增数量
 */
NSString *const informAndXhwCountServlet = @"informAndXhwCountServlet";

/**
 *  @brief  获取学生评语信息
 */
NSString *const commentServlet = @"commentServlet";

/**
 *  @brief  获取考情信息
 */
NSString *const attendanceServlet = @"attendanceServlet";

/**
 *  @brief  获取资讯列表信息
 */
NSString *const mainNewsServlet = @"mainNewsServlet";

/**
 *  @brief  获取资讯详情信息
 */
NSString *const newServlet = @"newServlet";

/**
 *  @brief  获取圈子列表
 */
NSString *const circleServlet  = @"circleServlet";

/**
 *  @brief  获取班圈校圈帖子列表
 */
NSString *const schoolAndClassServlet = @"schoolAndClassServlet";

/**
 *  @brief  班圈校圈发帖
 */
NSString *const submitTieServlet = @"submitTieServlet";

/**
 *  @brief  班圈校圈发帖
 */
NSString *const submitTieReplyServlet = @"submitTieReplyServlet";

/**
 *  @brief  获取话题帖子列表
 */
NSString *const boardServlet = @"boardServlet";

NSString *const submitTieZanServlet = @"submitTieZanServlet";

/**
 *  @brief  话题圈帖子详情
 */
NSString *const boardInfoServlet = @"boardInfoServlet";

/**
 *  @brief  话题发帖
 */
NSString *const submitBoardServlet = @"submitBoardServlet";

/**
 *  @brief  超市分组加载资源
 */
NSString *const findresbystage = @"findresbystage";



