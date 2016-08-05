//
//  HouseSourceCell.h
//  THWY_Client
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseVO.h"

@interface HouseSourceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label_houseSource;

@property (strong, nonatomic) HouseVO *model;

@end
