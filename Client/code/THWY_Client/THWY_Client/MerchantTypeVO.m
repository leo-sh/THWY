//
//  MerchantTypeVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MerchantTypeVO.h"

@implementation MerchantTypeVO

-(MerchantTypeVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.business_type_name = JSON[@"business_type_name"];
    }
    
    return self;
}

@end
