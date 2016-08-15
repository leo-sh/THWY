//
//  RepairStatisticVO.h
//  THWY_Server
//
//  Created by Mr.S on 16/8/7.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairStatisticVO : NSObject

@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * estate_name;
@property (nonatomic , copy) NSString              * status_name;
@property (nonatomic , copy) NSString              * sum;

-(RepairStatisticVO* )initWithJSON:(NSDictionary *)JSON;
@end
