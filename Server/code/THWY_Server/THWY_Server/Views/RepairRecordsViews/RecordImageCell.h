//
//  RecordImageCell.h
//  THWY_Client
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordImageCell : UITableViewCell

@property UIViewController* vc;

- (void)loadDataWithModel:(RepairVO *)model;

@end
