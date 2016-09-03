//
//  RecordImageCell.h
//  YTWY_Client
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordImageCell : UITableViewCell

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIViewController *vc;
@property (assign, nonatomic) CGFloat imageHeight;

- (void)loadDataWithModel:(RepairVO *)model;

@end
