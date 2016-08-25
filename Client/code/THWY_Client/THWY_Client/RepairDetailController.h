//
//  RepaireDetailController.h
//  THWY_Client
//
//  Created by wei on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RootVC.h"
#import "RepairVO.h"

@interface RepairDetailController : RootVC

@property (copy, nonatomic) NSString *repairVOId;
@property (assign, nonatomic) RepairType type;

@property (assign, nonatomic) CGFloat imageHeight;

@end
