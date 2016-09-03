//
//  RecordVideoCell.h
//  YTWY_Client
//
//  Created by wei on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordVideoCell : UITableViewCell

@property (strong, nonatomic) UIViewController *vc;

- (void)loadDataWithModel:(RepairVO *)model;

@end
