//
//  RepairStatuVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Owner = 1,
    Public,
} RepairType;

@interface RepairStatuVO : NSObject

@property (nonatomic , copy) NSString              * st_id;
@property (nonatomic , copy) NSString              * st_name;
@property (nonatomic , copy) NSString              * ctime;

-(RepairStatuVO* )initWithJSON:(NSDictionary *)JSON;
@end
