//
//  RepairAcceptOrderCell.m
//  THWY_Server
//
//  Created by wei on 16/8/22.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairAcceptOrderCell.h"

@interface RepairAcceptOrderCell ()

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *houseLabel;
@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *houseDetailLabel;
@property (strong, nonatomic) UILabel *categoryDetailLabel;
@property (strong, nonatomic) UILabel *timeDetailLabel;

@end

@implementation RepairAcceptOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat topMargin = 10/667.0*My_ScreenH;
        self.leftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.leftImageView];
        
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.height.mas_equalTo(50/667.0*My_ScreenH);
            make.width.mas_equalTo(self.leftImageView.mas_height);
        }];
        
        self.houseLabel = [[UILabel alloc] init];
        self.houseLabel.text = @"报修房源:";
        [self.contentView addSubview:self.houseLabel];
        [self.houseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(topMargin);
            make.left.mas_equalTo(self.leftImageView.mas_right).offset(topMargin);
        
        }];
        
        
        
        
    }
    return self;
    
}

- (void)setAttributesForLabel:(UILabel *)label{
    
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    label.numberOfLines = 1;
    label.font = FontSize(CONTENT_FONT);
    
}


@end
