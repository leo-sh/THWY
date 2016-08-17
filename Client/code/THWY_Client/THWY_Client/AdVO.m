//
//  adVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AdVO.h"

@implementation AdVO

-(AdVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.title = JSON[@"title"];
        self.ctime = JSON[@"ctime"];
        self.content = JSON[@"content"];
        self.is_tuijian = [JSON[@"is_tuijian"] boolValue];
        
    }
    
    return self;
}

@end
