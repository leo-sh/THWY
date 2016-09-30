//
//  DropMenuCell.m
//  YTWY_Client
//
//  Created by wei on 16/9/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "DropMenuCell.h"

@implementation DropMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.icon = [UIImageView new];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(22);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
    }];
    
    self.label = [UILabel new];
    self.label.backgroundColor = My_clearColor;
    self.label.font = FontSize(16.5);
    [self.label sizeToFit];
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.left.mas_equalTo(self.icon.mas_right).offset(15);
    }];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
