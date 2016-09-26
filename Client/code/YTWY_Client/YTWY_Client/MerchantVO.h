//
//  MerchantVO.h
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodVO.h"

@interface MerchantVO : NSObject

@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * intro;
@property (nonatomic , copy) NSString              * st;
@property (nonatomic , copy) NSString              * admin_id;
@property (nonatomic , copy) NSString              * business_type_id;
@property (nonatomic , copy) NSString              * addr;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * business_name;
@property (nonatomic , copy) NSString              * house_id;
@property NSMutableArray                           * products;
@property (nonatomic , copy) NSString              * telephone;
@property (nonatomic , copy) NSString              * business_type_name;
@property (nonatomic , copy) NSString              * is_tuijian;
@property (nonatomic , copy) NSString              * business_person;

-(MerchantVO* )initWithJSON:(NSDictionary *)JSON;
@end
