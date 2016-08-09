//
//  AlertTableView.h
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/8.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    GetComplainType,
    GetYear,
    GetPayStatu
} GetDataMethod;
@protocol AlertTabelViewDelegate <NSObject>

- (void)returnData:(NSArray *)array;

@end
@interface AlertTableView2 : UITableView
@property (weak,nonatomic) id<AlertTabelViewDelegate>AlertDelegate;
- (instancetype)initWithNumber:(GetDataMethod)method;
- (void)hide;
- (void)showCenter;
- (void)showOriginY:(CGFloat)y OriginX:(CGFloat)x;
@end
