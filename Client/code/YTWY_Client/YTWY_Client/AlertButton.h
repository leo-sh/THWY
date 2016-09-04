//
//  AlertButton.h
//  YTWY_Client
//
//  Created by HuangYiZhe on 16/8/7.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertTableView2.h"
@interface AlertButton : UIButton
@property BOOL openStatu;
@property AlertTableView2 *alertView;
@property NSString *postID;
- (void)setGetDataMethod:(GetDataMethod)method OriginY:(CGFloat)y showCentenX:(CGFloat)x withData:(NSArray *)data;
@end
