//
//  AppDelegate.m
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/22.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNavigationViewController.h"
//#import "MainVC.h"
#import "UMessage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [My_ServicesManager test];//测试API函数😁
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //此处填写各种key
        //设置 AppKey 及 LaunchOptions
        [UMessage startWithAppkey:@"57a9300ce0f55a3856000514" launchOptions:launchOptions];
        
        //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
        [UMessage registerForRemoteNotifications];
    });
    
    self.window = [[UIWindow alloc]initWithFrame:My_ScreenBounds];
    self.window.backgroundColor = My_Color(238, 238, 238);
//    self.window.rootViewController = [[MainNavigationViewController alloc]
//                                      initWithRootViewController:[[MainVC alloc]init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    [UMessage didReceiveRemoteNotification:userInfo];
}
@end
