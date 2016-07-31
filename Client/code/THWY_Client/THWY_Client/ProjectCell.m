//
//  ProjectCell.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ProjectCell.h"

@interface ProjectCell()


@property (weak, nonatomic) IBOutlet UIButton *btn_select;

@end

@implementation ProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btn_select.layer.borderWidth = 1;
    self.btn_select.layer.borderColor = [UIColor grayColor].CGColor;
    
}

- (IBAction)select:(UIButton *)sender {
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
