//
//  String.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-16.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//


/**
 *  @brief  线上服务地址
 */
extern NSString *const serverUrl;

/**
 *  @brief  专家查询
 */
extern NSString *const findmanager;


/**
 *  @brief  专家答疑-热门列表
 */
extern NSString *const getquizhots;

/**
 *  @brief 专家答疑-我参与的列表
 */
extern NSString *const getquizpartakes;

/**
 *  @brief  专家答疑-我的提问列表
 */
extern NSString *const getquizmys;

/**
 *  @brief  专家答疑评论列表
 */
extern NSString *const getquizbyid; //参数：quiz_id（答疑ID）

/**
 *  @brief  提交专家答疑评论
 */
extern NSString *const submitquizcomment; //参数：quiz_id（答疑ID） comment_content(内容)


/**
 *  @brief  专家提问-提交问题
 */
extern NSString *const submitquiz;



/**
 *  @brief  学科答疑-我的问题列表
 */
extern NSString *const getstudys;


/**
 *  @brief  学科答疑-提交问题
 */
extern NSString *const submitstudy;


/**
 *  @brief  注册
 */
extern NSString *const reguser ;

/**
 *  @brief  获取动态密码
 */
extern NSString *const getdynapwd;

/**
 *  @brief  登录
 */
extern NSString *const login;

/**
 *  @brief  获取验证码
 */
extern NSString *const getvalid;


/**
 *  @brief  获取默认的方案
 */
extern NSString *const getdefaultscheme;

/**
 *  @brief  加载活动信息
 */
extern NSString *const getactivitys;

/**
 *  @brief  活动报名
 */
extern NSString *const enrollactivity;

/**
 *  @brief  分组加载资源
 */
extern NSString *const getres;

/**
 *  @brief  加载应用详情
 */
extern NSString *const getapp;

/**
 *  @brief  加载视频详情
 */
extern NSString *const getvideo;

/**
 *  @brief  加载音频详情;
 */
extern NSString *const getaudio;

/**
 *  @brief  获取文档详情
 */
extern NSString *const getdocument;

/**
 *  @brief  获取好友列表
 */
extern NSString *const getfriend;

/**
 *  @brief  删除好友
 */
extern NSString *const deletefriend;

/**
 *  @brief  账号查找用户
 */
extern NSString *const findfriend;

/**
 *  @brief  申请添加好友
 */
extern NSString *const requestfriend;

/**
 *  @brief  获取好友申请记录
 */
extern NSString *const getfriendrequest;

/**
 *  @brief  处理好友申请
 */
extern NSString *const disposefriendlog;

/**
 *  @brief  加载基础数据
 */
extern NSString *const getinitdata;

/**
 *  @brief  加载全部方案
 */
extern NSString *const getschemes;

/**
 *  @brief  加载本地培训机构
 */
extern NSString *const getsellers;

/**
 *  @brief  获取培训机构商品详情
 */

extern NSString *const getsellerproductbyid;

/**
 *  @brief  搜索培训机构商品信息
 */
extern NSString *const findsellerproduct;

/**
 *  @brief  获取好友动态
 */
extern NSString *const getfrienddynamic;

/**
 *  @brief  发布好友动态
 */
extern NSString *const submitdynamic;

/**
 *  @brief  发送即时消息
 */
extern NSString *const submitmsg;

/**
 *  @brief  发送群聊即时消息
 */
extern NSString *const submittagmsg;

/**
 *  @brief  培训机构团购评价信息
 */
extern NSString *const sellerappraise;

/**
 *  @brief  提交消费评价
 */
extern NSString *const submitsellerappraise;

/**
 *  @brief  获取资源评价
 */
extern NSString *const getresappraise;

/**
 *  @brief  提交资源评价
 */
extern NSString *const submitresourceappraise;

/**
 *  @brief  加载推荐资源
 */
extern NSString *const getrecommendres;

/**
 *  @brief  上传头像
 */
extern NSString *const submittopimg;

/**
 *  @brief  资料编辑
 */
extern NSString *const submituserinfo;

/**
 *  @brief  更新个性签名
 */
extern NSString *const submitautograph;


/**
 *  @brief  意见反馈
 */
extern NSString *const submitfeedback;

/**
 *  @brief  删除好友动态
 */
extern NSString *const deletedynamic;

/**
 *  @brief  获取广告
 */
extern NSString *const getadvertisement;

/**
 *  @brief  获取课程列表
 */
extern NSString *const xClassSheduleServlet;

/**
 *  @brief  获取学生作业信息
 */
extern NSString *const xHwServlet;

/**
 *  @brief  获取通讯录信息
 */
extern NSString *const addressServlet;

/**
 *  @brief  获取学生考试成绩信息
 */
extern NSString *const xKscjServlet;

/**
 *  @brief 获通知信息
 */
extern NSString *const informServlet;

/**
 *  @brief  获通知和作业新增数量
 */
extern NSString *const informAndXhwCountServlet;

/**
 *  @brief  获取学生评语信息
 */
extern NSString *const commentServlet;

/**
 *  @brief  获取考情信息
 */
extern NSString *const attendanceServlet;

/**
 *  @brief  获取资讯列表信息
 */
extern NSString *const mainNewsServlet;

/**
 *  @brief  获取资讯详情信息
 */

extern NSString *const newServlet;

/**
 *  @brief  获取圈子列表
 */
extern NSString *const circleServlet;

/**
 *  @brief  获取班圈校圈帖子列表
 */
extern NSString *const schoolAndClassServlet;

/**
 *  @brief  班圈校圈发帖
 */
extern NSString *const submitTieServlet;


/**
 *  @brief  班圈校圈发帖
 */
extern NSString *const submitTieReplyServlet;

/**
 *  @brief  获取话题帖子列表
 */
extern NSString *const boardServlet;

/**
 *  @brief  话题圈帖子详情
 */
extern NSString *const boardInfoServlet;

/**
 *  @brief  家校赞
 */
extern NSString *const submitTieZanServlet;


/**
 *  @brief  话题发帖
 */
extern NSString *const submitBoardServlet;

/**
 *  @brief  超市分组加载资源
 */
extern NSString *const findresbystage;

