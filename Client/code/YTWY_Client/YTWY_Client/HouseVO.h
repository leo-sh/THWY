//
//  HouseVO.h
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseVO : NSObject <NSCoding>

@property (nonatomic , copy) NSString              * estate;
@property (nonatomic , copy) NSString              * elc_meter;
@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * decorate_st;
@property (nonatomic , copy) NSString              * block;
@property (nonatomic , copy) NSString              * structure;
@property (nonatomic , copy) NSString              * oid;
@property (nonatomic , copy) NSString              * water_meter;
@property (nonatomic , copy) NSString              * house_type;
@property (nonatomic , copy) NSString              * house_size;
@property (nonatomic , copy) NSString              * is_rent;
@property (nonatomic , copy) NSString              * fee_s_day;
@property (nonatomic , copy) NSString              * the_attr_a;
@property (nonatomic , copy) NSString              * layer;
@property (nonatomic , copy) NSString              * the_attr_b;
@property (nonatomic , copy) NSString              * renter_tel;
@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * fee_s_year;
@property (nonatomic , copy) NSString              * fee_s_month;
@property (nonatomic , copy) NSString              * renter_name;
@property (nonatomic , copy) NSString              * unit;
@property (nonatomic , copy) NSString              * warmer_meter;
@property (nonatomic , copy) NSString              * mph;

-(HouseVO* )initWithJSON:(NSDictionary *)JSON;
@end
