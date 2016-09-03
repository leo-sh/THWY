//
//  RepaireDetailController.h
//  YTWY_Client
//
//  Created by wei on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RootVC.h"
#import "RepairVO.h"
#import "RecordImageCell.h"

//记录详情 or 接单详情
typedef NS_ENUM(NSUInteger, DisplayType) {
    RecordDetailType = 1,
    RepairStatisticsDetailType
};

@interface RepairDetailController : RootVC

@property (copy, nonatomic) NSString *repairVOId;
@property (assign, nonatomic) RepairType type;

@property (assign, nonatomic) DisplayType displayType;

@property (assign, nonatomic) CGFloat imageHeight;

@end
