//
//  AppDelegate.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/22.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNavigationViewController.h"
#import "MainVC.h"
#import "UMessage_Sdk_1.3.0/UMessage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [My_ServicesManager test];//测试API函数😁
        
        //设置svp默认样式
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        //此处填写各种key
        //设置 AppKey 及 LaunchOptions
        [UMessage startWithAppkey:@"57981a41e0f55a301c0029b6" launchOptions:launchOptions];
        
        //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
        [UMessage registerForRemoteNotifications];
        //for log
        [UMessage setLogEnabled:YES];
        [UMessage setAutoAlert:NO];
        
        if ([[UDManager getUD] getUser]) {
            UserVO* user = [[UDManager getUD] getUser];
            
            NSMutableArray* tagArr = [[NSMutableArray alloc]initWithObjects:@"owner",[NSString stringWithFormat:@"owner_id_%@",user.Id], nil];
            
            for (HouseVO* house in user.houses) {
                [tagArr addObject:[NSString stringWithFormat:@"estate_id_%@",house.estate_id]];
            }
            
            [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                [UMessage addTag:tagArr response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                    [UMessage getTags:^(NSSet * _Nonnull responseTags, NSInteger remain, NSError * _Nonnull error) {
                        
                    }];
                }];
            }];
        }
    });
    
    BOOL isFromNotification = NO;
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSLog(@"推送消息==== %@",remoteNotification);
            isFromNotification = YES;
        }
        
    }
    
    self.window = [[UIWindow alloc]initWithFrame:My_ScreenBounds];
    self.window.backgroundColor = My_Color(238, 238, 238);
    MainVC* mainVC = [[MainVC alloc]init];
    MainNavigationViewController* mainNav = [[MainNavigationViewController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    MainNavigationViewController* mainNav = (MainNavigationViewController *)self.window.rootViewController;
    NSLog(@"%@",userInfo);
    
    if (application.applicationState == UIApplicationStateActive) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:userInfo forKey:@"ActiveNotification"];
        [ud synchronize];
        
    }else if(application.applicationState == UIApplicationStateInactive) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:userInfo forKey:@"InactiveNotification"];
        [ud synchronize];
    }
    else{
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:userInfo forKey:@"BackgroundNotification"];
        [ud synchronize];
    }
    
    [UMessage didReceiveRemoteNotification:userInfo];
}

@end
