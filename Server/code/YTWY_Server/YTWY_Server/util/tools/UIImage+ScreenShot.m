//
//  UIImage+ScreenShot.m
//  Weibo11
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "UIImage+ScreenShot.h"

@implementation UIImage (ScreenShot)

/**
 *  获取屏幕截图
 *
 *  @return 屏幕截图图像
 */
+ (UIImage *)screenShot {
    // 1. 获取到窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 2. 开始上下文
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0);
    
    // 3. 将 window 中的内容绘制输出到当前上下文
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
    
    // 4. 获取图片
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    
    return screenShot;
}

@end
