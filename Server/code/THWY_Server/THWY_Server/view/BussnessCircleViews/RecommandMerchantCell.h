//
//  RecommandMerchantCell.h
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodVO.h"

@interface RecommandMerchantCell : UITableViewCell

- (void)loadDataFromMercharge:(GoodVO *)merchant;

@end
