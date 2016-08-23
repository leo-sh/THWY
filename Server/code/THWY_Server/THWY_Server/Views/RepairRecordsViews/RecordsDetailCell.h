//
//  RecordsDetailCell.h
//  THWY_Client
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairVO.h"

@interface RecordsDetailCell : UITableViewCell

@property (assign, nonatomic) RepairType type;

- (void)loadDataWithModel:(RepairVO *)model indexpath:(NSIndexPath *)indexpath;

@end
