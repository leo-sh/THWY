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

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        self.label.centerY = self.centerY;
        self.label.text = title;
        self.label.font = FontSize(CONTENT_FONT);
        self.label.numberOfLines = 1;
        self.label.textColor = [UIColor blackColor];
        [self.label sizeToFit];
        [self addSubview:self.label];
        
        [self.label sizeToFit];
        
        self.clipsToBounds = YES;
        
        self.runTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(runCircle:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)runCircle:(NSTimer *)timer{
    CGFloat _x = 2.0;
    __block CGRect frame = self.label.frame;
    if (frame.origin.x<-self.label.width) {
        frame = CGRectMake(self.width, 0, frame.size.width, frame.size.height);
    }else if (frame.origin.x == 0){
        [NSThread sleepForTimeInterval:1.0];
        frame = CGRectMake(frame.origin.x-=_x, frame.origin.y, frame.size.width, frame.size.height);
    }else{
        frame = CGRectMake(frame.origin.x-=_x, frame.origin.y, frame.size.width, frame.size.height);
    }
    self.label.frame = frame;
    
}

- (void)dealloc{
    
    [self.runTimer invalidate];
    
}

@end
