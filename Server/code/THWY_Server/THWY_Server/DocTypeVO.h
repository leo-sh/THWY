//
//  DocTypeVO.h
//  THWY_Server
//
//  Created by Mr.S on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocTypeVO : NSObject

@property NSString              * Id;
@property NSString              * name;

-(DocTypeVO* )initWithJSON:(NSDictionary *)JSON;
@end
