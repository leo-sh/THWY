//
//  HouseSourceCell.m
//  YTWY_Server
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "HouseSourceCell.h"

@interface HouseSourceCell ()

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *label;

@end

@implementation HouseSourceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectedIndex = -1;
        self.icon = [[UIImageView alloc] initWithImage:[UIImage scaleImage:[UIImage imageNamed:@"repaire_项目"] toScale:0.8]];
        [self.contentView addSubview:self.icon];
        self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        NSInteger topMargin = 10.0/375*My_ScreenH;
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(topMargin);
            make.left.mas_equalTo(self.contentView.mas_left).offset(topMargin);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.text = @"房源:";
        self.label.font = [UIFont fontWithName:My_RegularFontName size:15.0];
        [self.contentView addSubview:self.label];
        [self.label sizeToFit];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.icon.mas_centerY);
            make.left.mas_equalTo(self.icon.mas_right).offset(10);
        }];
        
    }
    return self;

}

- (void)updateFrame{
    
    NSInteger topMargin = 10.0/667*My_ScreenH;
    for (int i = 0; i < self.housesArray.count; i++) {
        
        if([self.contentView viewWithTag:420]){
            return;
        }
        
        UIImageView *selectIcon = [[UIImageView alloc] initWithImage:[UIImage scaleImage:[UIImage imageNamed:@"repaire_unselected"] toScale:0.5]];
        selectIcon.tag = 420+i;
        selectIcon.userInteractionEnabled = YES;
        [self.contentView addSubview:selectIcon];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [selectIcon addGestureRecognizer:tap];
        [selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.label.mas_bottom).offset(topMargin*0.6 + i*(topMargin*0.6+20/713.0*My_ScreenH));
            make.left.mas_equalTo(self.icon.mas_centerX);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 410+i;
#pragma Mark  - TODO
//        [btn setTitle:[self getHouseStringFromHouseVO:self.housesArray[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:My_RegularFontName size:14.0];
        [btn addTarget:self action:@selector(selectIcon:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(selectIcon.mas_right).offset(topMargin*0.7);
            make.centerY.mas_equalTo(selectIcon.mas_centerY);
        }];
    }

    
}

- (void)selectIcon:(UIButton *)btn{
    if (self.selectedIndex != -1) {
        UIImageView *iconimage = [self.contentView viewWithTag:self.selectedIndex + 420];
        iconimage.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_unselected"] toScale:0.5];
    }
    
    NSInteger index = btn.tag + 10;
    self.selectedIndex = index - 420;
    UIImageView *newicon = [self.contentView viewWithTag:index];
    newicon.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_selected"] toScale:0.5];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    if (self.selectedIndex != -1) {
        UIImageView *iconimage = [self.contentView viewWithTag:self.selectedIndex + 420];
        iconimage.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_unselected"] toScale:0.5];
    }
    
    UIImageView *newicon = (UIImageView *)tap.view;
    self.selectedIndex = newicon.tag - 420;
    newicon.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_selected"] toScale:0.5];

}

//- (NSString *)getHouseStringFromHouseVO:(HouseVO *)house{
//
//    return [NSString stringWithFormat:@"%@%@栋%@单元%@室",house.estate,house.block,house.unit,house.mph];
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
