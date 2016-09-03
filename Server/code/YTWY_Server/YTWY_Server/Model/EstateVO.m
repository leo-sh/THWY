//
//  EstateVO.m
//  YTWY_Server
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "EstateVO.h"

@implementation EstateVO

-(EstateVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.estate_id = JSON[@"estate_id"];
        self.estate_name = JSON[@"estate_name"];
        self.pic = JSON[@"pic"];
        self.wyf_date = JSON[@"wyf_date"];
    }
    
    return self;
}

@end
