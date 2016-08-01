//
//  NoticVO.m
//  THWY_Server
//
//  Created by Mr.S on 16/8/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "NoticVO.h"

@implementation NoticVO

-(NoticVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.note_txt_type_id = JSON[@"note_txt_type_id"];
        self.title = JSON[@"title"];
        self.content = JSON[@"content"];
        self.ctime = JSON[@"ctime"];
        self.note_type = JSON[@"note_type"];
    }
    
    return self;
}

@end
