//
//  ProclamationInfoViewController.h
//  YTWY_Client
//
//  Created by HuangYiZhe on 16/8/14.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OwnerType = 0,
    BusinessType,
} InfoCellType;

@interface ProclamationInfoViewController : UIViewController
@property NSString *proclamationId;
@property InfoCellType type;
@end
