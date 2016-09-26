//
//  MerchargeListCell.h
//  YTWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantVO.h"

@interface MerchargeListCell : UITableViewCell

- (void)loadDataFromMercharge:(MerchantVO *)merchant;

@end
