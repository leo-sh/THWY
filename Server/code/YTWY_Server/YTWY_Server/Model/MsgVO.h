//
//  MsgVO.h
//  YTWY_Server
//
//  Created by Mr.S on 16/8/8.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"

@interface MsgVO : NSObject

@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * reciver_admin_id;
@property (nonatomic , copy) NSString              * sender_admin_id;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , strong) UserVO              * reciver;
@property (nonatomic , strong) UserVO              * sender;
@property BOOL fromMe;

-(MsgVO* )initWithJSON:(NSDictionary *)JSON;

@end
