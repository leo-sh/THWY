//
//  PaigongCatogerysCell.h
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaigongCatogerysCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn_yuyue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint3;

@property (assign, nonatomic) BOOL showPikerView;
@property (assign, nonatomic) int flag;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIViewController *vc;
@property (assign, nonatomic) NSUInteger order_timestamp;

- (void)updateView;

@end
