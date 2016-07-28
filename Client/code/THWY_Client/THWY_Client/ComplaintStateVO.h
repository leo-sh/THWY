//
//  ComplaintStateVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplaintStateVO : NSObject

@property (nonatomic , copy) NSString              * st;
@property (nonatomic , copy) NSString              * name;

-(ComplaintStateVO* )initWithJSON:(NSDictionary *)JSON;

@end
