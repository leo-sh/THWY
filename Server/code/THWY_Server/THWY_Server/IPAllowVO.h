//
//  IPAllowVO.h
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAllowVO : NSObject

@property NSString              * Id;
@property NSString              * ip;
@property NSString              * the_user;

-(IPAllowVO* )initWithJSON:(NSDictionary *)JSON;

@end
