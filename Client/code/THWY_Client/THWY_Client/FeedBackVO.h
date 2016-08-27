//
//  FeedBackVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackVO : NSObject

@property (nonatomic , copy) NSString              * category;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * answer;
@property (nonatomic , copy) NSString              * answer_time;
@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * oid;
@property BOOL is_read;

-(FeedBackVO* )initWithJSON:(NSDictionary *)JSON;

@end
