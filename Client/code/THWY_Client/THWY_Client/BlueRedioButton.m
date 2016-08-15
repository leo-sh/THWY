//
//  BlueRedioButton.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BlueRedioButton.h"
@interface BlueRedioButton()
@property UIImage *defualtImage;
@property UIImage *choosedImage;
@end
@implementation BlueRedioButton
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super titleRectForContentRect:contentRect];
    rect.origin.x = 17;
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(0, (self.height - 15)/2, 15, 15);
    return rect;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.chooseStatu = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statuChange) name:@"判断" object:nil];
    }
    return self;
}

- (void)initDefaultImageName:(NSString *)defaultImageName choosedImageName:(NSString *)choosedImageName title:(NSString *)title
{
        self.defualtImage = [UIImage imageNamed:defaultImageName];
        self.choosedImage = [UIImage imageNamed:choosedImageName];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self setImage:self.defualtImage forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
}

- (void)initDefaultImageName:(NSString *)defaultImageName choosedImageName:(NSString *)choosedImageName
{
    self.defualtImage = [UIImage imageNamed:defaultImageName];
    self.choosedImage = [UIImage imageNamed:choosedImageName];
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self setImage:self.defualtImage forState:UIControlStateNormal];
}


- (void)click
{
    self.chooseStatu =!self.chooseStatu;
    
    [self statuChange];
    
    for (UIView *temp in self.superview.subviews) {
        if([temp isKindOfClass:[BlueRedioButton class]])
        {
            if (temp != self) {
                BlueRedioButton *btn = (BlueRedioButton *)temp;
                if (self.chooseStatu) {
                    btn.chooseStatu = NO;
                }
                else
                {
                    btn.chooseStatu = YES;
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"判断" object:nil];
            }
        }
    }

    
}

- (void)statuChange
{
    if (self.chooseStatu) {
        [self setImage:self.choosedImage forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:self.defualtImage forState:UIControlStateNormal];
    }
    
}

- (void)setChoosed
{
    self.chooseStatu = YES;
    [self statuChange];

}


@end
