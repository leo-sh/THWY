//
//  BlueRedioButton.h
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueRedioButton : UIButton
@property BOOL chooseStatu;

- (void)initDefaultImageName:(NSString *)defaultImageName choosedImageName:(NSString *)choosedImageName title:(NSString *)title;
- (void)setChoosed;
- (void)click;
@end
