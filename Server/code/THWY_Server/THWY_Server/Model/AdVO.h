//
//  AdVO.h
//  THWY_Server
//
//  Created by Mr.S on 16/8/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileVO.h"

@interface AdVO : NSObject

@property NSString              * Id;
@property NSString              * title;
@property NSString              * content;
@property NSString              * estate_ids;
@property NSString              * ctime;
@property NSString              * admin_view;
@property NSMutableArray<FileVO *> * files;
@property BOOL is_tuijian;

-(AdVO* )initWithJSON:(NSDictionary *)JSON;

@end
