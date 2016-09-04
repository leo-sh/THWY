//
//  IntegralRootCell.m
//  YTWY_Client
//
//  Created by Mr.S on 16/8/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "IntegralRootCell.h"

@interface IntegralRootCell ()

@property UIView* leftLine;
@property UIView* topLine;
@property UIView* rightLine;

@end

@implementation IntegralRootCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = My_clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.mainView = [[UIView alloc]initWithFrame:CGRectMake(10/375.0*My_ScreenW, 0, My_ScreenW - 20/375.0*My_ScreenW, 0)];
        self.mainView.backgroundColor = WhiteAlphaColor;
        [self.contentView addSubview:self.mainView];
        
        self.topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.mainView.width, 0.5)];
        self.topLine.backgroundColor = CellUnderLineColor;
        self.topLine.hidden = YES;
        [self.mainView addSubview:self.topLine];
        
        self.leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, self.mainView.height)];
        self.leftLine.backgroundColor = CellUnderLineColor;
        [self.mainView addSubview:self.leftLine];
        
        self.rightLine = [[UIView alloc]initWithFrame:CGRectMake(self.mainView.width - 0.5, 0, 0.5, self.mainView.height)];
        self.rightLine.backgroundColor = CellUnderLineColor;
        [self.mainView addSubview:self.rightLine];
        
        self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(10/375.0*My_ScreenW, self.mainView.height - 0.5, self.mainView.width - 20/375.0*My_ScreenW, 0.5)];
        self.bottomLine.backgroundColor = CellUnderLineColor;
        [self.mainView addSubview:self.bottomLine];
    }
    return self;
}

-(void)updateMainViewHeight:(CGFloat)cellHeight andTopCell:(BOOL)isTop andBottomCell:(BOOL)isBottom
{
    self.mainView.height = cellHeight;
    
    if (isTop) {
        self.topLine.hidden = NO;
        self.bottomLine.x = 25/375.0*My_ScreenW;
        self.bottomLine.width = self.mainView.width - 50/375.0*My_ScreenW;
    }else
    {
        self.topLine.hidden = YES;
        if (isBottom) {
            self.bottomLine.x = 0;
            self.bottomLine.width = self.mainView.width;
        }else
        {
            self.bottomLine.x = 25/375.0*My_ScreenW;
            self.bottomLine.width = self.mainView.width - 50/375.0*My_ScreenW;
        }
    }
    
    self.leftLine.height = cellHeight;
    self.rightLine.height = cellHeight;
    self.bottomLine.y = cellHeight - 0.5;
}

@end
