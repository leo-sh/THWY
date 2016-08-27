//
//  NSDate+Extension.m
//  Weibo11
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)ff_dateDescription {
    
    // 1. 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 2. 判断是否是今天
    if ([calendar isDateInToday:self]) {
        
        NSInteger interval = ABS((NSInteger)[self timeIntervalSinceNow]);

        if (interval < 60) {
            return @"刚刚";
        }
        interval /= 60;
        if (interval < 60) {
            return [NSString stringWithFormat:@"%zd 分钟前", interval];
        }
        
        return [NSString stringWithFormat:@"%zd 小时前", interval / 60];
    }
    
    // 3. 昨天
    NSMutableString *formatString = [NSMutableString stringWithString:@" HH:mm"];
    if ([calendar isDateInYesterday:self]) {
        [formatString insertString:@"昨天" atIndex:0];
    } else {
        [formatString insertString:@"MM-dd" atIndex:0];
        
        // 4. 是否当年
        NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];

        if (components.year != 0) {
            [formatString insertString:@"yyyy-" atIndex:0];
        }
    }

    // 5. 转换格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    fmt.dateFormat = formatString;
    
    return [fmt stringFromDate:self];
}

+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay{
    
    NSUInteger interval1 = [oneDay timeIntervalSince1970];
    NSUInteger interval2 = [anotherDay timeIntervalSince1970];
    int result = 0;
    if (interval1 > interval2) {
        result = 1;
    }else if(interval1 < interval2){
        result = -1;
    }
    
    NSLog(@"date1 : %@, date2 : %@ result:%d", oneDay, anotherDay, result);
    return result;
    
}

@end
