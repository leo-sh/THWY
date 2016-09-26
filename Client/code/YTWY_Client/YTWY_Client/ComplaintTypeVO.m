//
//  ComplaintTypeVO.m
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ComplaintTypeVO.h"

@implementation ComplaintTypeVO

-(ComplaintTypeVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.complaint_type = JSON[@"complaint_type"];
    }
    
    return self;
}

@end
