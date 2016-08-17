//
//  WantRepairTableView1.h
//  THWY_Server
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantRepairTableViewDelegate.h"

@interface WantRepairTableView1 : UITableView

@property (strong, nonatomic) NSMutableArray *repaireClassArrayPay;
@property (strong, nonatomic) NSMutableArray *repaireClassArrayFree;

@property (weak, nonatomic) id<WantRepairTableViewDelegate> repairDelegate;

@end
