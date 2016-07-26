//
//  HouseVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "HouseVO.h"

@implementation HouseVO

-(HouseVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.estate_id = JSON[@"estate_id"];
        self.house_type = JSON[@"house_type"];
        self.block = JSON[@"block"];
        self.unit = JSON[@"unit"];
        self.layer = JSON[@"layer"];
        self.mph = JSON[@"mph"];
        self.structure = JSON[@"structure"];
        self.house_size = JSON[@"house_size"];
        self.oid = JSON[@"oid"];
        self.is_rent = JSON[@"is_rent"];
        self.fee_s_year = JSON[@"fee_s_year"];
        self.fee_s_month = JSON[@"fee_s_month"];
        self.fee_s_day = JSON[@"fee_s_day"];
        self.the_attr_a = JSON[@"the_attr_a"];
        self.the_attr_b = JSON[@"the_attr_b"];
        self.water_meter = JSON[@"water_meter"];
        self.elc_meter = JSON[@"elc_meter"];
        self.warmer_meter = JSON[@"warmer_meter"];
        self.renter_name = JSON[@"renter_name"];
        self.renter_tel = JSON[@"renter_tel"];
        self.decorate_st = JSON[@"decorate_st"];
        self.estate = JSON[@"estate"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.estate_id forKey:@"estate_id"];
    [encoder encodeObject:self.house_type forKey:@"house_type"];
    [encoder encodeObject:self.block forKey:@"block"];
    [encoder encodeObject:self.unit forKey:@"unit"];
    [encoder encodeObject:self.layer forKey:@"layer"];
    [encoder encodeObject:self.mph forKey:@"mph"];
    [encoder encodeObject:self.structure forKey:@"structure"];
    [encoder encodeObject:self.house_size forKey:@"house_size"];
    [encoder encodeObject:self.oid forKey:@"oid"];
    [encoder encodeObject:self.is_rent forKey:@"is_rent"];
    [encoder encodeObject:self.fee_s_year forKey:@"fee_s_year"];
    [encoder encodeObject:self.fee_s_month forKey:@"fee_s_month"];
    [encoder encodeObject:self.fee_s_day forKey:@"fee_s_day"];
    [encoder encodeObject:self.the_attr_a forKey:@"the_attr_a"];
    [encoder encodeObject:self.the_attr_b forKey:@"the_attr_b"];
    [encoder encodeObject:self.water_meter forKey:@"water_meter"];
    [encoder encodeObject:self.elc_meter forKey:@"elc_meter"];
    [encoder encodeObject:self.warmer_meter forKey:@"warmer_meter"];
    [encoder encodeObject:self.renter_name forKey:@"renter_name"];
    [encoder encodeObject:self.renter_tel forKey:@"renter_tel"];
    [encoder encodeObject:self.decorate_st forKey:@"decorate_st"];
    [encoder encodeObject:self.estate forKey:@"estate"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.estate_id = [decoder decodeObjectForKey:@"estate_id"];
        self.house_type = [decoder decodeObjectForKey:@"house_type"];
        self.block = [decoder decodeObjectForKey:@"block"];
        self.unit = [decoder decodeObjectForKey:@"unit"];
        self.layer = [decoder decodeObjectForKey:@"layer"];
        self.mph = [decoder decodeObjectForKey:@"mph"];
        self.structure = [decoder decodeObjectForKey:@"structure"];
        self.house_size = [decoder decodeObjectForKey:@"house_size"];
        self.oid = [decoder decodeObjectForKey:@"oid"];
        self.is_rent = [decoder decodeObjectForKey:@"is_rent"];
        self.fee_s_year = [decoder decodeObjectForKey:@"fee_s_year"];
        self.fee_s_month = [decoder decodeObjectForKey:@"fee_s_month"];
        self.fee_s_day = [decoder decodeObjectForKey:@"fee_s_day"];
        self.the_attr_a = [decoder decodeObjectForKey:@"the_attr_a"];
        self.the_attr_b = [decoder decodeObjectForKey:@"the_attr_b"];
        self.water_meter = [decoder decodeObjectForKey:@"water_meter"];
        self.elc_meter = [decoder decodeObjectForKey:@"elc_meter"];
        self.warmer_meter = [decoder decodeObjectForKey:@"warmer_meter"];
        self.renter_name = [decoder decodeObjectForKey:@"renter_name"];
        self.renter_tel = [decoder decodeObjectForKey:@"renter_tel"];
        self.decorate_st = [decoder decodeObjectForKey:@"decorate_st"];
        self.estate = [decoder decodeObjectForKey:@"estate"];
    }
    return self;
}

@end
