//
//  RecordeRepeiringCell.m
//  THWY_Client
//
//  Created by wei on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecordeRepairingCell.h"
#import "RepairVO.h"
#import "RepairDetailController.h"

@interface RecordeRepairingCell ()

@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) RepairVO *model;

@property (strong, nonatomic) UIImageView *caiTiaoImage;
@property (strong, nonatomic) UIImageView *paiGongNumber;
@property (strong, nonatomic) UILabel *paiGongLabel;
@property (strong, nonatomic) UIButton *detail;
@property (strong, nonatomic) UILabel *line;

@end

@implementation RecordeRepairingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.caiTiaoImage = [[UIImageView alloc] init];
        self.paiGongNumber = [[UIImageView alloc] init];
        self.paiGongLabel = [[UILabel alloc] init];
        self.numberLabel = [[UILabel alloc] init];
        self.line = [[UILabel alloc] init];
        self.detail = [[UIButton alloc] init];
        
        [self.contentView addSubview:self.caiTiaoImage];
        [self.contentView addSubview:self.paiGongNumber];
        [self.contentView addSubview:self.paiGongLabel];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.detail];
        
    }
    return self;

}

- (void)displayCell{

    self.caiTiaoImage.frame = CGRectMake(0, 0, self.width, 2);
    self.caiTiaoImage.image = [UIImage imageNamed:@"records_彩条"];
    
    [self.detail setImage:[UIImage imageNamed:@"records_详情"] forState:UIControlStateNormal];
    [self.detail addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.detail];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.caiTiaoImage.mas_bottom).offset(5.0/375*My_ScreenW);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-4.0/375*My_ScreenW);
        make.width.mas_equalTo(self.detail.mas_height);
        make.height.mas_equalTo(self.paiGongNumber.mas_height).multipliedBy(2.0);
    }];
    
    self.paiGongNumber.image = [UIImage imageNamed:@"records_派工单号"];
    [self.paiGongNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(4.0/375*My_ScreenW);
        make.width.mas_equalTo(self.paiGongNumber.mas_height);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(25.0/667.0);
        make.centerY.mas_equalTo(self.detail.mas_centerY);
    }];
    
    self.paiGongLabel.text = @"派工单号:";
    self.paiGongLabel.font = [UIFont fontWithName:My_RegularFontName size:16.0];
    self.paiGongLabel.textColor = [UIColor darkGrayColor];
    [self.paiGongLabel sizeToFit];
    [self.paiGongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.paiGongNumber.mas_centerY);
        make.left.mas_equalTo(self.paiGongNumber.mas_right).offset(10.0/375*My_ScreenW);
    }];
    
    self.numberLabel.text = @"WX1223";
    self.numberLabel.font = [UIFont fontWithName:My_RegularFontName size:16.0];
    self.numberLabel.textColor = [UIColor darkGrayColor];
    [self.numberLabel sizeToFit];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.paiGongLabel.mas_centerY);
        make.left.mas_equalTo(self.paiGongLabel.mas_right).offset(10.0/375*My_ScreenW);
    }];

    
    
    [self.line setBackgroundColor:[UIColor lightGrayColor]];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.and.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.detail.mas_bottom).offset(5.0/375*My_ScreenW);
    }];

    
}

- (void)loadDataFromModel:(RepairVO *)repaireVO{
    
    self.model = repaireVO;
    self.numberLabel.text = repaireVO.Id;
    [self displayCell];
}

- (void)showDetail{
    
    RepairDetailController *detail = [[RepairDetailController alloc] init];
    detail.model = self.model;
    [self.vc.navigationController pushViewController:detail animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
