//
//  IntegralDetailCell.h
//  THWY_Client
//
//  Created by Mr.S on 16/8/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "IntegralRootCell.h"

@interface IntegralDetailCell : IntegralRootCell

-(void)fillCell:(BOOL)isBottom andTitle:(NSString *)title andValue:(NSString *)value;

@end
