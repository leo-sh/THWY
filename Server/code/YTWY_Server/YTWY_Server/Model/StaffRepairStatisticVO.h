//
//  StaffRepairStatisticVO.h
//  YTWY_Server
//
//  Created by Mr.S on 16/9/9.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffRepairStatisticVO : NSObject

@property (nonatomic , copy) NSString              * admin_id;
@property (nonatomic , copy) NSString              * admin_name;
@property (nonatomic , copy) NSString              * real_name;
@property (nonatomic , copy) NSNumber              * task_tot;
@property (nonatomic , copy) NSNumber              * task_done;
@property (nonatomic , copy) NSNumber              * task_tot_time;
@property (nonatomic , copy) NSNumber              * task_avg;

-(StaffRepairStatisticVO* )initWithJSON:(NSDictionary *)JSON;

@end
