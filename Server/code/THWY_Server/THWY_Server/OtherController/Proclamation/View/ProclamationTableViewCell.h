//
//  ProclamationTableViewCell.h
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProclamationTableViewCell : UITableViewCell
@property UILabel *title;
@property UILabel *time;
@property UILabel *content;
@property NSInteger row;
- (void)setTitle:(NSString *)title time:(NSString *)time content:(NSString *)content width:(CGFloat)width;
@end
