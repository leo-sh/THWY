//
//  ComplaintTypeVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplaintTypeVO : NSObject

@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * complaint_type;

-(ComplaintTypeVO* )initWithJSON:(NSDictionary *)JSON;

@end
