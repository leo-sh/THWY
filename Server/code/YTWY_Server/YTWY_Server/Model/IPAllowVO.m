//
//  IPAllowVO.m
//  YTWY_Server
//
//  Created by 史秀泽 on 2016/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "IPAllowVO.h"

@implementation IPAllowVO

-(IPAllowVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.ip = JSON[@"ip"];
        self.the_user = JSON[@"the_user"];
    }
    
    return self;
}

@end
