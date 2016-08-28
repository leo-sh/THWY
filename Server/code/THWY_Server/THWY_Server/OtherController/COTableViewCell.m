//
//  COTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "COTableViewCell.h"
#import "Masonry.h"
@interface COTableViewCell()
@property UIImageView *icon;
@property UILabel *contentLabel;
@property UIImageView *backView;
@property int number;
@end
@implementation COTableViewCell
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
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
        
    }];
    self.contentLabel.text = content;
    self.contentLabel.font = FontSize(CONTENT_FONT);
    self.contentLabel.numberOfLines = 0;
    
//    self.contentLabel.backgroundColor = [UIColor yellowColor];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.icon.mas_left).with.offset(-5);
        
        make.centerY.equalTo(self.contentView);
        
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    self.backView.image = [UIImage imageNamed:@"绿对话框"];
    
    self.contentLabel.frame = CGRectMake(10, 5, 125, 20);
    CGFloat contentHeight = [content sizeWithFont:FontSize(CONTENT_FONT) maxSize:CGSizeMake(140, 4000)].height;
    NSString *rowS = [NSString stringWithFormat:@"%ld",self.section];
   __block NSString *heightS;
    if (contentHeight > CONTENT_FONT) {
        self.contentLabel.height = contentHeight;
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
          
            make.height.mas_equalTo(contentHeight + 10);
            heightS = [NSString stringWithFormat:@"%lf",contentHeight + 10];
        }];
    }
    else
    {
        heightS = [NSString stringWithFormat:@"%lf",self.height];
    }
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
