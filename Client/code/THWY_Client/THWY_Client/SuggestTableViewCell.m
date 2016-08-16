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
                
        self.head.image = [UIImage imageNamed:@"彩条"];
        
        self.time.font = [UIFont systemFontOfSize:11];
        
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
    self.backView.frame = CGRectMake(10, 0, contentWidth, height);
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
    self.content.text = content;
    self.content.numberOfLines = 0;
    self.content.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    CGFloat contenHeight = [content sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT] maxSize:CGSizeMake(width, 4000)].height;
    self.content.frame = CGRectMake(5, self.time.bottom + 8, width - 10, contenHeight);
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
