//
//  ZYBannerView.h
//  DuoBao
//
//  Created by Ted on 15/10/17.
//  Copyright (c) 2015年 tongbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFLBBannerFooter.h"

@protocol ZYBannerViewDataSource, ZYBannerViewDelegate;

@interface YFLBBannerView : UIView

/** 是否需要循环滚动, 默认为 NO */
@property (nonatomic, assign) IBInspectable BOOL shouldLoop;

/** 是否显示footer, 默认为 NO (此属性为YES时, shouldLoop会被置为NO) */
@property (nonatomic, assign) IBInspectable BOOL showFooter;

/** 是否自动滑动, 默认为 NO */
@property (nonatomic, assign) IBInspectable BOOL autoScroll;

/** 自动滑动间隔时间(s), 默认为 3.0 */
@property (nonatomic, assign) IBInspectable NSTimeInterval scrollInterval;

/** pageControl, 可自由配置其属性 */
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@property (nonatomic, weak) IBOutlet id<ZYBannerViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<ZYBannerViewDelegate> delegate;

- (void)reloadData;

- (void)startTimer;
- (void)stopTimer;

@end

@protocol ZYBannerViewDataSource <NSObject>
@required

- (NSInteger)numberOfItemsInBanner:(YFLBBannerView *)banner;
- (UIView *)banner:(YFLBBannerView *)banner viewForItemAtIndex:(NSInteger)index;

@optional

- (NSString *)banner:(YFLBBannerView *)banner titleForFooterWithState:(ZYBannerFooterState)footerState;

@end

@protocol ZYBannerViewDelegate <NSObject>
@optional

- (void)banner:(YFLBBannerView *)banner didSelectItemAtIndex:(NSInteger)index;
- (void)bannerFooterDidTrigger:(YFLBBannerView *)banner;

@end
