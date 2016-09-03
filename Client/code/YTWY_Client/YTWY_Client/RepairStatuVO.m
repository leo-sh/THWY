//
//  RepairStatuVO.m
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatuVO.h"

@implementation RepairStatuVO

-(RepairStatuVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        if (JSON[@"st_id"]) {
            self.st_id = JSON[@"st_id"];
        }else if(JSON[@"st"]){
            self.st_id = JSON[@"st"];
        }else if(JSON[@"id"]){
            self.st_id = JSON[@"id"];
        }
        
        if (JSON[@"st_name"]) {
            self.st_name = JSON[@"st_name"];
        }else if(JSON[@"repair_status_name"]){
            self.st_name = JSON[@"repair_status_name"];
        }
        self.ctime = JSON[@"ctime"];
    }
    
    return self;
}

@end
