//
//  MyTimerPickerView.h
//  THWY_Client
//
//  Created by wei on 16/8/21.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTimerPickerView : UIPickerView

@property (strong, nonatomic) UIColor *fontColor;

@property (strong, nonatomic) UIFont *font;

@property (assign, nonatomic) CGFloat rowHeight;

@property (strong, nonatomic) NSDate *selectedDate;

@end
