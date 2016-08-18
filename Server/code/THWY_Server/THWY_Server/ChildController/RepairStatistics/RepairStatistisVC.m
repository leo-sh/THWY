//
//  RepairStatistisVC.m
//  THWY_Server
//
//  Created by wei on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatistisVC.h"
#import "RepairStatisticsButton.h"
#import "AlertEstateTableView.h"

@interface RepairStatistisVC ()<AlertEstateTableViewDelegate>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) RepairStatisticsButton *unitBtn;
@property (strong, nonatomic) AlertEstateTableView  *alertView;

@property (strong, nonatomic) NSMutableArray *unitArray;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation RepairStatistisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    [self getData];
    [self initViews];
}

- (void)getData{
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    [My_ServicesManager getEstates:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            for (EstateVO * estate in list) {
                [self.unitArray addObject:estate];
            }
            [self initAlertView];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)initViews{
    
    NSInteger topMargin = 10/667.0*My_ScreenH;
    NSInteger leftMargin = 8/667.0*My_ScreenH;
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, My_ScreenW-2*leftMargin, My_ScreenH * 0.3)];
    [self.bgView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
    [self.view addSubview:self.bgView];
    
    self.unitBtn = [[RepairStatisticsButton alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, self.bgView.height*0.28)];
    [self.unitBtn setLeftImageView:@"repairStatistics_展开箭头" andTitle:@"全部小区"];
    [self.unitBtn addTarget:self action:@selector(showUnitsAlert) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initAlertView{
 
    self.alertView = [[AlertEstateTableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-40, (44.0*self.unitArray.count + 40.0/667*My_ScreenH)<(My_ScreenH-84)?(44.0*self.unitArray.count + 40.0/667*My_ScreenH):(My_ScreenH-84)) style:UITableViewStylePlain];
    self.alertView.type = AlertEstateType;
    self.alertView.data = self.unitArray;
//    self.alertView.selectedIndex = self.estateIndex;
    self.alertView.AlertDelegate = self;

}

//弹出框
- (void)showUnitsAlert{
    [self.alertView showInWindow];
}

#pragma mark - AlertEstateTableViewDelegate
- (void)commit:(NSInteger)index{

}

@end
