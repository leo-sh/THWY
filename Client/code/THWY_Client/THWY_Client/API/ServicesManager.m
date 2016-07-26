//
//  ServicesManager.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ServicesManager.h"

@implementation ServicesManager

+(ServicesManager *)getAPI
{
    static ServicesManager *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

#pragma mark 测试用函数
-(void)test
{
    
}
@end
