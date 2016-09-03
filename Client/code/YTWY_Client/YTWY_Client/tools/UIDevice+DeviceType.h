//
//  UIDevice+DeviceType.h
//  honeyshare
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIDevice (DeviceType)
/**
 *  返回设备型号
 */
+ (NSString *)platformString;

/**
 *  根据不同的设置返回不同的字体
 */
+(UIFont*)returnDifferentDeviceFont:(NSInteger)integer;

@end
