//
//  PaigongCatogerysCell.h
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaigongCatogerysCell : UITableViewCell

@property (assign, nonatomic) BOOL showPikerView;
@property (assign, nonatomic) int flag;
@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger order_timestamp;

- (void)updateView;

@end
