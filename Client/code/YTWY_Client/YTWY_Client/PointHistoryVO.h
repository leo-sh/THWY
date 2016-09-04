//
//  PointHistoryVO.h
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointHistoryVO : NSObject

@property (nonatomic , copy) NSString              * points;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * the_type;
@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * ts;
@property (nonatomic , copy) NSString              * the_type_name;
@property (nonatomic , copy) NSString              * owner_id;
@property (nonatomic , copy) NSString              * pk;

-(PointHistoryVO* )initWithJSON:(NSDictionary *)JSON;

@end
