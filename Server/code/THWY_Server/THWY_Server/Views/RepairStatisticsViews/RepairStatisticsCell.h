//
//  RepairStatisticsCell.h
//  THWY_Server
//
//  Created by wei on 16/8/18.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairStatisticsCell : UITableViewCell

//indexPath.row
@property (assign, nonatomic) NSInteger index;
//类型 业主:1 公共:2
@property (assign, nonatomic) NSInteger flag;

- (void)loadDataFromSum:(NSString *)sumString;

@end
