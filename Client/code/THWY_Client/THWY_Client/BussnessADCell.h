//
//  BussnessADCell.h
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdVO.h"

@interface BussnessADCell : UITableViewCell

@property (strong, nonatomic) UIViewController *vc;

- (void)loadDataFromMercharge:(AdVO *)merchant;

- (CGFloat)heightForCell;

@end
