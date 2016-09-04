//
//  BlueRedioButton.h
//  YTWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseVO;
@interface BlueRedioButton : UIButton
@property BOOL chooseStatu;
@property HouseVO *house;
- (void)initDefaultImageName:(NSString *)defaultImageName choosedImageName:(NSString *)choosedImageName title:(NSString *)title;
- (void)initDefaultImageName:(NSString *)defaultImageName choosedImageName:(NSString *)choosedImageName;
- (void)setChoosed;
- (void)click;
@end
