//
//  RunSliderLabel.m
//  THWY_Server
//
//  Created by wei on 16/8/22.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RunSliderLabel.h"

@interface RunSliderLabel ()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSTimer *runTimer;

@end

@implementation RunSliderLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    
    if (![_title isEqualToString:title]) {
        _title = [title copy];
    }
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    if (self.runTimer) {
        [self.runTimer invalidate];
    }
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label.text = _title;
    self.label.font = FontSize(CONTENT_FONT);
    self.label.numberOfLines = 1;
    self.label.textColor = [UIColor blackColor];
    [self.label sizeToFit];
    [self addSubview:self.label];
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.frame.size.height)];
    left.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    [self addSubview:left];
    
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-10, 0, 10, self.frame.size.height)];
    right.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    [self addSubview:right];
    
    self.clipsToBounds = YES;
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(CONTENT_FONT),NSFontAttributeName, nil];
//    CGRect rect = [_title boundingRectWithSize:CGSizeMake(0, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    if (self.width<rect.size.width) {
//        //启动定时器
//        self.runTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.runTimer forMode:NSRunLoopCommonModes];
//
//    }
    
    //启动定时器
    self.runTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.runTimer forMode:NSRunLoopCommonModes];
    
}

- (void)runCircle{
    
    CGFloat _x = 0.5;
    __block CGRect frame = self.label.frame;
    if (frame.origin.x<-self.label.width) {
        frame = CGRectMake(self.width, 0, frame.size.width, frame.size.height);
        self.label.frame = frame;
    }else if (frame.origin.x == 0){
//        [NSThread sleepForTimeInterval:1.0];
        frame = CGRectMake(frame.origin.x-=_x, frame.origin.y, frame.size.width, frame.size.height);
        [UIView animateWithDuration:0.03 animations:^{
            self.label.frame = frame;
        }];
    }else{
        frame = CGRectMake(frame.origin.x-=_x, frame.origin.y, frame.size.width, frame.size.height);
        [UIView animateWithDuration:0.03 animations:^{
            self.label.frame = frame;
        }];
    }
//    self.label.frame = frame;
    
}

- (void)dealloc{
    
    [self.runTimer invalidate];
    
}

@end
