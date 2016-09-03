//
//  ReviseBtn.m
//  YTWY_Server
//
//  Created by HuangYiZhe on 16/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ReviseBtn.h"

@implementation ReviseBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super imageRectForContentRect:contentRect];
    
    rect.size.width = self.height;
    rect.origin.y = 0;
    rect.origin.x = 5;
    rect.size.height = rect.size.width;
    
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super titleRectForContentRect:contentRect];
    
    rect.origin.x = self.height + 10;
    return rect;
}

- (void)setLeftImageView:(NSString *)imageName andTitle:(NSString *)title
{
    self.backgroundColor = [UIColor clearColor];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage imageNamed:@"信息修改按钮"] forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage imageNamed:@"信息修改按钮按下"] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = FontSize(CONTENT_FONT);
    self.adjustsImageWhenHighlighted = NO;
}


@end
