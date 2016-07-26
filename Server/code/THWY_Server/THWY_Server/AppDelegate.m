//
//  AppDelegate.m
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/22.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNavigationViewController.h"
#import "MainVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //此处填写各种key
    });
    
    self.window = [[UIWindow alloc]initWithFrame:My_ScreenBounds];
    self.window.backgroundColor = My_Color(238, 238, 238);
    MainVC* mainVC = [[MainVC alloc]init];
    MainNavigationViewController* mainNav = [[MainNavigationViewController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
