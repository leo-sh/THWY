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
    
    rect.size.height = rect.size.height * 0.5;
    rect.size.width = rect.size.height*20/17.0;
    rect.origin.x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10;
    rect.origin.y = self.height*0.5-rect.size.height*0.5;
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect rect = [super titleRectForContentRect:contentRect];
    rect.origin.x -= 15;
    
    return rect;
}

- (void)setLeftImageView:(NSString *)imageName andTitle:(NSString *)title
{
    self.backgroundColor = My_Color(44, 191, 114);
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = FontSize(CONTENT_FONT+3);
//    [self setImage:[UIImage scaleImage:[UIImage imageNamed:imageName] toScale:0.5] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.adjustsImageWhenHighlighted = NO;
}

@end
