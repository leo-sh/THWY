//
//  RepairStatisticsDataCell.m
//  THWY_Server
//
//  Created by wei on 16/8/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatisticsDataCell.h"
#import "StaffRepairStatisticVO.h"
@interface RepairStatisticsDataCell ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *nameDetailLabel;

@property (strong, nonatomic) UILabel *paiGongCountLabel;
@property (strong, nonatomic) UILabel *paiGongCountDetailLabel;

@property (strong, nonatomic) UILabel *finishCountLabel;
@property (strong, nonatomic) UILabel *finishCountDetailLabel;

@property (strong, nonatomic) UILabel *finishRateLabel;
@property (strong, nonatomic) UILabel *finishRateDetalLabel;

@property (strong, nonatomic) UILabel *timeCountLabel;
@property (strong, nonatomic) UILabel *timeCountDetailLabel;

@property (strong, nonatomic) UILabel *averageTimeCountLabel;
@property (strong, nonatomic) UILabel *averageTimeCountDetailLabel;

@end

@implementation RepairStatisticsDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;      // 让cell的y值增加5(根据自己需要分割线的高度来进行调整)
    frame.size.height -= 15;   // 让cell的高度减15
    [super setFrame:frame];   // 别忘了重写父类方法
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        
        CGFloat leftMargin = 20.0;
        CGFloat topMargin = 20.0;
        self.nameLabel = [UILabel new];
        self.nameLabel.text = @"姓名: ";
        [self setAttributesToLabel:self.nameLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(leftMargin);
            make.top.mas_equalTo(self.contentView.mas_top).offset(topMargin);
        }];
        
        self.nameDetailLabel = [UILabel new];
        [self setAttributesToLabel:self.nameDetailLabel];
        [self.contentView addSubview:self.nameDetailLabel];
        [self.nameDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            make.left.mas_equalTo(self.nameLabel.mas_right);
        }];
        
        self.paiGongCountLabel = [UILabel new];
        self.paiGongCountLabel.text = @"派工总数: ";
        [self setAttributesToLabel:self.paiGongCountLabel];
        [self.contentView addSubview:self.paiGongCountLabel];
        [self.paiGongCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_centerX);
        }];
        
        self.paiGongCountDetailLabel = [UILabel new];
        [self setAttributesToLabel:self.paiGongCountDetailLabel];
        [self.contentView addSubview:self.paiGongCountDetailLabel];
        [self.paiGongCountDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.paiGongCountLabel.mas_centerY);
            make.left.mas_equalTo(self.paiGongCountLabel.mas_right);
        }];
        
        self.finishCountLabel = [UILabel new];
        self.finishCountLabel.text = @"完工数: ";
        [self setAttributesToLabel:self.finishCountLabel];
        [self.contentView addSubview:self.finishCountLabel];
        [self.finishCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(topMargin);
            make.left.mas_equalTo(self.nameLabel.mas_left);
        }];
        
        self.finishCountDetailLabel = [UILabel new];
        [self setAttributesToLabel:self.finishCountDetailLabel];
        [self.contentView addSubview:self.finishCountDetailLabel];
        [self.finishCountDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.finishCountLabel.mas_centerY);
            make.left.mas_equalTo(self.finishCountLabel.mas_right);
        }];
        
        self.finishRateLabel = [UILabel new];
        self.finishRateLabel.text = @"完工率: ";
        [self setAttributesToLabel:self.finishRateLabel];
        [self.contentView addSubview:self.finishRateLabel];
        [self.finishRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.finishCountLabel.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_centerX);
        }];
        
        self.finishRateDetalLabel = [UILabel new];
        [self setAttributesToLabel:self.finishRateDetalLabel];
        [self.contentView addSubview:self.finishRateDetalLabel];
        [self.finishRateDetalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.finishCountLabel.mas_centerY);
            make.left.mas_equalTo(self.finishRateLabel.mas_right);
        }];
        
        self.timeCountLabel = [UILabel new];
        self.timeCountLabel.text = @"总用工时: ";
        [self setAttributesToLabel:self.timeCountLabel];
        [self.contentView addSubview:self.timeCountLabel];
        [self.timeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.finishCountLabel.mas_bottom).offset(topMargin);
            make.left.mas_equalTo(self.finishCountLabel.mas_left);
        }];
        
        self.timeCountDetailLabel = [UILabel new];
        [self setAttributesToLabel:self.timeCountDetailLabel];
        [self.contentView addSubview:self.timeCountDetailLabel];
        [self.timeCountDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeCountLabel.mas_centerY);
            make.left.mas_equalTo(self.timeCountLabel.mas_right);
        }];
        
        self.averageTimeCountLabel = [UILabel new];
        self.averageTimeCountLabel.text = @"平均时效: ";
        [self setAttributesToLabel:self.averageTimeCountLabel];
        [self.contentView addSubview:self.averageTimeCountLabel];
        [self.averageTimeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeCountLabel.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_centerX);
        }];
        
        self.averageTimeCountDetailLabel = [UILabel new];
        [self setAttributesToLabel:self.averageTimeCountDetailLabel];
        [self.contentView addSubview:self.averageTimeCountDetailLabel];
        [self.averageTimeCountDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeCountLabel.mas_centerY);
            make.left.mas_equalTo(self.averageTimeCountLabel.mas_right);
        }];
        
        
    }
    return self;
}

- (void)setAttributesToLabel:(UILabel *)label{
    
    label.textColor = [UIColor blackColor];
    label.font = FontSize(CONTENT_FONT);
    [label sizeToFit];
    
}

- (void)loadDataFromModel:(StaffRepairStatisticVO *)model{
    if (model) {
        self.nameDetailLabel.text = model.real_name;
        self.paiGongCountDetailLabel.text = model.task_tot.stringValue;
        self.finishCountDetailLabel.text = model.task_done.stringValue;
        if ([model.task_tot integerValue] == 0) {
            self.finishRateDetalLabel.text = @"100%";
        }else{
            self.finishRateDetalLabel.text = [NSString stringWithFormat:@"%.2f%%", 100*[model.task_done doubleValue]/[model.task_tot doubleValue]];
        }
        self.timeCountDetailLabel.text = [NSString stringWithFormat:@"%.2f小时",[model.task_tot_time doubleValue]];
        self.averageTimeCountDetailLabel.text = [NSString stringWithFormat:@"%.2f小时",[model.task_avg doubleValue]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
