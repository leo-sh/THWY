//
//  RepairStatisticVO.m
//  THWY_Server
//
//  Created by Mr.S on 16/8/7.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatisticVO.h"

@implementation RepairStatisticVO

-(RepairStatisticVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.sum = JSON[@"sum"];
        self.status_name = JSON[@"status_name_"];
        self.estate_name = JSON[@"estate_name"];
        self.estate_id = JSON[@"estate_id"];
    }
    
    return self;
}
@end
