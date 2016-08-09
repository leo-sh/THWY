//
//  MsgVO.m
//  THWY_Server
//
//  Created by Mr.S on 16/8/8.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MsgVO.h"

@implementation MsgVO

-(MsgVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.reciver_admin_id = JSON[@"reciver_admin_id"];
        self.sender_admin_id = JSON[@"sender_admin_id"];
        if ([self.sender_admin_id isEqualToString:[[UDManager getUD] getUser].admin_id]) {
            self.fromMe = YES;
        }else
        {
            self.fromMe = NO;
        }
        
        self.msg = JSON[@"msg"];
        self.ctime = JSON[@"ctime"];
        self.reciver = [[UserVO alloc]initWithJSON:JSON[@"reciver"]];
        self.sender = [[UserVO alloc]initWithJSON:JSON[@"sender"]];
    }
    
    return self;
}

@end
