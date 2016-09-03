//
//  HouseSourceCell.h
//  YTWY_Server
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HouseVO.h"

@interface HouseSourceCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *housesArray;

@property (assign, nonatomic) NSInteger selectedIndex;

- (void)updateFrame;

@end
