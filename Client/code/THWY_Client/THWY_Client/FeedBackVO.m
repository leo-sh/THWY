//
//  FeedBackVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "FeedBackVO.h"

@implementation FeedBackVO

-(FeedBackVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.category = JSON[@"category"];
        self.oid = JSON[@"oid"];
        self.content = JSON[@"content"];
        
        self.is_read = [JSON[@"is_read"] boolValue];
        self.answer = JSON[@"answer"];
        self.ctime = JSON[@"ctime"];
    }
    
    return self;
}

@end
