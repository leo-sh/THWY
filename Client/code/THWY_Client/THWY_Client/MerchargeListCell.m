//
//  MerchargeListCell.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MerchargeListCell.h"

@interface MerchargeListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *merchargeName;
@property (weak, nonatomic) IBOutlet UILabel *merchargeType;
@property (weak, nonatomic) IBOutlet UILabel *merchargePhone;
@property (weak, nonatomic) IBOutlet UILabel *merchargeAddr;

@end

@implementation MerchargeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.icon.layer.cornerRadius = self.height*0.8/2.0;
    self.icon.clipsToBounds = YES;
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)loadDataFromMercharge:(MerchantVO *)merchant{

    [self.icon sd_setImageWithURL:[NSURL URLWithString:merchant.pic] placeholderImage:[UIImage imageNamed:@"头像1"]];
    self.icon.layer.cornerRadius = self.height*0.8/2.0;
    self.icon.clipsToBounds = YES;
    self.merchargeName.text = merchant.business_name;
    self.merchargeType.text = merchant.business_type_name;
    self.merchargeAddr.text = merchant.addr;
    self.merchargePhone.text = merchant.telephone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
