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
        if(JSON[@"id"]){
            self.st_id = JSON[@"id"];
        }else if (JSON[@"estate_id"]){
            self.st_id = JSON[@"estate_id"];
        }
        
        if (JSON[@"estate_name"]) {
            self.st_name = JSON[@"estate_name"];
        }else if(JSON[@"repair_status_name"]){
            self.st_name = JSON[@"repair_status_name"];
        }
        
        if (JSON[@"wyf_date"]) {
            self.ctime = JSON[@"wyf_date"];
        }else if(JSON[@"ctime"]){
            self.ctime = JSON[@"ctime"];
        }
        
        if (JSON[@"pic"]) {
            self.pic = [NSString stringWithFormat:@"%@%@",API_Prefix,JSON[@"pic"]];
        }
    }
    
    return self;
}

@end
