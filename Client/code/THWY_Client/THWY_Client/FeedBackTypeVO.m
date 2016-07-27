//
//  FeedBackTypeVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "FeedBackTypeVO.h"

@implementation FeedBackTypeVO

-(FeedBackTypeVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.guest_book_type = JSON[@"guest_book_type"];
    }
    
    return self;
}

@end
