//
//  MerchantVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MerchantVO.h"

@implementation MerchantVO

-(MerchantVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.admin_id = JSON[@"admin_id"];
        self.estate_id = JSON[@"estate_id"];
        self.house_id = JSON[@"house_id"];
        self.business_type_id = JSON[@"business_type_id"];
        self.business_name = JSON[@"business_name"];
        self.business_person = JSON[@"business_person"];
        self.telephone = JSON[@"telephone"];
        self.addr = JSON[@"addr"];
        self.intro = JSON[@"intro"];
        self.pic = JSON[@"pic"];
        self.st = JSON[@"st"];
        self.ctime = JSON[@"ctime"];
        self.is_tuijian = JSON[@"is_tuijian"];
        self.business_type_name = JSON[@"business_type_name"];
        
        self.products = [[NSMutableArray alloc]init];
        if ([JSON[@"products"][@"datas"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary* foodDic in JSON[@"products"][@"datas"]) {
                GoodVO* food = [[GoodVO alloc]initWithJSON:foodDic];
                [self.products addObject:food];
            }
        }
        
    }
    
    return self;
}

@end
