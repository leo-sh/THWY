//
//  UIScreen+Extension.m
//  Weibo11
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

+ (CGSize)ff_screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)ff_isRetina {
    return [UIScreen ff_scale] >= 2;
}

+ (CGFloat)ff_scale {
    return [UIScreen mainScreen].scale;
}

@end
