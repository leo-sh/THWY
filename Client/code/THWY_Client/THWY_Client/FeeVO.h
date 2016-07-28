//
//  FeeVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeeHistoryVO.h"

typedef enum : int {
    All = -1,
    NonPayment,
    Part,
    Paid,
    Refund,
} FeeState;

@interface FeeVO : NSObject

@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * estate_name;
@property (nonatomic , copy) NSString              * is_month_charge;
@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * fee_cls;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * structure;
@property (nonatomic , copy) NSString              * fee_year;
@property (nonatomic , copy) NSString              * layer;
@property (nonatomic , copy) NSString              * fee_type;
@property (nonatomic , copy) NSString              * house_type;
@property (nonatomic , copy) NSString              * st;
@property (nonatomic , copy) NSString              * zc_type;
@property (nonatomic , copy) NSString              * real_name;
@property (nonatomic , copy) NSString              * is_year_charge;
@property (nonatomic , copy) NSString              * unit;
@property (nonatomic , copy) NSString              * mph;
@property (nonatomic , copy) NSString              * cls_unit;
@property (nonatomic , strong) NSNumber            * qian_fei;
@property (nonatomic , strong) NSMutableArray      * fee_history;
@property (nonatomic , copy) NSString              * cellphone;
@property (nonatomic , copy) NSString              * house_id;
@property (nonatomic , copy) NSString              * cls_fee;
@property (nonatomic , copy) NSString              * cls_name;
@property (nonatomic , copy) NSString              * s_time;
@property (nonatomic , copy) NSString              * house_size;
@property (nonatomic , copy) NSString              * decorate_st;
@property (nonatomic , copy) NSString              * how_much;
@property (nonatomic , copy) NSString              * zc;
@property (nonatomic , copy) NSString              * end_time;
@property (nonatomic , copy) NSString              * begin_time;
@property (nonatomic , copy) NSString              * actual;
@property (nonatomic , copy) NSString              * owner_id;
@property (nonatomic , copy) NSString              * e_time;
@property (nonatomic , strong) NSNumber            * estate_id;
@property (nonatomic , copy) NSString              * estate_pic;
@property (nonatomic , copy) NSString              * is_wyf;
@property (nonatomic , copy) NSString              * is_pm;
@property (nonatomic , copy) NSString              * refund;
@property (nonatomic , copy) NSString              * wyf_n;
@property (nonatomic , copy) NSString              * block;

-(FeeVO* )initWithJSON:(NSDictionary *)JSON;
@end
