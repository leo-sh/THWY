//
//  UDManager.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"

typedef enum : NSUInteger {
    Background,
    Active,
} AppStateType;

@interface UDManager : NSObject

+(UDManager *)getUD;

-(void)saveShakeState:(BOOL)show;
-(BOOL)showShakeState;

-(void)saveSoundState:(BOOL)show;
-(BOOL)showSoundState;

-(void)saveShowState:(BOOL)show;
-(BOOL)showPassWord;

-(void)saveNotification:(NSDictionary *)userInfo;
-(NSDictionary *)getNotification;
-(void)delNotification;

/**
 *  获取已登录用户
 *
 *  @return 用户
 */
-(UserVO *)getUser;

/**
 *  存储用户至UD
 *
 *  @param newUser 待存储用户
 */
-(void)saveUser:(UserVO *)newUser;

/**
 *  存储登陆所用用户名
 *
 *  @param name 用户名
 */
-(void)saveUserName:(NSString *)name;

/**
 *  获取登陆所用用户名
 *
 *  @return 用户名
 */
-(NSString *)getUserName;

/**
 *  存储登陆所用密码
 *
 *  @param passWord 密码
 */
-(void)saveUserPassWord:(NSString *)passWord;

/**
 *  获取登陆所用密码
 *
 *  @return 密码
 */
-(NSString *)getPassWord;

/**
 *  移除当前用户
 */
-(void)removeUDUser;
@end
