//
//  DescribeCell.m
//  THWY_Client
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "DescribeCell.h"
#import "Masonry/Masonry.h"

@interface DescribeCell ()


@end

@implementation DescribeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    
}

- (IBAction)commit:(UIButton *)sender {
    
    [self.delegate commit];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
