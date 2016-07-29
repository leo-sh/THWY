//
//  AddRepairVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "Repair_RootVO.h"

@interface AddRepairVO : Repair_RootVO

@property (nonatomic , copy) NSString              * call_person;
@property (nonatomic , copy) NSString              * call_phone;
@property (nonatomic , copy) NSString              * house_id;
@property (nonatomic , copy) NSString              * cls;
@property (nonatomic , copy) NSString              * detail;

@end
