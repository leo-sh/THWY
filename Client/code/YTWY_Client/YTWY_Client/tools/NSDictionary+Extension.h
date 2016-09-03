//
//  NSDictionary+Extension.h
//  BXInsurenceBroker
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

- (id)getValue:(NSString *)key as:(Class)type;

- (id)getValue:(NSString *)key as:(Class)type defaultValue:(id)defaultValue;

-(NSString *)toJSONString;

@end
