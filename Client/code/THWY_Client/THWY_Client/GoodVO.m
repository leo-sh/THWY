//
//  FoodVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "GoodVO.h"

@implementation GoodVO

-(GoodVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.business_id = JSON[@"business_id"];
        self.goods_name = JSON[@"goods_name"];
        self.goods_intro = JSON[@"goods_intro"];
        self.pic = JSON[@"pic"];
        self.tj = JSON[@"tj"];
        self.ctime = JSON[@"ctime"];
        self.business_name = JSON[@"business_name"];
        self.telephone = JSON[@"telephone"];
        self.addr = JSON[@"addr"];
    }
    
    return self;
}

@end
