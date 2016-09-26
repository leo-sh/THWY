//
//  GroupVO.h
//  YTWY_Server
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupVO : NSObject <NSCoding>

@property NSString              * sector;
@property NSString              * project;
@property NSString              * group;

-(GroupVO* )initWithJSON:(NSDictionary *)JSON;

@end
