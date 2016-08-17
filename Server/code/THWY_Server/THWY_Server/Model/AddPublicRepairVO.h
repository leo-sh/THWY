//
//  AddPublicRepairVO.h
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "Repair_RootVO.h"

@interface AddPublicRepairVO : Repair_RootVO

@property (nonatomic , copy) NSString              * estate_id;//楼盘
@property (nonatomic , copy) NSString              * block;//楼栋号
@property (nonatomic , copy) NSString              * unit;//单元号
@property (nonatomic , copy) NSString              * layer;//楼层
@property (nonatomic , copy) NSString              * call_name;
@property (nonatomic , copy) NSString              * call_phone;
@property (nonatomic , copy) NSString              * cls;
@property (nonatomic , copy) NSString              * repair_detail;
@property int kb;//(开单1，补单2)

@end
