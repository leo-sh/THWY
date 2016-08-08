//
//  ComplainAlertView.h
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertView.h"
#import "BlueRedioButton.h"
@class UserVO;
@interface ComplainAlertView : AlertView
@property BlueRedioButton *houseSourceBtn;
- (void)updateWithComplainVo:(UserVO *)UserVO;
@end
