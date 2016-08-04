//
//  AlertTableView.m
//  THWY_Client
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertTableView.h"

@implementation AlertTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self initTableHeaderView];
    }
    return self;
    
}

- (void)initTableHeaderView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30.0/667*My_ScreenH)];
    headerView.backgroundColor = self.backgroundColor;
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, headerView.height-10, headerView.height-10)];
    confirm setBackgroundImage:[UIImage imageNamed:] forState:<#(UIControlState)#>
    
}

@end
