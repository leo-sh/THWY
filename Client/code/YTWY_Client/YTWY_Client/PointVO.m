//
//  PointVO.m
//  YTWY_Client
//
//  Created by Mr.S on 16/8/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PointVO.h"

@implementation PointVO

-(PointVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.k = JSON[@"k"];
        self.s = JSON[@"s"];
        self.sub_total = JSON[@"sub_total"];
    }
    
    return self;
}

@end
