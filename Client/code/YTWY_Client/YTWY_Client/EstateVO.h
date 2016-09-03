//
//  EstateVO.h
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstateVO : NSObject

@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * estate_name;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * wyf_date;

-(EstateVO* )initWithJSON:(NSDictionary *)JSON;
@end
