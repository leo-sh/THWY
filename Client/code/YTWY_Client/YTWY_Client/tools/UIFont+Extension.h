//
//  UIFont+Extension.h
//  BXInsurenceBroker
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Extension)
/**
 *  根据不同的设置返回不同的字体
 */
+ (UIFont *)fontWithDeviceName:(NSString*)fontName size:(CGFloat)fontSize;
/**
 *  导航栏根据不同的设置返回不同的字体
 */
+ (UIFont *)navItemFontWithDevice:(CGFloat)fontSize;

@end
