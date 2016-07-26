//
//  UDManager.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"

@interface UDManager : NSObject

+(UDManager *)getUD;
-(UserVO *)getUser;
-(void)saveUser:(UserVO *)newUser;
-(void)removeUDUser;
@end
