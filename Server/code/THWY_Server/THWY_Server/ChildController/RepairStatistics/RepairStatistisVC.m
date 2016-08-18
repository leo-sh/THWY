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
//全部楼盘
@property (strong, nonatomic) NSMutableArray *unitArray;
//btn名字
@property (strong, nonatomic) NSArray *labelNames;


@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation RepairStatistisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectedIndex = -1;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    [self getEstatesData];
    [self initViews];
}

//获取楼盘数据
- (void)getEstatesData{
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

- (void)gettatisticsData{
    //
//    [My_ServicesManager getRepairStatistic: onComplete:^(NSString *errorMsg, NSArray *list) {
//        
//    }];
    
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
    [self.bgView addSubview:self.unitBtn];
    
    self.labelNames = @[@"业主报修", @"公共报修", @"维修统计"];
    for(int i = 0; i<3; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.width*(1.5/4.0)*i, 0, self.bgView.width/4.0, self.bgView.height)];
        
        btn.tag = 310 + i;
        [btn addTarget:self action:@selector(switchStatus:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"repairStatistics_按下"] forState:UIControlStateNormal];
        }
        [self.bgView addSubview:btn];
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/8.0, 0, btn.width*3/4.0, btn.height*3/4.0)];
        btnImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"repairStatistics_%@",self.labelNames[i]]];
        [btn addSubview:btnImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btnImage.height, 0, 0)];
        label.text = self.labelNames[i];
        [label sizeToFit];
        label.centerX = btnImage.centerX;
        label.font = FontSize(CONTENT_FONT);
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];
        
    }

}

//切换状态
- (void)switchStatus:(UIButton *)btn{
    
    
    
}

- (void)initAlertView{
 
    self.alertView = [[AlertEstateTableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-40, (44.0*self.unitArray.count + 45.0/667*My_ScreenH*2)<(My_ScreenH-84)?(44.0*self.unitArray.count + 45.0/667*My_ScreenH*2):(My_ScreenH-84))];
    self.alertView.type = AlertChooseEstateType;
    self.alertView.data = self.unitArray;
    self.alertView.selectedIndex = -1;
    self.alertView.AlertDelegate = self;
    [self.alertView initViews];

}

//弹出框
- (void)showUnitsAlert{
    [self.alertView showInWindow];
}

#pragma mark - AlertEstateTableViewDelegate
- (void)commit:(NSInteger)index{

    self.selectedIndex = index;
    
    
}

@end
