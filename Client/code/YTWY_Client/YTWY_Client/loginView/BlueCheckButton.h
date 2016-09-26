//
//  BlueCheckButton.h
//  YTWY_Server
//
//  Created by HuangYiZhe on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BlueCheckButton : UIButton
@property BOOL chooseStatu;

- (instancetype)initDefaultImageName:(NSString *)defaultImageName choosedImageName:(NSString *)choosedImageName title:(NSString *)title;

- (void)click;
@end
