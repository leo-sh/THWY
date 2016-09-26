//
//  AlertButton.m
//  YTWY_Client
//
//  Created by HuangYiZhe on 16/8/7.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertButton.h"
@interface AlertButton()<AlertTabelViewDelegate>
@property UIImage *defualtImage;
@property UIImage *openedImage;
@property int method;
@property CGFloat frameY;
@property CGFloat frameX;
@property NSArray *data;
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
        
        self.titleLabel.font = FontSize(CONTENT_FONT);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self setImage:[UIImage imageNamed:@"repaire_下"] forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
        self.layer.borderColor = CellUnderLineColor.CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}


- (void)click
{
//    if (self.openStatu) {
//        [self setImage:self.openedImage forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self setImage:self.defualtImage forState:UIControlStateNormal];
//    }
//    self.openStatu = !self.openStatu;
    
    self.alertView = [[AlertTableView2 alloc]initWithNumber:self.method withData:self.data];
    
    self.alertView.AlertDelegate = self;
    
//    if (self.alertView.method != GetComplainType) {
    
        [self.alertView showOriginY:self.frameY showCentenX:self.frameX];
//    }
}

- (void)setGetDataMethod:(GetDataMethod)method OriginY:(CGFloat)y showCentenX:(CGFloat)x withData:(NSArray *)data
{
    self.method = method;
    self.frameX = x;
    self.frameY = y;
    self.data = data;
}

- (void)returnData:(NSArray *)array
{
    [self setTitle:array[0] forState:UIControlStateNormal];
    self.postID = array[1];
    
}

@end
