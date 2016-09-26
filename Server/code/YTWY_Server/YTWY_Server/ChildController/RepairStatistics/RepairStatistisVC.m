//
//  RepairStatistisVC.m
//  YTWY_Server
//
//  Created by wei on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatistisVC.h"
#import "RepairStatisticsButton.h"
#import "RepairStatisticsCell.h"
#import "RepairStatisticsFinishCell.h"
#import "RepairStatisticsDataCell.h"
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

//各小区数据
@property (strong, nonatomic) NSMutableArray *dataArray;
//全部数据
@property (strong, nonatomic) NSMutableArray *allDataArray;


@end

@implementation RepairStatistisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"报修统计";
    self.switchFlag = 1;
    self.estateId = -1;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]];
//    [self getEstatesData];
    [self initViews];
    [self getEstatesData];
    [self getStatisticsData:nil];
    self.dataArray = [NSMutableArray array];
    self.allDataArray = [NSMutableArray array];
    self.estatesArray = [NSMutableArray array];
}

//获取楼盘数据
- (void)getEstatesData{
    [self.estatesArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    [My_ServicesManager getEstates:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            for (EstateVO * estate in list) {
                [self.estatesArray addObject:estate];
            }
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)getStatisticsData:(NSString *)estateId{
    //获取统计数据
    
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    switch (self.switchFlag) {
        case 1:{
            //业主报修统计
            [My_ServicesManager getRepairStatistic:estateId onComplete:^(NSString *errorMsg, NSArray *list) {
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }else{
                    if (estateId == nil) {
                        [self.allDataArray removeAllObjects];
                        for (int i = 0; i < 6; i++) {
                            RepairStatisticVO *repairStatsticVO = [[RepairStatisticVO alloc] init];
                            NSInteger sum = 0;
                            for (NSArray *array in list) {
                                RepairStatisticVO *repair = array[i];
                                repairStatsticVO.estate_id = [repair estate_id];
                                repairStatsticVO.estate_name = [repair estate_name];
                                repairStatsticVO.status_name = [repair status_name];
                                sum += [repair.sum integerValue];
                            }
                            repairStatsticVO.sum = [NSString stringWithFormat:@"%ld", sum];
                            [self.allDataArray addObject:repairStatsticVO];
                        }
                    }else{
                        [self.dataArray removeAllObjects];
                        [self.dataArray addObjectsFromArray:list[0]];
                    }
                    [self.tableView1 reloadData];
                    [SVProgressHUD dismiss];
                }
            }];
        
            break;
        }
        case 2:{
            //公共报修统计
            [My_ServicesManager getPublicRepairStatistic:estateId onComplete:^(NSString *errorMsg, NSArray *list) {
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }else{
                    
                    if (estateId == nil) {
                        [self.allDataArray removeAllObjects];
                        for (int i = 0; i < 4; i++) {
                            RepairStatisticVO *repairStatsticVO = [[RepairStatisticVO alloc] init];
                            NSInteger sum = 0;
                            for (NSArray *array in list) {
                                RepairStatisticVO *repair = array[i];
                                repairStatsticVO.estate_id = [repair estate_id];
                                repairStatsticVO.estate_name = [repair estate_name];
                                repairStatsticVO.status_name = [repair status_name];
                                sum += [repair.sum integerValue];
                            }
                            repairStatsticVO.sum = [NSString stringWithFormat:@"%ld", sum];
                            [self.allDataArray addObject:repairStatsticVO];
                        }
                    }else{
                        [self.dataArray removeAllObjects];
//                        for (id obj in list) {
//                            [self.dataArray addObject:obj];
//                        }
                        [self.dataArray addObjectsFromArray:list[0]];
                    }
                    [self.tableView2 reloadData];
                    [SVProgressHUD dismiss];
                }
            }];
            break;
        }
        case 3:{
            //维修统计
            [My_ServicesManager getStaffRepairStatistics:estateId onComplete:^(NSString *errorMsg, NSArray *list) {
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }else{
                    
                    if (estateId == nil) {
                        [self.allDataArray removeAllObjects];
                        [self.allDataArray addObjectsFromArray:list];
                    }else{
                        [self.dataArray removeAllObjects];
                        [self.dataArray addObjectsFromArray:list];
                    }
                    [self.tableView3 reloadData];
                    [SVProgressHUD dismiss];
                }

            }];
            [SVProgressHUD dismiss];
            break;
        }
        default:
            break;
    }
    
}

