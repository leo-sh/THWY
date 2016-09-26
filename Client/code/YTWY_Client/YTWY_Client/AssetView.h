//
//  AssetView.h
//  YTWY_Client
//
//  Created by Mr.S on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetView : UIView

+(AssetView *)showInVC:(UIViewController *)vc onComplete:(void (^)(UIImage* image))onComplete;

@end
