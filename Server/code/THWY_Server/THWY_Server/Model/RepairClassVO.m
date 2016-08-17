//
//  RepairClassVO.m
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairClassVO.h"

@implementation RepairClassVO

-(RepairClassVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.pid = JSON[@"pid"];
        self.class_path = JSON[@"class_path"];
        self.class_name = JSON[@"class_name"];
        self.class_price = JSON[@"class_price"];
        self.st = JSON[@"st"];
        self.estate_id = JSON[@"estate_id"];
        self.task_time = JSON[@"task_time"];
        self.px = JSON[@"px"];
        
        self.child = [[NSMutableArray alloc]init];
        for (NSDictionary* classDic in JSON[@"_child"]) {
            RepairClassVO* childClass = [[RepairClassVO alloc]initWithJSON:classDic];
            [self.child addObject:childClass];
        }
    }
    
    return self;
}

@end
