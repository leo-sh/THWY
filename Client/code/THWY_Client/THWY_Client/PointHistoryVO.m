//
//  PointHistoryVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PointHistoryVO.h"

@implementation PointHistoryVO

-(PointHistoryVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.owner_id = JSON[@"owner_id"];
        self.points = JSON[@"points"];
        self.remark = JSON[@"remark"];
        self.the_type = JSON[@"the_type"];
        self.pk = JSON[@"pk"];
        self.ts = JSON[@"ts"];
        self.the_type_name = JSON[@"the_type_name"];
    }
    
    return self;
}

@end
