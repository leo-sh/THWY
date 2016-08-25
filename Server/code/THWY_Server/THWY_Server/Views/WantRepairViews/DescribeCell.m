//
//  DescribeCell.m
//  THWY_Server
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "DescribeCell.h"

@interface DescribeCell ()

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation DescribeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.commitBtn.layer.cornerRadius= 5;
    self.commitBtn.clipsToBounds = YES;
    
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (IBAction)commit:(UIButton *)sender {
    
    [self.delegate commit];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
