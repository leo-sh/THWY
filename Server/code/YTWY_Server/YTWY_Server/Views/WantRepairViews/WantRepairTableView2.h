//
//  WantRepairTableView2.h
//  YTWY_Server
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantRepairTableViewDelegate.h"

@interface WantRepairTableView2 : UITableView

@property (weak, nonatomic) id<WantRepairTableViewDelegate> repairDelegate;

@property (strong, nonatomic) NSMutableArray *repaireClassArrayPublic;

@end
