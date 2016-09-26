//
//  AlertEstateTableView.h
//  YTWY_Client
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertEstateTableViewDelegate <NSObject>

typedef NS_ENUM(NSInteger, AlertType){
    AlertEstateType = 1,
    AlertBlockType,
    AlertUnitType,
    AlertLayerType
};

- (void)commit:(NSInteger)index;

@end

@interface AlertEstateTableView : UIView

@property (weak, nonatomic) id<AlertEstateTableViewDelegate> AlertDelegate;

@property (assign, nonatomic) AlertType type;

@property (strong, nonatomic) NSMutableArray *data;

@property (assign, nonatomic) NSInteger selectedIndex;

- (void)initViews;

@end
