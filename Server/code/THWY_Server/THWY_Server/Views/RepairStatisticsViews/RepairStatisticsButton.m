//
//  RepairStatisticsButton.m
//  THWY_Server
//
//  Created by wei on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatisticsButton.h"

@implementation RepairStatisticsButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super imageRectForContentRect:contentRect];
    
//    rect.origin.y = self.height * 0.3;
    rect.size.height = self.height * 0.4;
    rect.size.width = rect.size.height*20/17.0;
    rect.origin.x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10;

    return rect;
}

- (void)setLeftImageView:(NSString *)imageName andTitle:(NSString *)title
{
    self.backgroundColor = My_Color(44, 191, 114);
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = FontSize(CONTENT_FONT+3);
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.adjustsImageWhenHighlighted = NO;
}

@end
