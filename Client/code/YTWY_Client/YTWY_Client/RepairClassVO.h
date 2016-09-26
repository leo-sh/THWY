//
//  RepairClassVO.h
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairClassVO : NSObject

@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * pid;
@property (nonatomic , copy) NSString              * class_path;
@property (nonatomic , copy) NSString              * class_name;
@property (nonatomic , copy) NSString              * class_price;
@property (nonatomic , copy) NSString              * st;
@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * task_time;
@property NSMutableArray                           * child;
@property (nonatomic , copy) NSString              * px;

-(RepairClassVO* )initWithJSON:(NSDictionary *)JSON;
@end
