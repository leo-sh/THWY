//
//  ComplaintVO.m
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ComplaintVO.h"

@implementation ComplaintVO

-(ComplaintVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.estate_id = JSON[@"estate_id"];
        self.house_id = JSON[@"house_id"];
        self.owner_id = JSON[@"owner_id"];
        self.complaint_person = JSON[@"complaint_person"];
        self.complaint_phone = JSON[@"complaint_phone"];
        self.complaint_type = JSON[@"complaint_type"];
        self.complaint_content = JSON[@"complaint_content"];
        self.admin_id = JSON[@"admin_id"];
        self.ctime = JSON[@"ctime"];
        self.st = JSON[@"st"];
        self.deal_dispatch_admin_id = JSON[@"deal_dispatch_admin_id"];
        self.deal_dispatch_time = JSON[@"deal_dispatch_time"];
        self.deal_admin_id = JSON[@"deal_admin_id"];
        self.deal_remark = JSON[@"deal_remark"];
        self.callback_admin_id = JSON[@"callback_admin_id"];
        self.callback_xl = JSON[@"callback_xl"];
        self.callback_td = JSON[@"callback_td"];
        self.callback_txt = JSON[@"callback_txt"];
        self.callback_time = JSON[@"callback_time"];
        self.remarks = JSON[@"remarks"];
        self.complaint_type_name = JSON[@"complaint_type_name"];
        self.block = JSON[@"block"];
        self.unit = JSON[@"unit"];
        self.layer = JSON[@"layer"];
        self.mph = JSON[@"mph"];
        self.estate = JSON[@"estate"];
    }
    
    return self;
}

-(NSMutableDictionary* )toDic
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    dic[@"estate_id"] = self.estate_id;
    dic[@"house_id"] = self.house_id;
    dic[@"complaint_person"] = self.complaint_person;
    dic[@"complaint_phone"] = self.complaint_phone;
    dic[@"complaint_type"] = self.complaint_type;
    dic[@"complaint_content"] = self.complaint_content;
    
    return dic;
}

@end
