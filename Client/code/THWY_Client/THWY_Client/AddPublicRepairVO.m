//
//  AddPublicRepairVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AddPublicRepairVO.h"

@implementation AddPublicRepairVO

-(NSDictionary *)toDic
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    params[@"estate_id"] = self.estate_id;
    params[@"block"] = self.block;
    params[@"unit"] = self.unit;
    params[@"layer"] = self.layer;
    params[@"call_name"] = self.call_name;
    params[@"call_phone"] = self.call_phone;
    params[@"cls"] = self.cls;
    params[@"repair_detail"] = self.repair_detail;
    params[@"kb"] = [NSString stringWithFormat:@"%d",self.kb];
    
    return params;
}

@end
