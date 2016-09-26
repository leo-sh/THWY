//
//  ProclamationInfoViewController.h
//  YTWY_Server
//
//  Created by HuangYiZhe on 16/8/21.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RootVC.h"

typedef enum {
    GetAdministrationData,
    GetBusinessData
}GetMethod;

@interface ProclamationInfoViewController : UIViewController
@property NSString *proclamationId;
@property GetMethod type;
@end
