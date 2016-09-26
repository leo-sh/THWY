//
//  COTableViewCell.h
//  YTWY_Server
//
//  Created by HuangYiZhe on 16/8/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COTableViewCell : UITableViewCell
@property NSInteger section;
- (void)setIcon:(NSString *)icon Content:(NSString *)content;
@end
