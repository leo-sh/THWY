//
//  ComplaintVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplaintVO : NSObject

@property (nonatomic , copy) NSString              * callback_admin_id;
@property (nonatomic , copy) NSString              * house_id;
@property (nonatomic , copy) NSString              * estate;
@property (nonatomic , copy) NSString              * owner_id;
@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * callback_td;
@property (nonatomic , copy) NSString              * block;
@property (nonatomic , copy) NSString              * admin_id;
@property (nonatomic , copy) NSString              * complaint_type_name;
@property (nonatomic , copy) NSString              * complaint_content;
@property (nonatomic , copy) NSString              * complaint_type;
@property (nonatomic , copy) NSString              * callback_txt;
@property (nonatomic , copy) NSString              * layer;
@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * complaint_phone;
@property (nonatomic , copy) NSString              * deal_admin_id;
@property (nonatomic , copy) NSString              * callback_time;
@property (nonatomic , copy) NSString              * deal_dispatch_time;
@property (nonatomic , copy) NSString              * unit;
@property (nonatomic , copy) NSString              * remarks;
@property (nonatomic , copy) NSString              * deal_dispatch_admin_id;
@property (nonatomic , copy) NSString              * callback_xl;
@property (nonatomic , copy) NSString              * complaint_person;
@property (nonatomic , copy) NSString              * st;
@property (nonatomic , strong) ComplaintStateVO    * state;
@property (nonatomic , copy) NSString              * deal_remark;
@property (nonatomic , copy) NSString              * mph;

-(ComplaintVO* )initWithJSON:(NSDictionary *)JSON;

-(NSMutableDictionary* )toDic;

@end
