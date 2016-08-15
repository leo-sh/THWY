//
//  TextFieldCell.m
//  THWY_Client
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "TextFieldCell.h"
#import "Masonry/Masonry.h"

@implementation TextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
//    self.icon = [[UIImageView alloc] init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
