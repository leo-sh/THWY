//
//  DropMenuTableView.h
//  YTWY_Server
//
//  Created by wei on 16/8/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropTableMenuDelegate <NSObject>

- (void)itemSelected:(NSInteger)index;

- (void)dropMenuHidden;

@end

@interface DropMenuTableView : UIView

@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIColor *textColor;
@property (assign, nonatomic) CGFloat fontSize;

@property (strong, nonatomic) id<DropTableMenuDelegate> dropDelegate;

- (void)refreshUpdateIcon:(BOOL)haveUpdate;

- (instancetype)initWithWidth:(CGFloat)width itemHeight:(CGFloat)itemHeight itemNames:(NSArray *)items ItemImages:(NSArray *)images;

@end
