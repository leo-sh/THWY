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
@property UIImageView *backViewTop;
@property UIImageView *backViewCenter;
@property UIImageView *backViewBottom;
@property UIImageView *jiantou;
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
        
        self.backViewTop = [[UIImageView alloc]init];
        self.backViewCenter = [[UIImageView alloc]init];
        self.backViewBottom = [[UIImageView alloc]init];
        self.jiantou = [[UIImageView alloc]init];
        [self.backView addSubview:self.backViewTop];
        [self.backView addSubview:self.backViewCenter];
        [self.backView addSubview:self.backViewBottom];
        [self.backView addSubview:self.jiantou];
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
    
//    NSLog(@"iamge%@",icon);
    
    self.contentLabel.text = content;
    self.contentLabel.font = FontSize(CONTENT_FONT + 1);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor whiteColor];
//    self.backView.image = [UIImage imageNamed:@"绿对话框"];
    
    CGFloat width = 180;
    
    self.contentLabel.frame = CGRectMake(10, 5, width - 10, 30);
    CGFloat contentHeight = [content sizeWithFont:FontSize(CONTENT_FONT + 1) maxSize:CGSizeMake(width - 10, 4000)].height;
    NSString *rowS = [NSString stringWithFormat:@"%d",self.section];
   __block NSString *heightS;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    if (contentHeight > 30) {
        self.contentLabel.height = contentHeight;
        
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.icon.mas_left).with.offset(-5);
            
            make.centerY.equalTo(self.contentView);
            
            make.size.mas_equalTo(CGSizeMake(width + 25, self.contentLabel.height + 10));
            
        }];
        
        heightS = [NSString stringWithFormat:@"%lf",contentHeight + 30];
            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"giveHeight" object:@{rowS:heightS}];
        dispatch_group_leave(group);

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
        
        dispatch_group_leave(group);

    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        CGFloat backSubView_W = width + 10;
        
        self.backViewTop.frame = CGRectMake(0, 0, backSubView_W, 10);
        self.backViewBottom.frame = CGRectMake(0, self.backView.bottom - 20,backSubView_W , 10);
        
        self.backViewCenter.frame = CGRectMake(0, 10, backSubView_W, self.backView.height - 20);
        
        self.jiantou.frame = CGRectMake(backSubView_W - 1, 0, 15, 22.0/25*15);
        self.jiantou.centerY = self.contentView.height/2 - 10;
    });

    self.backViewTop.image = [UIImage imageNamed:@"绿-聊天框顶部"];
    self.backViewCenter.image = [UIImage imageNamed:@"绿-聊天内容一行区域"];
    self.backViewBottom.image = [UIImage imageNamed:@"绿-聊天框底部"];
    self.jiantou.image = [UIImage imageNamed:@"绿-聊天框箭头"];
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
