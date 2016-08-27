//
//  PickerViewProtocol.h
//  THWY_Client
//
//  Created by wei on 16/8/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PickerViewType){
    DatePickerType = 1,
    TimePickerType
};

@protocol PickerViewProtocol <NSObject>

- (void)scrollEnded:(NSDictionary *)data pickerViewType:(PickerViewType)type;

@end
