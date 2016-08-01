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
@end
@implementation ProclamationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.clipsToBounds = NO;
        
        self.head = [[UIImageView alloc]init];
        self.right = [[UIImageView alloc]init];
        self.title = [[UILabel alloc]init];
        self.time = [[UILabel alloc]init];
        self.content = [[UILabel alloc]init];
        
        NSLog(@"宽度为%f",self.contentView.width);
//        head.contentMode = UIViewContentModeScaleAspectFill;
        self.head.image = [UIImage imageNamed:@"彩条"];
        
        UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        left.center = CGPointMake(7, 7);
        left.image = [UIImage imageNamed:@"左"];
        
        self.right.image = [UIImage imageNamed:@"右"];
        
        self.title.textAlignment = NSTextAlignmentCenter;
        
        self.time.font = [UIFont systemFontOfSize:11];
        
        self.time.textAlignment = NSTextAlignmentCenter;

        
        self.time.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.head];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:left];
        [self.contentView addSubview:self.right];

        
    }
    return self;
}

- (void)updateFrame:(CGFloat)width
{
    self.head.frame = CGRectMake(0, 0, width, 3);
    
    self.right.frame = CGRectMake(0, 0, 30, 30);
    self.right.center = CGPointMake(width - 7, 7);
    
    self.title.frame = CGRectMake(0, CGRectGetMaxY(self.head.frame) + 5, width, 30);
    
    self.time.frame = CGRectMake(0, CGRectGetMaxY(self.title.frame), width, 14);
    NSLog(@"time.frame.height = %f",CGRectGetMaxY(self.time.frame));
    

}

- (void)setTitle:(NSString *)title time:(NSString *)time content:(NSString *)content width:(CGFloat)width
{
    self.title.text = title;
    self.time.text = time;
    self.content.text = content;
    self.content.numberOfLines = 0;
    self.content.font = [UIFont systemFontOfSize:CONTENT_FONT];
    [self updateFrame:width];

    CGFloat contenHeight = [content sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT] maxSize:CGSizeMake(width, 4000)].height;
    
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
