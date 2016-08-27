//
//  IntegralTitleCell.m
//  THWY_Client
//
//  Created by Mr.S on 16/8/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "IntegralTitleCell.h"

@interface IntegralTitleCell ()

@property UIButton* usedIntegral;
@property UIButton* surplusIntegral;
@property UILabel* titleLabel;

@end

@implementation IntegralTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self updateMainViewHeight:90/375.0*My_ScreenW andTopCell:YES andBottomCell:NO];
        
        self.usedIntegral = [[UIButton alloc]initWithFrame:CGRectMake(25/375.0*My_ScreenW, 20/375.0*My_ScreenW, 125/375.0*My_ScreenW, 30/375.0*My_ScreenW)];
        self.usedIntegral.titleLabel.font = FontSize(CONTENT_FONT + 1);
        self.usedIntegral.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.usedIntegral setTitle:@"积分抵扣:0" forState:UIControlStateNormal];
        [self.usedIntegral setTitleColor:CellTextColor forState:UIControlStateNormal];
        self.usedIntegral.clipsToBounds = YES;
        self.usedIntegral.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.usedIntegral.layer.borderWidth = 0.5;
        self.usedIntegral.layer.borderColor = CellUnderLineColor.CGColor;
        self.usedIntegral.layer.cornerRadius = 4.0;
        [self.mainView addSubview:self.usedIntegral];
        
        self.surplusIntegral = [[UIButton alloc]initWithFrame:CGRectMake(self.mainView.width - self.usedIntegral.x - self.usedIntegral.width, self.usedIntegral.y, self.usedIntegral.width, self.usedIntegral.height)];
        self.surplusIntegral.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.surplusIntegral setTitle:@"积分余额:0" forState:UIControlStateNormal];
        [self.surplusIntegral setTitleColor:CellTextColor forState:UIControlStateNormal];
        self.surplusIntegral.clipsToBounds = YES;
        self.surplusIntegral.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.surplusIntegral.titleLabel.font = self.usedIntegral.titleLabel.font;
        self.surplusIntegral.layer.borderWidth = 0.5;
        self.surplusIntegral.layer.cornerRadius = self.usedIntegral.layer.cornerRadius;
        self.surplusIntegral.layer.borderColor = CellUnderLineColor.CGColor;
        [self.mainView addSubview:self.surplusIntegral];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.usedIntegral.bottom + 5/375.0*My_ScreenW, My_ScreenW, My_ScreenH)];
        self.titleLabel.text = @"积分明细";
        self.titleLabel.font = FontSize(CONTENT_FONT - 1);
        self.titleLabel.textColor = CellUnderLineColor;
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(self.mainView.width/2, self.titleLabel.center.y);
        [self.mainView addSubview:self.titleLabel];
    }
    return self;
}

-(void)fillCellWith:(NSDictionary* )dic
{
    
}

@end
