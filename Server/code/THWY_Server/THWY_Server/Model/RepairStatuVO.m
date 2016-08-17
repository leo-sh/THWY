//
//  RepairStatuVO.m
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatuVO.h"

@implementation RepairStatuVO

-(RepairStatuVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        if (JSON[@"id"]) {
            self.Id = JSON[@"id"];
        }else if (JSON[@"st_id"]){
            self.Id = JSON[@"st_id"];
        }else if (JSON[@"st"]){
            self.Id = JSON[@"st"];
        }
        
        if (JSON[@"repair_status_name"]) {
            self.repair_status_name = JSON[@"repair_status_name"];
        }else if (JSON[@"st_name"]){
            self.repair_status_name = JSON[@"st_name"];
        }
        
        self.ctime = JSON[@"ctime"];
    }
    
    return self;
}

@end
