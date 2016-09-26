//
//  NSDate+Extension.h
//  Weibo11
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/// 日期描述字符串
///
/// 格式如下
///     -   刚刚(一分钟内)
///     -   X分钟前(一小时内)
///     -   X小时前(当天)
///     -   昨天 HH:mm(昨天)
///     -   MM-dd HH:mm(一年内)
///     -   yyyy-MM-dd HH:mm(更早期)
- (NSString *)ff_dateDescription;

@end
