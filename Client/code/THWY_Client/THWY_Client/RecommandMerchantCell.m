//
//  RecommandMerchantCell.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecommandMerchantCell.h"

@interface RecommandMerchantCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *addr;

@end

@implementation RecommandMerchantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.icon.layer.cornerRadius = self.icon.width/2.0;
    self.icon.clipsToBounds = YES;
}

- (void)loadDataFromMercharge:(GoodVO *)merchant{
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:merchant.pic] placeholderImage:[UIImage imageNamed:@"图大小"]];
    self.name.text = merchant.business_name;
//    self.addr.text = merchant.addr;
    self.desc.text = merchant.goods_intro;
    
    [[ServicesManager getAPI] getAMerchant:merchant.business_id onComplete:^(NSString *errorMsg, MerchantVO *merchant) {
        self.addr.text = merchant.addr;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
