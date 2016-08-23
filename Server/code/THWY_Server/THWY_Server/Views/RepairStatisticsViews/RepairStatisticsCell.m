//
//  RepairStatisticsCell.m
//  THWY_Server
//
//  Created by wei on 16/8/18.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatisticsCell.h"

@interface RepairStatisticsCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (strong, nonatomic) NSArray *titleNames;

@end

@implementation RepairStatisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleNames = @[@"未处理:", @"处理中:", @"处理完毕:", @"已回访:"];
        
    }
    return self;
}

- (void)initViews{
    
    CGFloat leftMargin = 6/667.0*My_ScreenH;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.titleNames[self.index];
    self.titleLabel.font = FontSize(CONTENT_FONT+2);
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel sizeToFit];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(leftMargin);
        make.centerY.mas_equalTo(self.contentView.centerY);
    }];
    
    
    self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"repairStatistics_%@", self.titleNames[self.index]]]];
    [self.contentView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(leftMargin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(self.rightImageView.mas_height).multipliedBy(35/36.0);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = FontSize(CONTENT_FONT+1);
    self.contentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(leftMargin);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(self.rightImageView.mas_left).offset(-leftMargin);
        make.height.mas_equalTo(self.titleLabel.mas_height);
    }];
}

- (void)loadDataFromRepairVO:(RepairStatisticVO *)model{
    self.contentLabel.text = model.sum;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    [self initViews];
}

@end
