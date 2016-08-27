//
//  MyDatePickerView.h
//  THWY_Client
//
//  Created by wei on 16/8/20.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewProtocol.h"

@interface MyDatePickerView : UIControl

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (strong, nonatomic) UIColor *fontColor;

@property (strong, nonatomic) UIFont *font;

@property (assign, nonatomic) CGFloat rowHeight;

@property (strong, nonatomic) NSDate *selectedDate;

@property (weak, nonatomic) id<PickerViewProtocol> delegate;

@end
