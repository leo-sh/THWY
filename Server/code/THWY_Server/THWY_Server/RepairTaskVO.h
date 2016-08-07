//
//  RepairTaskVO.h
//  THWY_Server
//
//  Created by Mr.S on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"

@interface RepairTaskVO : NSObject

@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * acl_group_id;
@property (nonatomic , copy) NSString              * repair_id;
@property (nonatomic , copy) NSString              * acl_admin_id;
@property (nonatomic , copy) NSString              * during;
@property (nonatomic , copy) NSString              * group_name;
@property NSArray<UserVO *>                        * admins;

-(RepairTaskVO* )initWithJSON:(NSDictionary *)JSON;
@end
