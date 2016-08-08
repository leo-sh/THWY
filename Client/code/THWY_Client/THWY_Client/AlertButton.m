//
//  AlertButton.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/7.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertButton.h"
@interface AlertButton()
@property UIImage *defualtImage;
@property UIImage *openedImage;
@end
@implementation AlertButton

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
        
        self.titleLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"repaire_下"] forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}


- (void)click
{
    if (self.openStatu) {
        [self setImage:self.openedImage forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:self.defualtImage forState:UIControlStateNormal];
    }
    self.openStatu = !self.openStatu;
    
}

@end
