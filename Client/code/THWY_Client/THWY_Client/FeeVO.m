//
//  FeeVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "FeeVO.h"

@implementation FeeVO

-(FeeVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.owner_id = JSON[@"owner_id"];
        self.estate_id = JSON[@"estate_id"];
        self.house_id = JSON[@"house_id"];
        self.fee_cls = JSON[@"fee_cls"];
        self.fee_year = JSON[@"fee_year"];
        self.how_much = JSON[@"how_much"];
        self.actual = JSON[@"actual"];
        self.st = [JSON[@"st"] intValue];
        self.ctime = JSON[@"ctime"];
        self.remark = JSON[@"remark"];
        self.zc_type = JSON[@"zc_type"];
        self.zc = JSON[@"zc"];
        self.s_time = JSON[@"s_time"];
        self.e_time = JSON[@"e_time"];
        self.fee_type = JSON[@"fee_type"];
        self.real_name = JSON[@"real_name"];
        self.cellphone = JSON[@"cellphone"];
        self.cls_name = JSON[@"cls_name"];
        self.cls_fee = JSON[@"cls_fee"];
        self.cls_unit = JSON[@"cls_unit"];
        self.refund = JSON[@"refund"];
        self.is_wyf = JSON[@"is_wyf"];
        self.wyf_n = JSON[@"wyf_n"];
        self.is_pm = JSON[@"is_pm"];
        self.is_year_charge = JSON[@"is_year_charge"];
        self.is_month_charge = JSON[@"is_month_charge"];
        self.block = JSON[@"block"];
        self.unit = JSON[@"unit"];
        self.layer = JSON[@"layer"];
        self.mph = JSON[@"mph"];
        self.house_size = JSON[@"house_size"];
        self.house_type = JSON[@"house_type"];
        self.structure = JSON[@"structure"];
        self.decorate_st = JSON[@"decorate_st"];
        self.estate_name = JSON[@"estate_name"];
        self.estate_pic = JSON[@"estate_pic"];
        self.begin_time = JSON[@"fee_period"][@"begin_time"];
        self.end_time = JSON[@"fee_period"][@"end_time"];
        self.qian_fei = JSON[@"qian_fei"];
        
        self.fee_history = [[NSMutableArray alloc]init];
        for (NSDictionary* historyDic in JSON[@"fee_history"]) {
            FeeHistoryVO* history = [[FeeHistoryVO alloc]initWithJSON:historyDic];
            [self.fee_history addObject:history];
        }

    }
    
    return self;
}

@end
