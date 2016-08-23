//
//  WhiteListTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/21.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WhiteListTableViewCell.h"
#import "ReviseBtn.h"
@interface WhiteListTableViewCell()
@property UILabel *estateLabel;
@property UILabel *IPLabel;
@property ReviseBtn *ReviseBtn;
@end
@implementation WhiteListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.estateLabel = [[UILabel alloc]init];
        self.IPLabel = [[UILabel alloc]init];
        self.ReviseBtn = [[ReviseBtn alloc]init];
        
        [self.contentView addSubview:self.estateLabel];
        [self.contentView addSubview:self.IPLabel];
        [self.contentView addSubview:self.ReviseBtn];
        
    }
    return self;
}

- (void)setEstate:(NSString *)estate IP:(NSString *)ip
{
    self.estateLabel.text = estate;
    self.IPLabel.text = ip;
    self.IPLabel.font = FontSize(Content_Ip_Font);
    [self.ReviseBtn setLeftImageView:@"b修改" andTitle:@"修改"];
    
    CGFloat estateWidth = GetContentWidth(estate, CONTENT_FONT);
    
    self.estateLabel.frame = CGRectMake(10, 0, estateWidth, self.height);
    
    CGFloat IpWidth = GetContentWidth(ip, Content_Ip_Font);
    
    self.IPLabel.frame = CGRectMake(self.estateLabel.left + 15, 0, IpWidth, self.height);
    
    [self.ReviseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(70, self.height));
    }];
//    self.ReviseBtn.backgroundColor = [UIColor blackColor];
    [self.ReviseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.ReviseBtn.titleLabel.font = FontSize(CONTENT_FONT);
    
    [self.ReviseBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)click
{
    NSLog(@"修改");
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
