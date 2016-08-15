//
//  NoteVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "NoteVO.h"

@implementation NoteVO

-(NoteVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.content = JSON[@"content"];
        self.content_app = JSON[@"content_app"];
        self.ctime = JSON[@"ctime"];
        
        self.is_index = [JSON[@"is_index"] boolValue];
        self.estate_id = JSON[@"estate_id"];
        self.ctime = JSON[@"ctime"];
        self.title = JSON[@"title"];
        self.note_txt_type_id = JSON[@"note_txt_type_id"];
    }
    
    return self;
}

@end
