//
//  MyFriendTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MyFriendTableViewCell.h"
#import "CommunicateViewController.h"
@interface MyFriendTableViewCell()
@property UIImageView *icon;
@property  UILabel *label;
@property UIButton *phoneBtn;
@property UIButton * communionBtn;
@property NSString *Id;
@end
@implementation MyFriendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        
       self.icon  = [[UIImageView alloc]init];
        
       self.label = [[UILabel alloc]init];
        
        self.phoneBtn = [[UIButton alloc]init];
        
        [self.phoneBtn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        
        [self.phoneBtn addTarget:self action:@selector(clickPhone) forControlEvents:UIControlEventTouchUpInside];
        
        [self.phoneBtn setHidden:YES];
        self.communionBtn = [[UIButton alloc]init];
        
        [self.communionBtn setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        
        [self.communionBtn setHidden:YES];
        
        [self.communionBtn addTarget:self action:@selector(clickCM) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.phoneBtn];
        [self.contentView addSubview:self.communionBtn];
        
        [self addObserver:self forKeyPath:@"clickStatu" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        
    }
    return self;
}

- (void)setImage:(NSString *)image Content:(NSString *)content ID:(NSString *)Id
{
    self.Id = Id;
    
    self.icon.image = [UIImage imageNamed:image];
    
    self.icon.frame = CGRectMake(10, 5, 50, 50);
    
    self.icon.backgroundColor = [UIColor greenColor];
    
    NSRange range = [content rangeOfString:@"/"];
    
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:content];
        
        [aString addAttributes:@{NSForegroundColorAttributeName:CellUnderLineColor} range:NSMakeRange(range.location, aString.length - range.location)];
        
        self.label.attributedText = aString;
    }
    

    
    
    self.label.frame = CGRectMake(self.icon.right + 10, 0, 200, CONTENT_FONT);
    self.label.centerY = self.icon.centerY;
    [self.communionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.mas_equalTo(15);
        make.right.equalTo(self).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.equalTo(self.communionBtn.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
}

- (void)clickPhone
{
    NSLog(@"点击通话");
}

- (void)clickCM
{
    NSLog(@"点击聊天");
    
    CommunicateViewController *pushView = [[CommunicateViewController alloc]init];
    pushView.friendId = self.Id;
    [self.superview.viewController.navigationController pushViewController:pushView animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([change[@"new"] boolValue]) {
        
        [self.communionBtn setHidden:NO];
        [self.phoneBtn setHidden:NO];
    }
    else{
        
        [self.communionBtn setHidden:YES];
        [self.phoneBtn setHidden:YES];
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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"clickStatu"];
}

@end
