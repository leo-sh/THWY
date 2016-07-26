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
-(BOOL)isLogin;

#pragma mark 用户相关API
/**
 *  登陆API
 *
 *  @param userName   用户名
 *  @param password   密码
 *  @param onComplete 登陆结果回调block
 */
-(void)login:(NSString *)userName
    password:(NSString *)password
  onComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

#pragma mark 测试用函数
-(void)test;
@end
