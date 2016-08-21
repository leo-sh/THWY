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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    
    CGFloat leftMargin = 6/667.0*My_ScreenH;
    CGFloat jianju = -0.25*(2*leftMargin+24*35/36.0);
    self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"repairStatistics_完工率"]];
    [self.contentView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(leftMargin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(self.rightImageView.mas_height).multipliedBy(35/36.0);
    }];
    
    
    self.titleLabel1 = [[UILabel alloc] init];
    self.titleLabel1.text = @"完工率: ";
    self.titleLabel1.font = FontSize(CONTENT_FONT+2);
    self.titleLabel1.textColor = [UIColor blackColor];
    [self.titleLabel1 sizeToFit];
    [self.contentView addSubview:self.titleLabel1];
    
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(leftMargin);
        make.centerY.mas_equalTo(self.contentView.centerY);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.25).offset(jianju);
    }];
    
    self.contentLabel1 = [[UILabel alloc] init];
    self.contentLabel1.font = FontSize(CONTENT_FONT+1);
    self.contentLabel1.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.contentLabel1];
    [self.contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_right);
        make.centerY.mas_equalTo(self.titleLabel1.mas_centerY);
        make.width.mas_equalTo(self.titleLabel1.mas_width);
        make.height.mas_equalTo(self.titleLabel1.mas_height);
    }];
    
    self.titleLabel2 = [[UILabel alloc] init];
    self.titleLabel2.text = @"回访率: ";
    self.titleLabel2.font = FontSize(CONTENT_FONT+2);
    self.titleLabel2.textColor = [UIColor blackColor];
    [self.titleLabel2 sizeToFit];
    [self.contentView addSubview:self.titleLabel2];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLabel1.mas_right);
        make.centerY.mas_equalTo(self.contentView.centerY);
    }];
    
    self.contentLabel2 = [[UILabel alloc] init];
    self.contentLabel2.font = FontSize(CONTENT_FONT+1);
    self.contentLabel2.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.contentLabel2];
    [self.contentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel2.mas_right);
        make.centerY.mas_equalTo(self.titleLabel1.mas_centerY);
        make.width.mas_equalTo(self.titleLabel1.mas_width);
        make.height.mas_equalTo(self.titleLabel1.mas_height);
    }];
    

}

- (void)loadDataFromRepairVO:(RepairStatisticVO *)model{
//    self.contentLabel1.text = [NSString stringWithFormat:@"%0.2f%", model];
//    self.contentLabel2.text = [NSString stringWithFormat:@"%0.2f%", model];
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    [self initViews];
}

@end
