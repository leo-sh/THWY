//
//  BussnessListVC.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BussnessListVC.h"
#import "MerchantVO.h"
#import "MerchargeListCell.h"
#import "BussnessDetailVC.h"

@interface BussnessListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *bussnessModels;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *btn_select;
@property (strong, nonatomic) UITextField *textFiled_mercharName;

@end

@implementation BussnessListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"社区商家";
    self.bussnessModels = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];
    
    [self initViews];
    [self getBussnessData];
}

- (void)getBussnessData{
    
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    [[ServicesManager getAPI] getMerchants:1 name:nil onComplete:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg){
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        
        for (MerchantVO *model in list) {
            [self.bussnessModels addObject:model];
        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    }];
    
}

- (void)initViews{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, self.view.height-84)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 100;
//    self.tableView.bounces = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MerchargeListCell" bundle:nil]forCellReuseIdentifier:@"MerchargeListCell"];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bussnessModels.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MerchargeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MerchargeListCell" forIndexPath:indexPath];
    [cell loadDataFromMercharge:self.bussnessModels[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BussnessDetailVC *detail = [[BussnessDetailVC alloc] init];
    detail.merchant = self.bussnessModels[indexPath.row];
    [self .navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
