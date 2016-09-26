//
//  RepairVO.h
//  YTWY_Server
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepairTaskVO.h"
#import "RepairStatuVO.h"
#import "RepairClassVO.h"

@interface RepairVO : NSObject

@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * from_type;
@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * block;
@property (nonatomic , copy) NSString              * unit;
@property (nonatomic , copy) NSString              * layer;
@property (nonatomic , copy) NSString              * call_name;
@property (nonatomic , copy) NSString              * call_phone;
@property (nonatomic , copy) NSString              * repair_class_ids;
@property (nonatomic , copy) NSString              * detail;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * st;
@property (nonatomic , copy) NSString              * st_0_time;
@property (nonatomic , copy) NSString              * st_1_time;
@property (nonatomic , copy) NSString              * st_2_time;
@property (nonatomic , copy) NSString              * st_2_admin_ids;
@property (nonatomic , copy) NSString              * st_3_time;
@property (nonatomic , copy) NSString              * kb;
@property (nonatomic , copy) NSString              * stop_dispatch_reason;
@property (nonatomic , copy) NSString              * jindu;
@property (nonatomic , copy) NSString              * owner_id;
@property (nonatomic , copy) NSString              * admin_id;
@property (nonatomic , copy) NSString              * estate_name;
@property (nonatomic , copy) NSString              * bg_color;
@property (nonatomic , copy) NSString              * task_time;
@property (nonatomic , copy) NSString              * cls;
@property (nonatomic , copy) NSString              * house_id;
@property (nonatomic , copy) NSString              * callback_xl;
@property (nonatomic , copy) NSString              * callback_td;
@property (nonatomic , copy) NSString              * callback_txt;
@property (nonatomic , copy) NSString              * callback_time;
@property (nonatomic , copy) NSString              * how_much_fee;
@property (nonatomic , copy) NSString              * order_ts;
@property (nonatomic , copy) NSString              * real_name;
@property (nonatomic , copy) NSString              * car_number;
@property (nonatomic , copy) NSString              * cellphone;
@property (nonatomic , copy) NSString              * mph;
@property (nonatomic , copy) NSString              * estate;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * addr;
@property (nonatomic , copy) NSString              * vdo;
@property (nonatomic , copy) NSString              * now_status;
@property RepairTaskVO                             * repair_task;
@property NSArray                                  * repair_admin_id_arr;
@property NSArray                                  * classes_ids;
@property NSArray                                  * class_names;
@property NSArray<RepairStatuVO *>                 * repair_status;
@property NSArray<RepairClassVO *>                 * classes;
@property (nonatomic , copy) NSString              * classes_str;

-(RepairVO* )initWithJSON:(NSDictionary *)JSON;
@end
