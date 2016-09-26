//
//  UIRunLabel.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/24.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "UIRunLabel.h"
@interface UIRunLabel()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSTimer *runTimer;
@property (strong,nonatomic) UILabel *lastLabel;
@end
@implementation UIRunLabel
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(self.width, self.height);
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.userInteractionEnabled = NO;
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,GetContentWidth(title, CONTENT_FONT) , self.height)];
//        self.label.text = title;
        self.label.font = FontSize(CONTENT_FONT);
        [self addSubview:self.label];
        if (GetContentWidth(title, CONTENT_FONT) > self.width) {
            
            self.runTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(run) userInfo:nil repeats:YES];
            
            self.lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.label.right + 50, 0, self.label.width, self.label.height)];
            self.lastLabel.text = title;
            self.lastLabel.font = FontSize(CONTENT_FONT);
            [self addSubview:self.lastLabel];
            
        }
    }
    return self;
}

- (void)run
{
    static CGFloat offset = 0 ;
    offset ++;
    static int number = 0;
    [UIView animateWithDuration:0.013 animations:^{
        [self setContentOffset:CGPointMake(offset, 0)];
    }];
    if (offset == self.label.width *(number +1)&&number %2 == 0) {
        self.label.x = self.lastLabel.right + 50;
        number ++;

    }
    else if(offset == self.label.width *(number +1)  &&number %2 == 1)
    {
        self.lastLabel.x = self.label.right + 50;
        number ++;
    }
}

- (void)dealloc
{
    [self.runTimer invalidate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
