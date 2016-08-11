//
//  RecommandBussnessListVC.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecommandBussnessListVC.h"
#import "RecommandMerchantCell.h"
#import "BussnessDetailVC.h"
#import "GoodVO.h"
#import "GoodsVC.h"

@interface RecommandBussnessListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *bussnessModels;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RecommandBussnessListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"推荐商品";
    self.bussnessModels = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];

    [self initViews];
    [self getBussnessData];
}

- (void)getBussnessData{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    [[ServicesManager getAPI] getRecommendGoods:1 onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg){
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        
        for (GoodVO *model in list) {
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
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommandMerchantCell" bundle:nil]forCellReuseIdentifier:@"RecommandMerchantCell"];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bussnessModels.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommandMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommandMerchantCell" forIndexPath:indexPath];
    [cell loadDataFromMercharge:self.bussnessModels[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    BussnessDetailVC *detail = [[BussnessDetailVC alloc] init];
//    detail.merchant = self.bussnessModels[indexPath.row];
    GoodsVC *detail = [[GoodsVC alloc] init];
    detail.good = self.bussnessModels[indexPath.row];
    [self .navigationController pushViewController:detail animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
