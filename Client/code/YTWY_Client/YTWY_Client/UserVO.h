//
//  UserVO.h
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseVO.h"
#define YTWY_USER @"txwy_user"
#define USER_NAME @"user_name"
#define USER_PASSWORD @"user_password"
#define SHOW_STATE @"show_state"

@interface UserVO : NSObject <NSCoding>

@property NSString              * gender;
@property NSString              * id_card;
@property NSString              * cellphone;
@property NSString              * Id;
@property NSString              * car_number;
@property NSString              * avatar;
@property NSString              * real_name;
@property NSString              * points;
@property NSString              * estate;
@property NSArray<HouseVO *>    * houses;
@property NSString              * oname;

-(UserVO* )initWithJSON:(NSDictionary *)JSON;
+(UserVO *)fromCodingObject;
-(void)saveToUD;

@end
