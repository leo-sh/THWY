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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-[merchant.ctime intValue]];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:-[merchant.ctime intValue]/1000];
    self.timeLabel.text = [formatter stringFromDate:date];
    [[ServicesManager getAPI] getAnAd:merchant.Id onComplete:^(NSString *errorMsg, AdVO *ad) {
        self.desc.text = ad.title;
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
