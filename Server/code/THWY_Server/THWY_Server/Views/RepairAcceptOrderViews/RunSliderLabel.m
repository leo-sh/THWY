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
//@property CADisplayLink *displayLink;

@end

@implementation RunSliderLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.runTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];
//        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(runCircle)];

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
//    if(self.runTimer){
//        [self.runTimer invalidate];
//    }
//    if (self.displayLink) {
//        [self.displayLink invalidate];
////        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    }
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.frame.size.height)];
    //        left.alpha = 0.3;
    left.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self addSubview:left];
    
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-5, 0, 5, self.frame.size.height)];
    //        left.alpha = 0.3;
    right.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self addSubview:right];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label.text = _title;
    self.label.font = FontSize(CONTENT_FONT);
    self.label.numberOfLines = 1;
    self.label.textColor = [UIColor blackColor];
    [self.label sizeToFit];
    [self addSubview:self.label];
    
    [self.label sizeToFit];
    
    self.clipsToBounds = YES;
    
    //启动定时器
    [self.runTimer fire];
//    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(runCircle)];
//    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)runCircle{
    
    CGFloat _x = 2.0;
    __block CGRect frame = self.label.frame;
    if (frame.origin.x<-self.label.width) {
        frame = CGRectMake(self.width, 0, frame.size.width, frame.size.height);
    }else if (frame.origin.x == 0){
//        [NSThread sleepForTimeInterval:1.0];
        frame = CGRectMake(frame.origin.x-=_x, frame.origin.y, frame.size.width, frame.size.height);
    }else{
        frame = CGRectMake(frame.origin.x-=_x, frame.origin.y, frame.size.width, frame.size.height);
    }
    self.label.frame = frame;
//    NSLog(@"%@", NSStringFromCGRect(frame));
    
}

- (void)dealloc{
    
    [self.runTimer invalidate];
    
}

@end
