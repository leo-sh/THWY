//
//  SuggestTableViewCell.h
//  YTWY_Client
//
//  Created by HuangYiZhe on 16/8/16.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestTableViewCell : UITableViewCell
@property UILabel *time;
@property UILabel *content;
@property int section;
- (void)setTime:(NSString *)time content:(NSString *)content width:(CGFloat)width;
@end
