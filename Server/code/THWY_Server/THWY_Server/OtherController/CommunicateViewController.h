//
//  CommunicateViewController.h
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RootVC.h"

@interface CommunicateViewController : RootVC
@property NSString *Id;
@property NSString *s_photo;
@property NSString *s_admin_id;
+ (instancetype)shareCommunicateViewController;
@end
