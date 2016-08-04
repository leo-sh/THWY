//
//  RecordeRepeiringCell.h
//  THWY_Client
//
//  Created by wei on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordeRepairingCell : UITableViewCell

@property UIViewController *vc;

- (void)loadDataFromModel:(RepairVO *)repaireVO;

- (CGFloat)heightForCell;

@end
