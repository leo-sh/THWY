//
//  MerchantTypeTableView.h
//  YTWY_Client
//
//  Created by wei on 16/8/15.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantVO.h"

@protocol MerchantTypeTableViewDelegate <NSObject>

- (void)itemSelected:(NSInteger)index;

- (void)dropMenuHidden;

@end

@interface MerchantTypeTableView : UIView

@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIColor *textColor;
@property (assign, nonatomic) CGFloat fontSize;

@property (strong, nonatomic) id<MerchantTypeTableViewDelegate> dropDelegate;

- (instancetype)initWithWidth:(CGFloat)width itemHeight:(CGFloat)itemHeight itemNames:(NSArray<MerchantTypeVO *> *)items;


@end
