//
//  FoodVO.h
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodVO : NSObject

@property (nonatomic , copy) NSString              * business_id;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * business_name;
@property (nonatomic , copy) NSString              * goods_intro;
@property (nonatomic , copy) NSString              * goods_name;
@property (nonatomic , copy) NSString              * tj;
@property (nonatomic , copy) NSString              * telephone;
@property (nonatomic , copy) NSString              * addr;

-(GoodVO* )initWithJSON:(NSDictionary *)JSON;
@end
