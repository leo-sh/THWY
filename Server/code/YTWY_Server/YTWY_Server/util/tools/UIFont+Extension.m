//
//  UIFont+Extension.m
//  BXInsurenceBroker
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)
+ (UIFont *)fontWithDeviceName:(NSString*)fontName size:(CGFloat)fontSize {
    if (My_ScreenW > 375) {
        fontSize = fontSize + 1;
    }else{
        fontSize = fontSize;
    }
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    return font;
}

+ (UIFont *)navItemFontWithDevice:(CGFloat)fontSize {
    if (My_ScreenW > 375) {
        fontSize = fontSize + 2;
    }else if (My_ScreenW == 375){
        fontSize = fontSize + 1;
    }else if (My_ScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

@end
