//
//  ServicesManager.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UDManager.h"
#import "UserVO.h"
#import "IPAllowVO.h"
#import "NoticVO.h"
#import "AdVO.h"

@interface ServicesManager : NSObject

+(ServicesManager *)getAPI;

#pragma mark 环境参数判定函数
/**
 *  判断是否已登陆
 *
 *  @return 是否登陆
 */
-(BOOL)isLogin;

#pragma mark 用户相关API
/**
 *  登录API
 *
 *  @param userName   用户名
 *  @param password   密码
 *  @param onComplete 登录完成回调block
 */
-(void)login:(NSString *)userName
    password:(NSString *)password
  onComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

/**
 *  退出登录
 *
 *  @param onComplete 退出后回调block
 */
-(void)logOut:(void (^)())onComplete;

/**
 *  手动获取用户信息
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getUserInfoOnComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

/**
 *  上传用户头像
 *
 *  @param image      头像图片
 *  @param onComplete 上传完成回调block
 */
-(void)upLoadAvatar:(UIImage *)image OnComplete:(void (^)(NSString *errorMsg, NSString *avatar))onComplete;

/**
 *  修改用户信息(非必填参数如不填，传nil即可)
 *
 *  @param realName    姓名
 *  @param phoneNum    手机号
 *  @param newPassWord 新密码(非必填)
 *  @param image       图片(非必填)
 *  @param onComplete  修改完成回调block
 */
-(void)editUserInfo:(NSString *)realName
           phoneNum:(NSString *)phoneNum
        newPassWord:(NSString *)newPassWord
                pic:(UIImage *)image
         onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 白名单相关API
/**
 *  获取白名单列表
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getIpAllows:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  获取单个白名单
 *
 *  @param ipId       白名单ID
 *  @param onComplete 获取完成回调block
 */
-(void)getAIpAllow:(NSString *)ipId onComplete:(void (^)(NSString *errorMsg,IPAllowVO* list))onComplete;

/**
 *  增加一个白名单
 *
 *  @param ip         白名单实例对象
 *  @param onComplete 增加完成回调block
 */
-(void)addAIpAllow:(IPAllowVO *)ip onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  修改一个白名单
 *
 *  @param ip         白名单实例对象
 *  @param onComplete 增加完成回调block
 */
-(void)editAIpAllow:(IPAllowVO *)ip onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 好友相关API
/**
 *  获取好友列表
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getFriends:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  查找一个人(至少一个参数不为空)
 *
 *  @param phoneNum   手机号码
 *  @param name       姓名
 *  @param onComplete 查找完成回调block
 */
-(void)findFriends:(NSString* )phoneNum name:(NSString *)name onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  添加一个好友
 *
 *  @param adminId    好友adminID
 *  @param onComplete 添加完成回调block
 */
-(void)addFriend:(NSString *)adminId onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 物业公告相关API
/**
 *  获取物业公告－行政公告
 *
 *  @param page       页数
 *  @param onComplete 获取完成回调block
 */
-(void)getNotice:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  获取物业公告－行政公告内容
 *
 *  @param noticeId   公告ID
 *  @param onComplete 获取完成回调block
 */
-(void)getANotice:(NSString *)noticeId onComplete:(void (^)(NSString *errorMsg,NoticVO *notic))onComplete;

/**
 *  获取物业公告－商圈公告
 *
 *  @param page       页数
 *  @param onComplete 获取完成回调block
 */
-(void)getAds:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  获取物业公告－商圈公告内容
 *
 *  @param adId       公告ID
 *  @param onComplete 获取完成回调block
 */
-(void)getAnAd:(NSString *)adId onComplete:(void (^)(NSString *errorMsg,AdVO *notic))onComplete;

#pragma mark 个人日志相关API


#pragma mark 测试用函数
-(void)test;
@end
