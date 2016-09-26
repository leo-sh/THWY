//
//  NSArray+Extension.m
//  snowonline
//
//  Created by 王贺 on 16/6/2.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray(Extension)
-(NSString *)toJSONString{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
