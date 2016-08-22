//
//  RootVC.h
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYKeyboardUtil.h"
@interface RootVC : UIViewController

@property ZYKeyboardUtil* keyboardUtil;

/**
 *  网络状态改变
 *
 *  @param noti 当前网络状态
 */
-(void)netWorkChanged:(NSNotification*)noti;

-(void)showLogin:(BOOL)animated;

@end
