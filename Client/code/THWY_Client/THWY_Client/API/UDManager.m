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

-(void)saveNotification:(AppStateType)type userInfo:(NSDictionary *)userInfo
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    switch (type) {
        case Background:
            [ud setObject:userInfo forKey:@"BackgroundNotification"];
            break;
        case Close:
            [ud setObject:userInfo forKey:@"InactiveNotification"];
            break;
        case Active:
            [ud setObject:userInfo forKey:@"ActiveNotification"];
            break;
        default:
            break;
    }
    
    [ud synchronize];
}

-(NSDictionary *)getNotification:(AppStateType)type
{
    NSDictionary* userInfo = nil;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    switch (type) {
        case Background:
            userInfo = [ud objectForKey:@"BackgroundNotification"];
            break;
        case Close:
            userInfo = [ud objectForKey:@"InactiveNotification"];
            break;
        case Active:
            userInfo = [ud objectForKey:@"ActiveNotification"];
            break;
        default:
            break;
    }
    
    [self delNotification:type];
    return userInfo;
}

-(void)delNotification:(AppStateType)type
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    switch (type) {
        case Background:
            [ud removeObjectForKey:@"BackgroundNotification"];
            break;
        case Close:
            [ud removeObjectForKey:@"InactiveNotification"];
            break;
        case Active:
            [ud removeObjectForKey:@"ActiveNotification"];
            break;
        default:
            break;
    }
    
    [ud synchronize];
}

-(void)delAllNotification
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"BackgroundNotification"];
    [ud removeObjectForKey:@"InactiveNotification"];
    [ud removeObjectForKey:@"ActiveNotification"];
    [ud synchronize];
}

-(void)saveShowState:(BOOL)show
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:show] forKey:SHOW_STATE];
    [ud synchronize];
}

-(BOOL)showPassWord
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [[ud objectForKey:SHOW_STATE] boolValue];
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
