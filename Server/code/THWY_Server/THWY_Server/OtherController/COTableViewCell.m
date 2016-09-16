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
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
        
    }];
    
    self.icon.layer.cornerRadius = 25;
    
    self.icon.clipsToBounds = YES;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"Avatar"]];
    
    NSLog(@"iamge%@",icon);
    
    self.contentLabel.text = content;
    self.contentLabel.font = FontSize(CONTENT_FONT + 1);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor whiteColor];
    self.backView.image = [UIImage imageNamed:@"绿对话框"];
    
    CGFloat width = 180;
    
    self.contentLabel.frame = CGRectMake(10, 5, width, 30);
    CGFloat contentHeight = [content sizeWithFont:FontSize(CONTENT_FONT + 1) maxSize:CGSizeMake(width, 4000)].height;
    NSString *rowS = [NSString stringWithFormat:@"%d",self.section];
   __block NSString *heightS;
    if (contentHeight > 30) {
        self.contentLabel.height = contentHeight;
        
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.icon.mas_left).with.offset(-5);
            
            make.centerY.equalTo(self.contentView);
            
            make.size.mas_equalTo(CGSizeMake(width + 25, self.contentLabel.height + 10));
            
        }];
        
        heightS = [NSString stringWithFormat:@"%lf",contentHeight + 30];
            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"giveHeight" object:@{rowS:heightS}];

    }
    else
    {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.icon.mas_left).with.offset(-5);
        
        make.centerY.equalTo(self.contentView);
        
        make.size.mas_equalTo(CGSizeMake(width + 25, 40));
        
    }];
        heightS = [NSString stringWithFormat:@"%lf",60.0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"giveHeight" object:@{rowS:heightS}];

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
