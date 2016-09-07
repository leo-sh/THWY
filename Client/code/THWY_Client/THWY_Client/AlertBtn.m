//
//  AlertBtn.m
//  THWY_Client
//
//  Created by wei on 16/9/7.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertBtn.h"

@implementation AlertBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect = [super imageRectForContentRect:contentRect];
    rect.size.width = 22.0;
    rect.size.height = 22.0;
    rect.origin.x = 0.5*(self.frame.size.width - rect.size.width);
    rect.origin.y = 0.5*(self.frame.size.height - rect.size.height);
    return rect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
