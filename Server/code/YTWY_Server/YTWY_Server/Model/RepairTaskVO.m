//
//  RepairTaskVO.m
//  YTWY_Server
//
//  Created by Mr.S on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairTaskVO.h"

@implementation RepairTaskVO

-(RepairTaskVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        if (JSON[@"acl_group_id"]) {
            
            self.acl_group_id = JSON[@"acl_group_id"];
        }else
        {
            
            self.acl_group_id = JSON[@"admin_group_id"];
        }
        
        self.repair_id = JSON[@"repair_id"];
        
        if (JSON[@"acl_admin_id"]) {
            
            self.acl_admin_id = JSON[@"acl_admin_id"];
        }else
        {
            
            self.acl_admin_id = JSON[@"admin_id"];
        }
        
        self.during = JSON[@"during"];
        self.group_name = JSON[@"group_name"];
        
        if ([JSON[@"admins"] isKindOfClass:[NSArray class]]) {
            NSMutableArray* arr = [[NSMutableArray alloc]init];
            for (NSDictionary* adminDic in JSON[@"admins"]) {
                UserVO* user = [[UserVO alloc]initWithJSON:adminDic];
                [arr addObject:user];
            }
            self.admins = arr;
        }
        
    }
    
    return self;
}

@end
