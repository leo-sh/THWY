//
//  ComplainAlertView.h
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertView.h"
@class UserVO;
@interface ComplainAlertView : AlertView
- (void)updateWithComplainVo:(UserVO *)UserVO;
@end
