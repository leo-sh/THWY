//
//  WRAlertView.h
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    Edit,
    Add
}
GetMethod;
@interface WRAlertView : UIView
@property GetMethod method;
- (void)addLeftBtnTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
