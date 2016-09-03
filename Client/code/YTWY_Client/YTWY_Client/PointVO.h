//
//  PointVO.h
//  YTWY_Client
//
//  Created by Mr.S on 16/8/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointVO : NSObject

@property (nonatomic , copy) NSString              * k;
@property (nonatomic , copy) NSString              * s;
@property (nonatomic , copy) NSString              * sub_total;


-(PointVO* )initWithJSON:(NSDictionary *)JSON;
@end
