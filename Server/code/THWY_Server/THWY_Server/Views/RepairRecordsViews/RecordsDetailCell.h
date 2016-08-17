//
//  RecordsDetailCell.h
//  THWY_Server
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairVO.h"

@interface RecordsDetailCell : UITableViewCell

- (void)loadDataWithModel:(RepairVO *)model indexpath:(NSIndexPath *)indexpath;

@end
