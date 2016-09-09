//
//  StaffRepairStatisticVO.m
//  THWY_Server
//
//  Created by Mr.S on 16/9/9.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "StaffRepairStatisticVO.h"

@implementation StaffRepairStatisticVO

-(StaffRepairStatisticVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.admin_id = JSON[@"admin_id"];
        self.admin_name = JSON[@"admin_name"];
        self.real_name = JSON[@"real_name"];
        self.task_tot = JSON[@"task_tot"];
        self.task_done = JSON[@"task_done"];
        self.task_tot_time = JSON[@"task_tot_time"];
        self.task_avg = JSON[@"task_avg"];
    }
    
    return self;
}

@end
