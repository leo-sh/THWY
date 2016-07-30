//
//  ReviseBtn.m
//  THWY_Client
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
    
    rect.size.width = self.height * 0.4;
    rect.origin.y = self.height * 0.3;
    rect.size.height = rect.size.width;
    
    return rect;
}
@end
