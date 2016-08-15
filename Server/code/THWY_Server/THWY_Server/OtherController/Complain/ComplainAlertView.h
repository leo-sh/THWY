//
//  ComplainAlertView.h
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertView.h"
#import "BlueRedioButton.h"
#import "AlertButton.h"
@interface ComplainAlertView : AlertView
@property AlertButton *typeBtn;
@property UITextField *personTf;
@property UITextField *phoneTf;
@property NSMutableArray *houseSourceBtnArray;
- (void)updateWithComplainVo:(UserVO *)UserVO;
@end
