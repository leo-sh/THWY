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
    rect.origin.x = 
    
    return rect;
}

- (void)setLeftImageView:(NSString *)imageName andTitle:(NSString *)title
{
    self.backgroundColor = [UIColor clearColor];
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.adjustsImageWhenHighlighted = NO;
}

@end
