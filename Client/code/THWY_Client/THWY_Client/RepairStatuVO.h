//
//  RepairStatuVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairStatuVO : NSObject

@property (nonatomic , copy) NSString              * st_id;
@property (nonatomic , copy) NSString              * st_name;

-(RepairStatuVO* )initWithJSON:(NSDictionary *)JSON;
@end
