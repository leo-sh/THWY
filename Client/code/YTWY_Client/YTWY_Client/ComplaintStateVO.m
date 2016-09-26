//
//  ComplaintStateVO.m
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ComplaintStateVO.h"

@implementation ComplaintStateVO

-(ComplaintStateVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.st = JSON[@"st"];
        self.name = JSON[@"name"];
    }
    
    return self;
}

@end
