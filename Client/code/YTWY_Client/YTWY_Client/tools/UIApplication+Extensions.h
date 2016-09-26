//
//  UIApplication+Extensions.h
//  Weibo11
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UIApplication (Extensions)

/**
* 返回应用程序代理
*/
+ (AppDelegate *)appDelegate;


/**
 *  根视图控制器
 */
+ (UIViewController *)rootViewController;

/**
 *  返回当前设备对应的启动图片
 */
+ (UIImage *)launchImage;

@end
