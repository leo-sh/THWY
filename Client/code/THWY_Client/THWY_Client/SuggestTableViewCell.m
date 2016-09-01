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

- (void)setTime:(NSString *)time content:(NSString *)content width:(CGFloat)width
{
    CGFloat contentWidth = width - 20;
    self.head.width = contentWidth;
    self.time.width = contentWidth;
    self.content.width = contentWidth;
    
    self.time.text = time;
    
    CGFloat content_H = [content sizeWithFont:FontSize(CONTENT_FONT) maxSize:CGSizeMake(width - 20, 4000)].height;
    
    self.content.frame = CGRectMake(5, self.time.bottom + 8, width - 20, content_H);
    self.content.text = content;
    self.content.numberOfLines = 0;
    self.content.font = FontSize(CONTENT_FONT);
    
    self.backView.frame = CGRectMake(10, 0, width - 20, self.content.height + 32 + 8 + 10);
    
    
    NSString *key = [NSString stringWithFormat:@"%d",self.section];
    NSString *value = [NSString stringWithFormat:@"%f",self.content.height + 32 + 8 + 10];
    
    NSDictionary *dic = @{key:value};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"giveHeight" object:dic];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
