//
//  BlueCheckButton.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BlueCheckButton.h"
@interface BlueCheckButton ()
@property UIImage *defualtImage;
@property UIImage *choosedImage;
@end
@implementation BlueCheckButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.chooseStatu = NO;
    }
    return self;
}

- (instancetype)initDefaultImageName:(NSString *)defaultImageName choosedImageName:(NSString *)choosedImageName title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.chooseStatu = NO;
        self.defualtImage = [UIImage imageNamed:defaultImageName];
        self.choosedImage = [UIImage imageNamed:choosedImageName];
        [self setImage:self.defualtImage forState:UIControlStateNormal];

        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super titleRectForContentRect:contentRect];
    rect.origin.x = self.height *1.2;
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(0, 0, self.height, self.height);
    return rect;
}

- (void)click
{

    if (!self.chooseStatu) {
        [self setImage:self.choosedImage forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:self.defualtImage forState:UIControlStateNormal];
    }
    self.chooseStatu =!self.chooseStatu;
    
}


@end
