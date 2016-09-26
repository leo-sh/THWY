//
//  RepairStatisticsCell.m
//  YTWY_Server
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
//    [self initViews];
    if(index == 3){
        if (self.flag == 1) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@: ", self.titleNames[self.index]];
            self.rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"repairStatistics_%@", self.titleNames[self.index]]];
        }else{
            self.titleLabel.text = [NSString stringWithFormat:@"完工率: "];
            self.rightImageView.image = [UIImage imageNamed:@"repairStatistics_完工率"];
        }
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@: ", self.titleNames[self.index]];
        self.rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"repairStatistics_%@", self.titleNames[self.index]]];
    }
}


- (NSArray *)titleNames{
    
    if (_titleNames == nil) {
        _titleNames = @[@"未处理", @"处理中", @"处理完毕", @"已回访"];
    }
    
    return _titleNames;
}

- (void)initViews{
    
    CGFloat leftMargin = 10/667.0*My_ScreenH;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = [NSString stringWithFormat:@"%@: ", self.titleNames[self.index]];
    self.titleLabel.font = FontSize(CONTENT_FONT+1);
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel sizeToFit];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(leftMargin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    
    self.rightImageView = [[UIImageView alloc] init];
//                           WithImage:[UIImage imageNamed:[NSString stringWithFormat:@"repairStatistics_%@", self.titleNames[self.index]]]];
    [self.contentView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2*leftMargin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(self.rightImageView.mas_height).multipliedBy(35/36.0);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = FontSize(CONTENT_FONT+1);
    self.contentLabel.textColor = [UIColor blackColor];
    [self.contentLabel sizeToFit];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(leftMargin);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
//        make.right.mas_equalTo(self.rightImageView.mas_left).offset(-leftMargin);
    }];

}

- (void)loadDataFromSum:(NSString *)sumString{
    self.contentLabel.text = sumString;
}

@end
