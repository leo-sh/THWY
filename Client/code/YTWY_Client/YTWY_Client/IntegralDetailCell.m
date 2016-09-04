//
//  IntegralDetailCell.m
//  YTWY_Client
//
//  Created by Mr.S on 16/8/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "IntegralDetailCell.h"

@interface IntegralDetailCell ()

@property UILabel* titleLabel;
@property UILabel* valueLabel;

@end

@implementation IntegralDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25/375.0*My_ScreenW, 0, 0, 0)];
        self.titleLabel.font = FontSize(CONTENT_FONT+1);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = CellTextColor;
        [self.mainView addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.valueLabel.font = self.titleLabel.font;
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.textColor = self.titleLabel.textColor;
        [self.mainView addSubview:self.valueLabel];
    }
    return self;
}

-(void)fillCell:(BOOL)isBottom andPoint:(PointVO *)point
{
    self.titleLabel.width = self.mainView.width/2;
    self.valueLabel.width = self.mainView.width/2;
    self.titleLabel.text = point.s;
    self.valueLabel.text = [NSString stringWithFormat:@"%@分",point.sub_total];
    
    [self.titleLabel sizeToFit];
    [self.valueLabel sizeToFit];
    
    self.valueLabel.x = self.mainView.width - self.valueLabel.width - self.titleLabel.x;
    
    [self updateMainViewHeight:50/375.0*My_ScreenW andTopCell:NO andBottomCell:isBottom];
}

-(void)updateMainViewHeight:(CGFloat)cellHeight andTopCell:(BOOL)isTop andBottomCell:(BOOL)isBottom
{
    [super updateMainViewHeight:cellHeight andTopCell:isTop andBottomCell:isBottom];
    self.titleLabel.height = self.mainView.height;
    self.valueLabel.height = self.mainView.height;
}

@end
