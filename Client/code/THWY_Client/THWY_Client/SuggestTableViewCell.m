//
//  SuggestTableViewCell.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/16.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "SuggestTableViewCell.h"
@interface SuggestTableViewCell()
@property UIImageView *head;
@property UIView *backView;
@end
@implementation SuggestTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHeight:) name:@"cellHeight" object:nil];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.head = [[UIImageView alloc]init];
        self.time = [[UILabel alloc]init];
        self.content = [[UILabel alloc]init];
        self.backView = [[UIView alloc]init];
        
        self.head.frame = CGRectMake(0, 0, 1, 3);
        
        self.time.frame = CGRectMake(0, 10, 1, 14);
                
        self.head.image = [UIImage imageNamed:@"bg_repair_history_color_bar_three"];
        
        self.time.font = FontSize(Content_Time_Font);
        
        self.time.textAlignment = NSTextAlignmentCenter;
        
        self.time.textColor = [UIColor lightGrayColor];
        
        [self.backView addSubview:self.time];
        [self.backView addSubview:self.head];
        [self.backView addSubview:self.content];
        
        self.backView.backgroundColor = WhiteAlphaColor;
        
        [self.contentView addSubview:self.backView];
        
        
    }
    return self;
}

- (void)updateFrame:(CGFloat)height Width:(CGFloat)width
{
    CGFloat contentWidth = width - 20;
    self.head.width = contentWidth;
    self.time.width = contentWidth;
    self.content.width = contentWidth;
    
}

- (void)getHeight:(NSNotification *)notification
{
    
    [self updateFrame:[notification.object[0] floatValue] Width:[notification.object[1] floatValue]];
}

- (void)setTime:(NSString *)time content:(NSString *)content width:(CGFloat)width
{
    self.time.text = time;
    
    self.content.frame = CGRectMake(5, self.time.bottom + 8, width - 20, My_ScreenH);
    self.content.text = content;
    self.content.numberOfLines = 0;
    self.content.font = FontSize(CONTENT_FONT);
    [self.content sizeToFit];
    
    self.backView.frame = CGRectMake(10, 0, width - 20, self.content.height + 32 + 8 + 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
