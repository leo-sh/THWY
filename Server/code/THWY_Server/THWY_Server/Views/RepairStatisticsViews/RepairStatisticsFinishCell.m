//
//  RepairStatisticsFinishCell.m
//  THWY_Server
//
//  Created by wei on 16/8/19.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatisticsFinishCell.h"

@interface RepairStatisticsFinishCell ()

@property (strong, nonatomic) UILabel *titleLabel1;
@property (strong, nonatomic) UILabel *contentLabel1;
@property (strong, nonatomic) UILabel *titleLabel2;
@property (strong, nonatomic) UILabel *contentLabel2;
@property (strong, nonatomic) UIImageView *rightImageView;

@end

@implementation RepairStatisticsFinishCell

- (void)initViews{
    
    CGFloat leftMargin = 6/667.0*My_ScreenH;
    self.titleLabel1 = [[UILabel alloc] init];
    self.titleLabel1.text = @"完工率:";
    self.titleLabel1.font = FontSize(CONTENT_FONT+2);
    self.titleLabel1.textColor = [UIColor blackColor];
    [self.titleLabel1 sizeToFit];
    [self.contentView addSubview:self.titleLabel1];
    
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(leftMargin);
        make.centerY.mas_equalTo(self.contentView.centerY);
    }];
    
    
    self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"repairStatistics_完工率"]];
    [self.contentView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(leftMargin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(self.titleLabel1.mas_height).offset(10);
        make.width.mas_equalTo(self.rightImageView.mas_height).multipliedBy(35/36.0);
    }];
    
    self.contentLabel1 = [[UILabel alloc] init];
    self.contentLabel1.font = FontSize(CONTENT_FONT+1);
    self.contentLabel1.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.contentLabel1];
    [self.contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_right).offset(leftMargin);
        make.centerY.mas_equalTo(self.titleLabel1.mas_centerY);
        make.width.mas_equalTo(self.rightImageView.mas_left).offset(-leftMargin);
        make.height.mas_equalTo(self.titleLabel1.mas_height);
    }];
}

- (void)loadDataFromRepairVO:(RepairStatisticVO *)model{
//    self.contentLabel.text = model.sum;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    [self initViews];
}

@end
