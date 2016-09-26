//
//  UIDevice+DeviceType.m
//  honeyshare
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "UIDevice+DeviceType.h"
#include "sys/types.h"
#include "sys/sysctl.h"

#define Iphone6Plus [[UIDevice platformString] isEqualToString:@"iPhone 6 plus"]
#define Iphone6 [[UIDevice platformString] isEqualToString:@"iPhone 6"]
#define Iphone4 [[UIDevice platformString] isEqualToString:@"iPhone 4s"]
@implementation UIDevice (DeviceType)
+(NSString *)getDeviceVersion{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
+(NSString *)platformString{
    NSString *platform = [self getDeviceVersion];
    //iPhone
    if (My_ScreenW == 320 && My_ScreenH == 480) {
        return @"iPhone 4s";
    }
    if (My_ScreenW == 320 && My_ScreenH == 568) {
        return @"iPhone 5s";
    }
    if (My_ScreenW == 375 && My_ScreenH == 667) {
        return @"iPhone 6";
    }
    if (My_ScreenW == 414 && My_ScreenH == 736) {
        return @"iPhone 6 plus";
    }
    //iPot Touch
    if ([platform isEqualToString:@"iPod1,1"])     return@"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])     return@"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])     return@"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])     return@"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])     return@"iPod Touch 5G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])     return@"iPad";
    if ([platform isEqualToString:@"iPad2,1"])     return@"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return@"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return@"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])     return@"iPad 2 New";
    if ([platform isEqualToString:@"iPad2,5"])     return@"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad3,1"])     return@"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])     return@"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])     return@"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])     return@"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"i386"] ||
        [platform isEqualToString:@"x86_64"])      return@"Simulator";
    return platform; 
}

+(UIFont *)returnDifferentDeviceFont:(NSInteger)integer{
    
    if (Iphone6Plus) {
        integer = integer+2;
    }else if (Iphone6){
        integer = integer+1;
    }else if (Iphone4){
        integer = integer;
    }
    UIFont *font = [UIFont systemFontOfSize:integer];
    
    return font;
}

@end
