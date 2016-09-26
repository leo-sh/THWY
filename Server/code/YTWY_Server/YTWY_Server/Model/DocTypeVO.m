//
//  DocTypeVO.m
//  YTWY_Server
//
//  Created by Mr.S on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "DocTypeVO.h"

@implementation DocTypeVO

-(DocTypeVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.name = JSON[@"name"];
    }
    
    return self;
}

@end
