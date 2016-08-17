//
//  adVO.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdVO:NSObject

@property (nonatomic , copy) NSString *Id;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *ctime;

-(AdVO* )initWithJSON:(NSDictionary *)JSON;

@end
