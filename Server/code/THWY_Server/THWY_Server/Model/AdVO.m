//
//  AdVO.m
//  THWY_Server
//
//  Created by Mr.S on 16/8/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AdVO.h"

@implementation AdVO

-(AdVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.title = JSON[@"title"];
        self.content = JSON[@"content"];
        self.estate_ids = JSON[@"estate_ids"];
        self.ctime = JSON[@"ctime"];
        self.admin_view = JSON[@"admin_view"];
        self.is_tuijian = [JSON[@"is_tuijian"] boolValue];
        
        self.files = [[NSMutableArray alloc]init];
        if ([JSON[@"files"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary* fileDic in JSON[@"files"]) {
                FileVO* file = [[FileVO alloc]initWithJSON:fileDic];
                [self.files addObject:file];
            }
        }
    }
    
    return self;
}

@end
