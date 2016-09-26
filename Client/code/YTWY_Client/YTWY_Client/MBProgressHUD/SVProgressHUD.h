//
//  MBManager.h
//  snowonline
//
//  Created by 史秀泽 on 16/6/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface SVProgressHUD : NSObject

@property UILabel* loadingLabel;

+(instancetype)shareMBManager;

+(void)hudHideWithSuccess:(NSString*)title;
+(void)showErrorWithStatus:(NSString*)title;
+(void)showSubTitle:(NSString*)subTitle;
+(void)dismiss;

+(void)showWithStatus:(NSString*)title;
@end
