//
//  ProclamationTableViewCell.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ProclamationTableViewCell.h"
@interface ProclamationTableViewCell()
@property UIImageView *head;
@property UIImageView *right;
@property UIView *backView;
@end
@implementation ProclamationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHeight:) name:@"cellHeight" object:nil];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.head = [[UIImageView alloc]init];
        self.right = [[UIImageView alloc]init];
        self.title = [[UILabel alloc]init];
        self.time = [[UILabel alloc]init];
        self.content = [[UILabel alloc]init];
        self.backView = [[UIView alloc]init];
        
        self.head.frame = CGRectMake(0, 0, 1, 3);
        self.right.frame = CGRectMake(0, 0, 20, 20);
        self.title.frame = CGRectMake(0, CGRectGetMaxY(self.head.frame) + 5, 1, 30);
        
        self.time.frame = CGRectMake(0, CGRectGetMaxY(self.title.frame), 1, 14);

        self.backView.backgroundColor = [UIColor whiteColor];

        self.head.image = [UIImage imageNamed:@"bg_repair_history_color_bar_three"];
        
        UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        left.center = CGPointMake(9, 0);
        left.image = [UIImage imageNamed:@"左"];
        
        self.right.image = [UIImage imageNamed:@"右"];
        
        self.title.textAlignment = NSTextAlignmentCenter;
        
        self.time.font = FontSize(Content_Time_Font);
        
        self.time.textAlignment = NSTextAlignmentCenter;

        self.time.textColor = [UIColor lightGrayColor];
        
        [self.backView addSubview:self.title];
        [self.backView addSubview:self.time];
        [self.backView addSubview:self.head];
        [self.backView addSubview:self.content];
        [self.contentView addSubview:left];
        [self.backView addSubview:self.right];
        
        self.backView.backgroundColor = WhiteAlphaColor;
        
        [self.contentView addSubview:self.backView];

        
    }
    return self;
}

- (void)updateFrame:(CGFloat)height Width:(CGFloat)width
{
    CGFloat contentWidth = width;
    self.backView.frame = CGRectMake(0, 0, contentWidth, height);
    self.head.width = contentWidth;
    self.time.width = contentWidth;
    self.title.width = contentWidth;
    self.content.width = contentWidth;
    self.right.center = CGPointMake(contentWidth - 9, 0);

}

- (void)getHeight:(NSNotification *)notification
{

    [self updateFrame:[notification.object[0] floatValue] Width:[notification.object[1] floatValue]];
}

- (void)setTitle:(NSString *)title time:(NSString *)time content:(NSString *)content width:(CGFloat)width
{
    self.title.text = title;
    self.time.text = time;
    self.content.text = content;
    self.content.numberOfLines = 6;
    self.content.font = FontSize(CONTENT_FONT);
    CGFloat contenHeight = [content sizeWithFont:FontSize(CONTENT_FONT) maxSize:CGSizeMake(width, 4000)].height;
    self.content.frame = CGRectMake(5, CGRectGetMaxY(self.time.frame) + 8, width - 10, contenHeight);
    
    
    
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
