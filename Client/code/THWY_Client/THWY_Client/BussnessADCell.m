//
//  BussnessADCell.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BussnessADCell.h"
#import "ADDetailVC.h"

@interface BussnessADCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (strong, nonatomic) AdVO *advo;
@end

@implementation BussnessADCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnclick)];
    [self.desc addGestureRecognizer:tap];
    
}

- (void)tapOnclick{
    
    ADDetailVC *detail = [[ADDetailVC alloc] init];
    detail.advo = self.advo;
    [self.vc.navigationController pushViewController:detail animated:YES];

}

- (void)loadDataFromMercharge:(AdVO *)merchant{
    
    self.title.text = merchant.title;
    self.advo = merchant;

    self.timeLabel.text = [NSString stringDateFromTimeInterval:[merchant.ctime integerValue] withFormat:@"YYYY-MM-dd HH:mm"];
    self.desc.text = merchant.content;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
