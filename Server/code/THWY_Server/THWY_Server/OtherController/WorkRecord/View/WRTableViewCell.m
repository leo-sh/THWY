//
//  WRTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/23.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WRTableViewCell.h"
#import "RunSliderLabel.h"
@interface WRTableViewCell()
@property UILabel *contentLabel;
@property UILabel *timeLabel;

@end
@implementation WRTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
