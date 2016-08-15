//
//  ProjectCell.h
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn_project;
@property (weak, nonatomic) IBOutlet UIButton *btn_block;
@property (weak, nonatomic) IBOutlet UIButton *btn_unit;
@property (weak, nonatomic) IBOutlet UIButton *btn_layer;

@property (copy, nonatomic) NSString *selectEstate_id;

@end
