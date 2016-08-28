//
//  CMTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "CMTableViewCell.h"
@interface CMTableViewCell()
@property UIImageView *icon;
@property UILabel *contentLabel;
@property UIImageView *backView;
@property int number;
@end
@implementation CMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.number = 0;
        self.icon = [[UIImageView alloc]init];
        self.contentLabel = [[UILabel alloc]init];
        self.backView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.icon];
        [self.backView addSubview:self.contentLabel];
    }
    return self;
}

- (void)setIcon:(NSString *)icon Content:(NSString *)content
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"Avatar"]];
    self.icon.frame = CGRectMake(10, 5, 30, 30);
    
    self.contentLabel.text = content;
    self.contentLabel.font = FontSize(CONTENT_FONT);
    self.contentLabel.numberOfLines = 0;
    self.backView.frame = CGRectMake(self.icon.right + 5, 0, 150, 30);
    self.backView.centerY = self.icon.centerY;
    self.backView.image = [UIImage imageNamed:@"白对话框"];
    
    self.contentLabel.frame = CGRectMake(15, 5, 125, 20);
    CGFloat contentHeight = [content sizeWithFont:FontSize(CONTENT_FONT) maxSize:CGSizeMake(125, 4000)].height;
    if (contentHeight > CONTENT_FONT) {
        self.contentLabel.height = contentHeight;
        self.backView.height += contentHeight - CONTENT_FONT;
    }
    NSString *rowS = [NSString stringWithFormat:@"%ld",self.section];
    NSString *heightS = [NSString stringWithFormat:@"%lf",self.backView.bottom];
    if (self.number == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"giveHeight" object:@{rowS:heightS}];
        
        self.number ++;
    }
    else
    {
        self.number = 0;
    }

    
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
