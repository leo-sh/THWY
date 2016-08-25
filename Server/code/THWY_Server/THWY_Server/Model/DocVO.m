//
//  DocVO.m
//  THWY_Server
//
//  Created by Mr.S on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "DocVO.h"

@implementation DocVO

-(DocVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.doc_type_id = JSON[@"doc_type_id"];
        self.admin_id = JSON[@"admin_id"];
        self.is_public = [JSON[@"is_public"] boolValue];
        self.title = JSON[@"title"];
        self.content = JSON[@"content"];
        self.ctime = JSON[@"ctime"];
        self.open_to = JSON[@"open_to"];
        self.do_copy = JSON[@"do_copy"];
        if ([JSON[@"real_name"] isKindOfClass:[NSString class]] && [JSON[@"real_name"] length]>0) {
            self.real_name = JSON[@"real_name"];
        }else
        {
            self.real_name = JSON[@"false"];
        }
        self.belong = [JSON[@"belong"] boolValue];
    }
    
    return self;
}

@end
