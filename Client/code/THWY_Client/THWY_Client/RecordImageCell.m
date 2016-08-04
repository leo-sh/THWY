//
//  RecordImageCell.m
//  THWY_Client
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecordImageCell.h"

@interface RecordImageCell ()

@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UIImageView *picImage;

@end

@implementation RecordImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.leftLabel = [[UILabel alloc] init];
        self.picImage = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.picImage];
        
        CGFloat topMargin = 8.0/375*My_ScreenW;
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(topMargin);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        [self.picImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftLabel.mas_left);
            make.top.mas_equalTo(self.leftLabel.mas_bottom).offset(topMargin);
            make.height.mas_equalTo(My_ScreenH*0.2);
        }];
        
        
    }
    return self;
}

- (void)loadDataWithModel:(RepairVO *)model{
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"beijing"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
