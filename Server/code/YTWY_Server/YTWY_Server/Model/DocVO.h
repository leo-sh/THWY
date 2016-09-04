//
//  DocVO.h
//  YTWY_Server
//
//  Created by Mr.S on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocVO : NSObject

@property NSString              * Id;
@property NSString              * doc_type_id;
@property NSString              * admin_id;
@property NSString              * title;
@property NSString              * content;
@property NSString              * ctime;
@property NSString              * open_to;
@property NSString              * do_copy;
@property NSString              * real_name;
@property BOOL                  belong;
@property BOOL                  is_public;

-(DocVO* )initWithJSON:(NSDictionary *)JSON;

@end
