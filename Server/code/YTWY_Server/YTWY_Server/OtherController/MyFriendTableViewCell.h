//
//  MyFriendTableViewCell.h
//  YTWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendTableViewCell : UITableViewCell
@property BOOL clickStatu;
@property NSString *phoneNumber;
@property NSString *friendName;
- (void)setImage:(NSString *)image Content:(NSString *)content ID:(NSString *)Id;
@end
