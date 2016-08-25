//
//  AlerView.h
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/24.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    Edit,
    Add
}GetMethod;
@interface AlerView : UIView
@property GetMethod method;
- (void)setUser:(NSString *)user IP:(NSString *)ip;
@end
