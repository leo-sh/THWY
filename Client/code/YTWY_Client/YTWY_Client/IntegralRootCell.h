//
//  IntegralRootCell.h
//  YTWY_Client
//
//  Created by Mr.S on 16/8/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralRootCell : UITableViewCell

@property UIView* mainView;
@property UIView* bottomLine;

-(void)updateMainViewHeight:(CGFloat)cellHeight andTopCell:(BOOL)isTop andBottomCell:(BOOL)isBottom;
@end
