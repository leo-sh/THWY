//
//  UDManager.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "UDManager.h"

@interface UDManager ()

{
    UserVO *user;
}

@end

@implementation UDManager

+(UDManager *)getUD
{
    static UDManager *ud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ud = [[self alloc] init];
    });
    return ud;
}

-(UserVO *)getUser{
    if (user == nil) {
        user = [UserVO fromCodingObject];
    }
    return user;
}

-(void)saveUser:(UserVO *)newUser
{
    user = newUser;
    [user saveToUD];
}

-(void)saveUserName:(NSString *)name
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:name forKey:USER_NAME];
    [ud synchronize];
}

-(void)saveUserPassWord:(NSString *)passWord
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:passWord forKey:USER_PASSWORD];
    [ud synchronize];
}

-(NSString *)getPassWord
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:USER_PASSWORD];
}

-(NSString *)getUserName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:USER_NAME];
}

-(void)removeUDUser
{
    user = nil;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:THWY_USER];
    [ud synchronize];
}
@end