- (void)initViews{
    
    CGFloat topMargin = 10/667.0*My_ScreenH;
    CGFloat leftMargin = 6/667.0*My_ScreenH;
    CGFloat bgViewWidth = My_ScreenW-2*leftMargin;
    CGFloat btnWidth = bgViewWidth/3.0-2*leftMargin;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 2*topMargin, bgViewWidth, (btnWidth+2*leftMargin)*10.0/7)];
    [self.bgView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    [self.view addSubview:self.bgView];
    
    self.unitBtn = [[RepairStatisticsButton alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, self.bgView.height*0.3)];
    [self.unitBtn setLeftImageView:@"repairStatistics_展开箭头" andTitle:@"全部小区"];
    [self.unitBtn addTarget:self action:@selector(initAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.unitBtn];
    
    self.labelNames = @[@"业主报修", @"公共报修", @"维修统计"];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftMargin, self.bgView.height+3*topMargin, self.bgView.width, My_ScreenH-64-4*topMargin-self.bgView.height)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
//    self.scrollView.layer.borderWidth = 1;
//    self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.scrollView];

    
    for(int i = 0; i<3; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin + (leftMargin*2+btnWidth)*i, self.unitBtn.height+leftMargin, btnWidth, btnWidth)];
        
        btn.tag = 310 + i;
        [btn addTarget:self action:@selector(switchStatus:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"records_按下"] forState:UIControlStateNormal];
        }
        [self.bgView addSubview:btn];
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/5.0, 0, btn.width*0.6, btn.height*0.6)];
        btnImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"repairStatistics_%@",self.labelNames[i]]];
        btnImage.userInteractionEnabled = NO;
        [btn addSubview:btnImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.width*0.75, 0, 0)];
        label.text = self.labelNames[i];
        [label sizeToFit];
        label.centerX = btnImage.centerX;
        label.font = FontSize(CONTENT_FONT+1);
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.scrollView.width*i, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.bounces = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 50.0<self.scrollView.height/6.0?self.scrollView.height/6.0:50.0;
        
        switch (i) {
            case 0:
                self.tableView1 = tableView;
                [self.tableView1 registerClass:[RepairStatisticsCell class] forCellReuseIdentifier:@"RepairStatisticsCell"];
                [self.tableView1 registerClass:[RepairStatisticsFinishCell class] forCellReuseIdentifier:@"RepairStatisticsFinishCell"];
                [self.scrollView addSubview:self.tableView1];
                break;
            case 1:
                self.tableView2 = tableView;
                [self.tableView2 registerClass:[RepairStatisticsCell class] forCellReuseIdentifier:@"RepairStatisticsCell"];
                [self.tableView2 registerClass:[RepairStatisticsFinishCell class] forCellReuseIdentifier:@"RepairStatisticsFinishCell"];
                [self.scrollView addSubview:self.tableView2];
                break;
            case 2:
                self.tableView3 = tableView;
                [self.tableView3 registerClass:[RepairStatisticsDataCell class] forCellReuseIdentifier:@"RepairStatisticsDataCell"];
                [self.scrollView addSubview:self.tableView3];
                self.tableView3.rowHeight = 24*4+16*3+10;
                break;
            default:
                break;
        }
        
    }

}

//切换状态
- (void)switchStatus:(UIButton *)btn{
    
    UIButton *oldBtn = [self.view viewWithTag:309 +self.switchFlag];
    [oldBtn setImage:nil forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"records_按下"] forState:UIControlStateNormal];
    self.switchFlag = btn.tag - 310+1;
//    self.estateId = -1;
//    [self.unitBtn setTitle:@"全部小区" forState:UIControlStateNormal];
    if (self.estateId == -1) {
        [self getStatisticsData:nil];
    }else{
        [self getStatisticsData:[self.estatesArray[self.estateId] estate_id]];
    }
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.width*(self.switchFlag-1), 0);
    
}

