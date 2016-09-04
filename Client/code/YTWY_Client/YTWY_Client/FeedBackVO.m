//
//  FeedBackVO.m
//  YTWY_Client
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
        if ([JSON[@"answer"] isKindOfClass:[NSString class]] && [JSON[@"answer"] length] > 0) {
            
            self.answer = JSON[@"answer"];
            if (JSON[@"answer_time"]) {
                self.answer_time = JSON[@"answer_time"];
                self.content = [NSString stringWithFormat:@"%@\n回复：%@\n%@",JSON[@"content"],JSON[@"answer"],[NSString stringDateFromTimeInterval:[self.answer_time integerValue] withFormat:@"YYYY-MM-dd HH:mm"]];
            }else
            {
                self.content = [NSString stringWithFormat:@"%@\n回复：%@",JSON[@"content"],JSON[@"answer"]];
            }
            
        }else
        {
            self.content = JSON[@"content"];
        }
        
        self.is_read = [JSON[@"is_read"] boolValue];
        self.ctime = JSON[@"ctime"];
    }
    
    return self;
}

@end
