//
//  FeeHistoryVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "FeeHistoryVO.h"

@implementation FeeHistoryVO

-(FeeHistoryVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.fee_owner_id = JSON[@"fee_owner_id"];
        self.fee = JSON[@"fee"];
        self.admin_id = JSON[@"admin_id"];
        self.remark = JSON[@"remark"];
        self.date_year = JSON[@"date_year"];
        self.date_month = JSON[@"date_month"];
        self.fee_time = JSON[@"fee_time"];
        self.sign = JSON[@"sign"];
        self.charging_method = JSON[@"charging_method"];
        self.cashier_id = JSON[@"cashier_id"];
        
        if ([JSON[@"invoice_no"] isKindOfClass:[NSString class]] && [JSON[@"invoice_no"] length]>0) {
            
            self.invoice_no = JSON[@"invoice_no"];
        }else{
            
            self.invoice_no = @"";
        }
        
        self.admin_name = JSON[@"admin_name"];
        self.real_name = JSON[@"real_name"];
    }
    
    return self;
}

@end
