//
//  MyFriendTableViewCell.h
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendTableViewCell : UITableViewCell
@property BOOL clickStatu;
- (void)setImage:(NSString *)image Content:(NSString *)content ID:(NSString *)Id;
@end
