//
//  FeeHistoryVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeeHistoryVO : NSObject

@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * real_name;
@property (nonatomic , copy) NSString              * date_year;
@property (nonatomic , copy) NSString              * cashier_id;
@property (nonatomic , copy) NSString              * admin_id;
@property (nonatomic , copy) NSString              * fee_owner_id;
@property (nonatomic , copy) NSString              * fee;
@property (nonatomic , copy) NSString              * invoice_no;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * charging_method;
@property (nonatomic , copy) NSString              * fee_time;
@property (nonatomic , copy) NSString              * admin_name;
@property (nonatomic , copy) NSString              * date_month;
@property (nonatomic , copy) NSString              * sign;
@property (nonatomic , copy) NSString              * cashier_name;

-(FeeHistoryVO* )initWithJSON:(NSDictionary *)JSON;

@end
