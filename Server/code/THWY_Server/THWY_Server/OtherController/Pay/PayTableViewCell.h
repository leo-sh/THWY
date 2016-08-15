//
//  PayTableViewCell.h
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeeVO;
@interface PayTableViewCell : UITableViewCell
- (void)giveData:(FeeVO *)FeeVO;
- (void)updateFrame:(CGSize)cellsize;
@end
