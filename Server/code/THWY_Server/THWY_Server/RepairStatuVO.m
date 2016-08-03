//
//  RepairStatuVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatuVO.h"

@implementation RepairStatuVO

-(RepairStatuVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.repair_status_name = JSON[@"repair_status_name"];
    }
    
    return self;
}

@end
