//
//  FindFriendTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "FindFriendTableViewCell.h"
#import "ServicesManager.h"
#import "SVProgressHUD.h"
@interface FindFriendTableViewCell()
@property UIImageView *icon;
@property UILabel *nameAndPhoneLabel;
@property UILabel *estateAndJob;
@property UIButton *addBtn;
@end
@implementation FindFriendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.icon = [[UIImageView alloc]init];
        self.nameAndPhoneLabel = [[UILabel alloc]init];
        self.estateAndJob = [[UILabel alloc]init];
        self.addBtn = [[UIButton alloc]init];
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.nameAndPhoneLabel];
        [self.contentView addSubview:self.estateAndJob];
        [self.contentView addSubview:self.addBtn];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIcon:(NSString *)icon NameAndphone:(NSString *)nameAndPhone EstateAndJob:(NSString *)estateAndJob
{
    CGFloat Btn_W = GetContentWidth(@"添加",CONTENT_FONT) + 20;
    
    self.icon.frame = CGRectMake(10, 5, 50, 50);
    
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"Avatar"]];
    
    CGFloat label_W = self.width - self.icon.right - Btn_W - 20 - 5;
    CGFloat label_L = self.icon.right + 10;
    
    
    
    self.nameAndPhoneLabel.frame = CGRectMake(label_L , 10, label_W, 20);
    
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:nameAndPhone];
    
    NSRange range = [nameAndPhone rangeOfString:@"1"];
    
    if (range.location != NSNotFound) {
        
        [aString addAttributes:@{NSForegroundColorAttributeName:CellUnderLineColor} range:NSMakeRange(range.location, aString.length - range.location)];
    }
    
    self.nameAndPhoneLabel.attributedText = aString;
    
    self.nameAndPhoneLabel.font = FontSize(CONTENT_FONT);
    
    

    
    self.estateAndJob.frame = CGRectMake(label_L, self.nameAndPhoneLabel.bottom, label_W, 20);
    
    self.estateAndJob.text = estateAndJob;
    
    self.estateAndJob.font = FontSize(CONTENT_FONT);
    
    self.addBtn.frame = CGRectMake(self.nameAndPhoneLabel.right, 10, Btn_W, 40);
    
    self.addBtn.backgroundColor = My_NAV_BG_Color;
    
    [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
    
    

}

- (void)clickAdd
{
    NSLog(@"添加");
    [[ServicesManager getAPI] addFriend:self.admin_id onComplete:^(NSString *errorMsg) {
        
        if (errorMsg) {
            [SVProgressHUD showWithStatus:errorMsg];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"添加成功"];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
