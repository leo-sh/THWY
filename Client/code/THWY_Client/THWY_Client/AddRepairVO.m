//
//  AddRepairVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AddRepairVO.h"

@implementation AddRepairVO

-(NSDictionary *)toDic
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    params[@"call_person"] = self.call_person;
    params[@"call_phone"] = self.call_phone;
    params[@"house_id"] = self.house_id;
    params[@"cls"] = self.cls;
    params[@"detail"] = self.detail;
    params[@"kb"] = [NSString stringWithFormat:@"%d",self.kb];
    if (self.kb == 3) {
        if (self.order_timestamp > 0) {
            self.order_timestamp -= 8*3600;
            params[@"order_timestamp"] = [NSString stringWithFormat:@"%ld",self.order_timestamp];
        }else
        {
            return nil;
        }
    }
    
    return params;
}

@end
