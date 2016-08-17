//
//  AlertTableView.h
//  THWY_Server
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertTableViewDelegate <NSObject>

- (void)confirm:(NSMutableArray *)reslult flag:(NSInteger)flag;

@end

@interface AlertTableView : UIView

@property (assign, nonatomic) NSInteger flag;

@property (strong, nonatomic) NSArray *data;

@property (weak, nonatomic) id<AlertTableViewDelegate> AlertDelegate;


- (void)initViews;

@end
