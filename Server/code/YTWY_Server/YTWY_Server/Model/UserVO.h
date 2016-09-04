//
//  UserVO.h
//  YTWY_Server
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupVO.h"

#define YTWY_USER @"ytwy_user"
#define USER_NAME @"user_name"
#define USER_PASSWORD @"user_password"
#define SHOW_STATE @"show_state"

@interface UserVO : NSObject <NSCoding>

@property NSString              * admin_id;
@property NSString              * admin_group_id;
@property NSString              * admin_name;
@property NSString              * admin_acl;
@property NSString              * admin_password;
@property NSString              * login_count;
@property NSString              * ctime;
@property NSString              * status;
@property NSString              * work_st;
@property NSString              * estate_id;
@property NSString              * estate_ids;
@property NSString              * is_serviceman;
@property NSString              * is_cashier;
@property NSString              * real_name;
@property NSString              * cellphone;
@property NSString              * photo;
@property GroupVO               * up_group;

-(UserVO* )initWithJSON:(NSDictionary *)JSON;
+(UserVO *)fromCodingObject;
-(void)saveToUD;

@end