//弹出框
- (void)initAlertView{
 
    self.alertView = [[AlertEstateTableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-40, (44.0*self.estatesArray.count + 45.0+50.0)<(My_ScreenH-84)?(44.0*self.estatesArray.count + 50+45.0):(My_ScreenH-84))];
    self.alertView.type = AlertChooseEstateType;
    self.alertView.data = self.estatesArray;
    self.alertView.AlertDelegate = self;
    [self.alertView initViews];
    self.alertView.selectedIndex = self.estateId;
    [self.alertView showInWindow];

}

#pragma mark - AlertEstateTableViewDelegate
- (void)commit:(NSInteger)index{

    if (index == -1) {
        [self.unitBtn setTitle:@"全部小区" forState:UIControlStateNormal];
        self.estateId = -1;
        [self getStatisticsData:nil];
    }else{
        [self.unitBtn setTitle:[self.estatesArray[index] estate_name] forState:UIControlStateNormal];
        self.estateId = index;
        [self getStatisticsData:[self.estatesArray[index] estate_id]];
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView1]) {
        return 5;
    }else if ([tableView isEqual:self.tableView2]){
        return 4;
    }else{
        if (self.estateId == -1) {
            return self.allDataArray.count;
        }else{
            return self.dataArray.count;
        }
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView3]) {
        RepairStatisticsDataCell *cell = (RepairStatisticsDataCell *)[tableView dequeueReusableCellWithIdentifier:@"RepairStatisticsDataCell" forIndexPath:indexPath];
        if (self.estateId == -1) {
            [cell loadDataFromModel:self.allDataArray[indexPath.row]];
        }else{
            [cell loadDataFromModel:self.dataArray[indexPath.row]];
        }
        return cell;
    }else{
        if (indexPath.row == 4) {
            RepairStatisticsFinishCell *cell = (RepairStatisticsFinishCell *)[tableView dequeueReusableCellWithIdentifier:@"RepairStatisticsFinishCell" forIndexPath:indexPath];
            if (self.estateId == -1){
                if (self.allDataArray.count>indexPath.row) {
                    NSString *finishString = @"";
                    NSString *backString = @"";
                    float finish = 0.0;
                    float back = 0.0;
                    
                    NSInteger finishSum = [[self.allDataArray[3] sum] integerValue]+[[self.allDataArray[4] sum] integerValue] + [[self.allDataArray[0] sum] integerValue] + [[self.allDataArray[2] sum] integerValue];
                    NSInteger backSum = [[self.allDataArray[3] sum] integerValue]+[[self.allDataArray[4] sum] integerValue] + [[self.allDataArray[0] sum] integerValue] + [[self.allDataArray[2] sum] integerValue];
                    if (finishSum == 0) {
                        finishString = @"0%";
                    }else{
                        
                        finish = ([[self.allDataArray[3] sum] floatValue]+[[self.allDataArray[4] sum] integerValue])/finishSum;
                        if ([self floatEqualToZero:finish]) {
                            finishString = @"0%";
                        }else{
                            finishString = [NSString stringWithFormat:@"%.2f%%",finish*100];
                        }

                    }
                    
                    if (backSum == 0) {
                        backString = @"0%";
                    }else{
                        back = [[self.allDataArray[4] sum] floatValue] / backSum;
                        if ([self floatEqualToZero:back]) {
                            backString = @"0%";
                        }else{
                            backString = [NSString stringWithFormat:@"%.2f%%",back*100];
                        }
                    
                    }
                    
                    [cell loadDataFromArray:@[finishString,backString]];
                }
            }else{
                if (self.dataArray.count>indexPath.row) {
                    NSString *finishString = @"";
                    NSString *backString = @"";
                    float finish = 0.0;
                    float back = 0.0;
                    NSInteger finishSum = [[self.dataArray[3] sum] integerValue]+[[self.dataArray[4] sum] integerValue] + [[self.dataArray[0] sum] integerValue] + [[self.dataArray[2] sum] integerValue];
                    NSInteger backSum = ([[self.dataArray[3] sum] integerValue]+[[self.dataArray[4] sum] integerValue] + [[self.dataArray[0] sum] integerValue] + [[self.dataArray[2] sum] integerValue]);
                    
                    
                    if (finishSum == 0) {
                        finishString = @"0%";
                    }else{
                        
                        finish = ([[self.dataArray[3] sum] floatValue]+[[self.dataArray[4] sum] integerValue])/finishSum;
                        if ([self floatEqualToZero:finish]) {
                            finishString = @"0%";
                        }else{
                            finishString = [NSString stringWithFormat:@"%.2f%%",finish*100];
                        }
                        
                    }
                    
                    if (backSum == 0) {
                        backString = @"0%";
                    }else{
                        back = [[self.dataArray[4] sum] floatValue] / backSum;
                        if ([self floatEqualToZero:back]) {
                            backString = @"0%";
                        }else{
                            backString = [NSString stringWithFormat:@"%.2f%%",back*100];
                        }
                        
                    }

                    [cell loadDataFromArray:@[finishString,backString]];
                }
            }
            return cell;
        }else{
            RepairStatisticsCell *cell = (RepairStatisticsCell *)[tableView dequeueReusableCellWithIdentifier:@"RepairStatisticsCell" forIndexPath:indexPath];
            cell.flag = self.switchFlag;
            cell.index = indexPath.row;
            NSString *sumString = @"";

            if (self.estateId == -1){
                if (self.allDataArray.count>indexPath.row) {
                    if (indexPath.row == 0) {
                        sumString = [self.allDataArray[0] sum];
                    }else if (indexPath.row == 3){
                        
                        if (self.allDataArray.count == 4) {
                            NSInteger finishSum = [[self.allDataArray[0] sum] intValue]+[[self.allDataArray[2] sum] intValue] + [[self.allDataArray[3] sum] intValue];
                            float finish = 0.0;
                            
                            if (finishSum == 0) {
                                sumString = @"0%";
                            }else{
                                finish = [[self.allDataArray[3] sum] floatValue]/finishSum;
                                if ([self floatEqualToZero:finish]) {
                                    sumString = @"0%";
                                }else{
                                    sumString = [NSString stringWithFormat:@"%0.2f%%",finish*100];
                                }
                            }
                        }else{
                            sumString = [self.allDataArray[indexPath.row+1] sum];
                        }
                        
                    }else{
                        sumString = [self.allDataArray[indexPath.row+1] sum];
                    }
                }
            }else{
                if (self.dataArray.count>indexPath.row) {
                    if (indexPath.row == 0) {
                        sumString = [self.dataArray[0] sum];
                    }else if(indexPath.row == 3){
                        if (self.dataArray.count == 4) {
                            NSInteger finishSum = ([[self.dataArray[0] sum] intValue]+[[self.dataArray[2] sum] intValue] + [[self.dataArray[3] sum] intValue]);
                            float finish = 0.0;
                            if (finishSum == 0) {
                                sumString = @"0%";
                            }else{
                                finish = [[self.dataArray[3] sum] floatValue]/finishSum;
                                if ([self floatEqualToZero:finish]) {
                                    sumString = @"0%";
                                }else{
                                    sumString = [NSString stringWithFormat:@"%0.2f%%",finish*100];
                                }
                            }
                        }else{
                            sumString = [self.dataArray[indexPath.row+1] sum];
                        }
                    }else{
                        sumString = [self.dataArray[indexPath.row+1] sum];
                    }
                }
            }
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.contentView.height-0.5, cell.contentView.width, 0.5)];
            line.backgroundColor = My_LineColor;
            [cell.contentView addSubview:line];
            [cell.contentView bringSubviewToFront:line];
            [cell loadDataFromSum:sumString];
            return cell;
        }
        
    }
    return nil;
}

- (BOOL)floatEqualToZero:(float)x{
    if (( x >= -EPSINON ) && ( x <= EPSINON ))
    {
        return YES;
    }else{
        return NO;
    }
}

@end
