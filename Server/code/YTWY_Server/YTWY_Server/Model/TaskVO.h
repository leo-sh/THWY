//
//  TaskVO.h
//  YTWY_Server
//
//  Created by Mr.S on 16/8/7.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    All = 1,
    New,
    Processing,
    Done,
} TaskType;

@interface TaskVO : NSObject

@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * house_id;
@property (nonatomic , copy) NSString              * st;
@property (nonatomic , copy) NSString              * st_0_time;
@property (nonatomic , copy) NSString              * st_2_time;
@property (nonatomic , copy) NSString              * st_3_time;
@property (nonatomic , copy) NSString              * call_person;
@property (nonatomic , copy) NSString              * call_phone;
@property (nonatomic , copy) NSString              * owner_public;
@property (nonatomic , copy) NSString              * estate_name;
@property (nonatomic , copy) NSString              * block;
@property (nonatomic , copy) NSString              * unit;
@property (nonatomic , copy) NSString              * layer;
@property (nonatomic , copy) NSString              * mph;
@property (nonatomic , copy) NSString              * classes_str;
@property NSArray                                  * repair_classes;

-(TaskVO* )initWithJSON:(NSDictionary *)JSON;

@end
