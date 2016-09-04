//
//  BussnessSelectButton.m
//  YTWY_Client
//
//  Created by wei on 16/8/15.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BussnessSelectButton.h"

@implementation BussnessSelectButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super imageRectForContentRect:contentRect];
    
    rect.origin.x = self.width - 5 - self.height * 0.2;
    rect.origin.y = self.height * 0.4;
    rect.size.width = self.height * 0.2;
    rect.size.height = self.height * 0.2;
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGRect rect = [super titleRectForContentRect:contentRect];
    rect.origin.x = 10;
    rect.size.height = self.height;
    rect.origin.y = 0;
    return rect;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.font = FontSize(CONTENT_FONT);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"repaire_下"] forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
        self.layer.borderColor = My_Color(236, 236, 236).CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

@end
