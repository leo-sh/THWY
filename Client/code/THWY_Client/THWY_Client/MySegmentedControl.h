//
//  MySegmentedControl.h
//  THWY_Client
//
//  Created by wei on 16/8/12.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentDelegate <NSObject>

- (void)segmentSelectIndex:(NSInteger)index;

@end

@interface MySegmentedControl : UISegmentedControl

@property (weak, nonatomic) id<SegmentDelegate> delegate;

@end
