//
//  RepairStatistisVC.m
//  THWY_Server
//
//  Created by wei on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatistisVC.h"
#import "RepairStatisticsButton.h"
#import "RepairStatisticsCell.h"
#import "RepairStatisticsFinishCell.h"
#import "AlertEstateTableView.h"
#import "RepairStatisticVO.h"

@interface RepairStatistisVC ()<AlertEstateTableViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) RepairStatisticsButton *unitBtn;
@property (strong, nonatomic) AlertEstateTableView  *alertView;
//全部楼盘
@property (strong, nonatomic) NSMutableArray *estatesArray;
//btn名字
@property (strong, nonatomic) NSArray *labelNames;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;
@property (strong, nonatomic) UITableView *tableView3;

@property (assign, nonatomic) NSInteger estateId;
@property (assign, nonatomic) NSInteger switchFlag;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation RepairStatistisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"报修统计";
    self.switchFlag = 1;
    self.estateId = -1;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]];
    [self getEstatesData];
    [self initViews];
    [self getStatisticsData:nil];
    self.dataArray = [NSMutableArray array];
}

//获取楼盘数据
- (void)getEstatesData{
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    [My_ServicesManager getEstates:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            for (EstateVO * estate in list) {
                [self.estatesArray addObject:estate];
            }
            [self initAlertView];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)getStatisticsData:(NSString *)estateId{
    //获取统计数据
    [self.dataArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    switch (self.switchFlag) {
        case 1:{
            [My_ServicesManager getRepairStatistic:estateId onComplete:^(NSString *errorMsg, NSArray *list) {
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }else{
                    
                    for (RepairStatisticVO *model in list) {
                        [self.dataArray addObject:model];
                    }
                    [self.tableView1 reloadData];
                    [SVProgressHUD dismiss];
                }
            }];
        
            break;
        }
        case 2:{
            [My_ServicesManager getPublicRepairStatistic:estateId onComplete:^(NSString *errorMsg, NSArray *list) {
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }else{
                    
                    for (RepairStatisticVO *model in list) {
                        [self.dataArray addObject:model];
                    }
                    [self.tableView2 reloadData];
                    [SVProgressHUD dismiss];
                }
            }];
            break;
        }
        case 3:{
            
            break;
        }
        default:
            break;
    }
    
}

- (void)initViews{
    
    CGFloat topMargin = 10/667.0*My_ScreenH;
    CGFloat leftMargin = 6/667.0*My_ScreenH;
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, My_ScreenW-2*leftMargin, My_ScreenH * 0.3)];
    [self.bgView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
    [self.view addSubview:self.bgView];
    
    self.unitBtn = [[RepairStatisticsButton alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, self.bgView.height*0.3)];
    [self.unitBtn setLeftImageView:@"repairStatistics_展开箭头" andTitle:@"全部小区"];
    [self.unitBtn addTarget:self action:@selector(showUnitsAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.unitBtn];
    
    self.labelNames = @[@"业主报修", @"公共报修", @"维修统计"];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftMargin, self.bgView.height+topMargin, self.bgView.width, My_ScreenH-64-3*topMargin)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = self.bgView.backgroundColor;
    self.scrollView.layer.borderWidth = 1;
    self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.scrollView];

    
    CGFloat btnWidth = self.bgView.width/3.0-2*leftMargin;
    for(int i = 0; i<3; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin + (leftMargin*2+btnWidth)*i, self.unitBtn.height+leftMargin, btnWidth, btnWidth)];
        
        btn.tag = 310 + i;
        [btn addTarget:self action:@selector(switchStatus:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"repairStatistics_按下"] forState:UIControlStateNormal];
        }
        [self.bgView addSubview:btn];
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/5.0, 0, btn.width*0.6, btn.height*0.6)];
        btnImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"repairStatistics_%@",self.labelNames[i]]];
        btnImage.userInteractionEnabled = YES;
        [btn addSubview:btnImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.width*0.75, 0, 0)];
        label.text = self.labelNames[i];
        [label sizeToFit];
        label.centerX = btnImage.centerX;
        label.font = FontSize(CONTENT_FONT);
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.scrollView.width*i, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorColor = [UIColor lightGrayColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        tableView.rowHeight = 50.0<self.scrollView.height/5.0?self.scrollView.height/5.0:50.0;
        [tableView registerClass:[RepairStatisticsCell class] forCellReuseIdentifier:@"RepairStatisticsCell"];
        [tableView registerClass:[RepairStatisticsFinishCell class] forCellReuseIdentifier:@"RepairStatisticsFinishCell"];
        
        switch (i) {
            case 0:
                self.tableView1 = tableView;
                [self.scrollView addSubview:self.tableView1];
                break;
            case 1:
                self.tableView2 = tableView;
                [self.scrollView addSubview:self.tableView2];
                break;
            case 2:
                self.tableView3 = tableView;
                [self.scrollView addSubview:self.tableView3];
                break;
            default:
                break;
        }
        
    }

}

//切换状态
- (void)switchStatus:(UIButton *)btn{
    
    self.switchFlag = btn.tag - 310+1;
    [self getStatisticsData:nil];
    
}

- (void)initAlertView{
 
    self.alertView = [[AlertEstateTableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-40, (44.0*self.estatesArray.count + 45.0/667*My_ScreenH*2)<(My_ScreenH-84)?(44.0*self.estatesArray.count + 45.0/667*My_ScreenH*2):(My_ScreenH-84))];
    self.alertView.type = AlertChooseEstateType;
    self.alertView.data = self.estatesArray;
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

    if (index == -1) {
        [self getStatisticsData:nil];
    }else{
        [self getStatisticsData:[self.estatesArray[index] Id]];
    }
    
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.switchFlag) {
        case 0:
            return 5;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 0;
            break;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.switchFlag == 2) {
        
    }else{
        
        if (indexPath.row == 4) {
            RepairStatisticsFinishCell *cell = (RepairStatisticsFinishCell *)[tableView dequeueReusableCellWithIdentifier:@"RepairStatisticsFinishCell" forIndexPath:indexPath];
            [cell loadDataFromRepairVO:nil];
            return cell;
        }else{
            RepairStatisticsCell *cell = (RepairStatisticsCell *)[tableView dequeueReusableCellWithIdentifier:@"RepairStatisticsCell" forIndexPath:indexPath];
            if (self.dataArray.count>indexPath.row) {
                [cell loadDataFromRepairVO:self.dataArray[indexPath.row]];
            }
            return cell;
        }
        
    }
    
    return nil;
}

@end
