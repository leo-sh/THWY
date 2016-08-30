//
//  WRTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/23.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WRTableViewCell.h"
#import "RunSliderLabel.h"
@interface WRTableViewCell()
@property UITextView *contentTextView;
@property UIImageView *backGroundView;
@end
@implementation WRTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backGroundView = [[UIImageView alloc]init];
        self.backGroundView.image = [UIImage imageNamed:@"WR展开"];
        [self.contentView addSubview:self.backGroundView];
        
        self.contentTextView = [[UITextView alloc]init];
        [self.contentView addSubview:self.contentTextView];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    self.contentTextView.text = title;
    self.contentTextView.font = FontSize(CONTENT_FONT);
    self.contentTextView.userInteractionEnabled = NO;
    self.contentTextView.backgroundColor = [UIColor clearColor];
    CGFloat height = [title sizeWithFont:FontSize(CONTENT_FONT) maxSize:CGSizeMake(self.width - 20, 4000)].height;
    
    if (height < 60) {
        
        self.contentTextView.frame = CGRectMake(10, 10, self.width - 20, 60);

    }
    else
    {
        self.contentTextView.frame = CGRectMake(10, 10, self.width - 20, height + 10);
        NSLog(@"%@",title);
    }
    
    NSString *heightString = [NSString stringWithFormat:@"%f",self.contentTextView.bottom + 10];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"giveCell" object:heightString];
    
    self.backGroundView.frame = CGRectMake(0, 0, self.width, self.contentTextView.bottom);
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = NO;
    
    
    
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
