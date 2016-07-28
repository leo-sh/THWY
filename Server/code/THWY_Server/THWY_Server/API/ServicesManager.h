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

#pragma mark 测试用函数
-(void)test;
@end
