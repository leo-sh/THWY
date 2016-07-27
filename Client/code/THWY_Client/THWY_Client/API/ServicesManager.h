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

/**
 *  单例
 *
 *  @return API调用实例对象
 */
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
 *  登陆API
 *
 *  @param userName   用户名
 *  @param password   密码
 *  @param onComplete 登陆完成回调block
 */
-(void)login:(NSString *)userName
    password:(NSString *)password
  onComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

/**
 *  手动获取用户信息
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getUserInfoOnComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

/**
 *  修改用户信息(非必填参数如不填，传nil即可)
 *
 *  @param phoneNum    手机号码(必填)
 *  @param carNumber   车牌号(非必填)
 *  @param newUserName 新登陆账号(非必填)
 *  @param newPassWord 新密码(非必填)
 *  @param onComplete  修改完成回调block
 */
-(void)editUserInfo:(NSString *)phoneNum
          carNumber:(NSString *)carNumber
        newUserName:(NSString *)newUserName
        newPassWord:(NSString *)newPassWord
         onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 测试用函数
-(void)test;
@end