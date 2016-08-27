//
//  MyTimerPickerView.h
//  THWY_Client
//
//  Created by wei on 16/8/21.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewProtocol.h"

@interface MyTimerPickerView : UIControl

@property (strong, nonatomic) UIColor *fontColor;

@property (strong, nonatomic) UIFont *font;

@property (assign, nonatomic) CGFloat rowHeight;

@property (strong, nonatomic) NSDate *selectedDate;

@property (assign, nonatomic) NSInteger hour;
@property (assign, nonatomic) NSInteger minute;

@property (weak, nonatomic) id<PickerViewProtocol> delegate;

@end
