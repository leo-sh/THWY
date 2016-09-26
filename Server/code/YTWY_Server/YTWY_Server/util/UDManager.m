//
//  UDManager.m
//  YTWY_Server
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

-(void)saveNotification:(NSDictionary *)userInfo
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:userInfo forKey:@"ActiveNotification"];
    [ud synchronize];
}

-(NSDictionary *)getNotification
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* userInfo = [ud objectForKey:@"ActiveNotification"];
    [self delNotification];
    return userInfo;
}

-(void)delNotification
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
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

-(void)saveEndId:(NSString *)endId andUserId:(NSString *)userId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary* dic = nil;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([ud objectForKey:@"EndId"]) {
            dic = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:@"EndId"]];
            
        }else
        {
            dic = [[NSMutableDictionary alloc]init];
        }
        dic[[NSString stringWithFormat:@"%ld",[userId integerValue]]] = [NSString stringWithFormat:@"%ld",[endId integerValue]];
        
        [ud setObject:dic forKey:@"EndId"];
        [ud synchronize];
    });
}

-(NSString *)getEndId:(NSString *)userId
{
    return @"1";
    if ([userId isKindOfClass:[NSNumber class]]) {
        userId = [NSString stringWithFormat:@"%ld",userId.integerValue];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"EndId"]) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:@"EndId"]];
        if (dic[userId]) {
            return dic[userId];
        }
    }
    return @"1";
}

-(void)removeEndId
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"EndId"];
    [ud synchronize];
}

-(void)saveShakeState:(BOOL)show
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:show] forKey:@"ShakeState"];
    [ud synchronize];
}

-(BOOL)showShakeState
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud objectForKey:@"ShakeState"]) {
        return YES;
    }else
    {
        BOOL show = [[ud objectForKey:@"ShakeState"] boolValue];
        return show;
    }
}

-(void)saveSoundState:(BOOL)show
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:show] forKey:@"SoundState"];
    [ud synchronize];
}

-(BOOL)showSoundState
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud objectForKey:@"SoundState"]) {
        return YES;
    }else
    {
        BOOL show = [[ud objectForKey:@"SoundState"] boolValue];
        return show;
    }
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
    [ud removeObjectForKey:YTWY_USER];
    [ud removeObjectForKey:@"EndId"];
    [ud synchronize];
}
@end
