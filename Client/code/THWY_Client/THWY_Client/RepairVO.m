//
//  RepairVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairVO.h"

@implementation RepairVO

-(RepairVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.owner_id = JSON[@"owner_id"];
        self.estate_id = JSON[@"estate_id"];
        self.house_id = JSON[@"house_id"];
        if ([JSON[@"pic"] rangeOfString:@"http"].location != NSNotFound || [JSON[@"pic"] length] == 0) {
            self.pic = JSON[@"pic"];
        }else
        {
            self.pic = [NSString stringWithFormat:@"%@%@",API_Prefix,JSON[@"pic"]];
        }
        
        if ([JSON[@"vdo"] rangeOfString:@"http"].location != NSNotFound || [JSON[@"vdo"] length] == 0) {
            self.vdo = JSON[@"vdo"];
        }else
        {
            self.vdo = [NSString stringWithFormat:@"%@%@",API_Prefix,JSON[@"vdo"]];
        }
        if (JSON[@"repair_detail"]) {
            self.detail = JSON[@"repair_detail"];
        }else
        {
            self.detail = JSON[@"detail"];
        }
        self.from_type = JSON[@"from_type"];
        
        self.repair_status = [[NSMutableArray alloc]init];
        for (NSDictionary* statuDic in JSON[@"repair_status"]) {
            RepairStatuVO* statu = [[RepairStatuVO alloc]initWithJSON:statuDic];
            [self.repair_status addObject:statu];
        }
        
        self.admin_id = JSON[@"admin_id"];
        self.callback_xl = JSON[@"callback_xl"];
        self.callback_td = JSON[@"callback_td"];
        self.callback_txt = JSON[@"callback_txt"];
        self.callback_time = JSON[@"callback_time"];
        self.call_person = JSON[@"call_person"];
        self.call_phone = JSON[@"call_phone"];
        self.how_much_fee = JSON[@"how_much_fee"];
        self.kb = JSON[@"kb"];
        self.stop_dispatch_reason = JSON[@"stop_dispatch_reason"];
        self.jindu = JSON[@"jindu"];
        self.st_0_time = JSON[@"st_0_time"];
        self.st_1_time = JSON[@"st_1_time"];
        self.st_2_time = JSON[@"st_2_time"];
        self.st_2_admin_ids = JSON[@"st_2_admin_ids"];
        self.st_3_time = JSON[@"st_3_time"];
        self.order_ts = JSON[@"order_ts"];
        if (JSON[@"real_name"]) {
            self.real_name = JSON[@"real_name"];
        }else
        {
            self.real_name = JSON[@"call_name"];
        }
        self.car_number = JSON[@"car_number"];
        self.cellphone = JSON[@"cellphone"];
        self.block = JSON[@"block"];
        self.unit = JSON[@"unit"];
        self.layer = JSON[@"layer"];
        self.mph = JSON[@"mph"];
        self.estate = JSON[@"estate"];
        self.phone = JSON[@"phone"];
        self.addr = JSON[@"addr"];
        
        if (JSON[@"_st"]) {
            
            self._st = JSON[@"_st"];
        }else
        {
            
            self._st = JSON[@"st"];
        }
        
        if ([JSON[@"repair_task"] isKindOfClass:[NSDictionary class]] && JSON[@"repair_task"][@"admins"] && [JSON[@"repair_task"][@"admins"] isKindOfClass:[NSArray class]]) {
            self.repair_task = [[NSMutableArray alloc]init];
            for (NSDictionary* adminDic in JSON[@"repair_task"][@"admins"]) {
                UserVO* user = [[UserVO alloc]init];
                user.real_name = adminDic[@"real_name"];
                user.cellphone = adminDic[@"cellphone"];
                [self.repair_task addObject:user];
            }
        }else if ([JSON[@"admins"] isKindOfClass:[NSArray class]])
        {
            self.repair_task = [[NSMutableArray alloc]init];
            for (NSDictionary* adminDic in JSON[@"admins"]) {
                UserVO* user = [[UserVO alloc]init];
                user.Id = adminDic[@"admin_id"];
                user.real_name = adminDic[@"real_name"];
                user.cellphone = adminDic[@"cellphone"];
                [self.repair_task addObject:user];
            }
        }
        
        self.repair_admin_id_arr = JSON[@"repair_admin_id_arr"];
        self.classes_ids = JSON[@"classes_ids"];
        self.class_names = JSON[@"class_names"];

        self.classes = [[NSMutableArray alloc]init];
        for (NSDictionary* statuDic in JSON[@"classes"]) {
            RepairClassVO* statu = [[RepairClassVO alloc]initWithJSON:statuDic];
            [self.classes addObject:statu];
        }
        if (JSON[@"classes_str"]) {
            self.classes_str = JSON[@"classes_str"];
        }else
        {
            self.classes_str = JSON[@"cls"];
        }
        self.estate_name = JSON[@"estate_name"];
        self.bg_color = JSON[@"bg_color"];
        self.task_time = JSON[@"task_time"];
    }
    
    return self;
}

@end
