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
        
        [[UDManager getUD] delNotification];
        //此处填写各种key
        //设置 AppKey 及 LaunchOptions
        [UMessage startWithAppkey:@"57981a41e0f55a301c0029b6" launchOptions:launchOptions];
        
        //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
        [UMessage registerForRemoteNotifications];
        //for log
        [UMessage setLogEnabled:YES];
        [UMessage setAutoAlert:NO];
        
        if (My_ServicesManager.isLogin) {
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
        }else
        {
            [UMessage addTag:@"owner" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                [UMessage getTags:^(NSSet * _Nonnull responseTags, NSInteger remain, NSError * _Nonnull error) {
                    
                }];
            }];
        }
        
    });
    
    self.window = [[UIWindow alloc]initWithFrame:My_ScreenBounds];
    self.window.backgroundColor = My_Color(238, 238, 238);
    MainVC* mainVC = [[MainVC alloc]init];
    MainNavigationViewController* mainNav = [[MainNavigationViewController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSLog(@"推送消息==== %@",remoteNotification);
            [mainNav popWithUserInfo:remoteNotification];
        }
        
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
//    推送内容示例
//    {
//        aps =     {
//            alert = "\U5929\U9a84\U82b1\U56edIOS\U63a8\U9001";
//            badge = 0;
//            sound = chime;
//        };
//        d = us21240147114678523001;
//        "notice_type" = yz;
//        p = 0;
//        pk = 33;
//        "push_type" = 5;
//    }
    
    if (application.applicationState == UIApplicationStateActive) {
        [[UDManager getUD] saveNotification:userInfo];
        
        MainNavigationViewController* mainNav = (MainNavigationViewController *)self.window.rootViewController;
        [mainNav showAlertWithUserInfo:userInfo];
        
    }else if(application.applicationState == UIApplicationStateInactive) {
        MainNavigationViewController* mainNav = (MainNavigationViewController *)self.window.rootViewController;
        [mainNav popWithUserInfo:userInfo];
    }
    
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
@end
