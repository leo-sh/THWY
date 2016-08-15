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
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.rowHeight = 110/667.0*My_ScreenH;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommandMerchantCell" bundle:nil] forCellReuseIdentifier:@"RecommandMerchantCell"];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bussnessModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommandMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommandMerchantCell" forIndexPath:indexPath];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [(RecommandMerchantCell *)cell loadDataFromMercharge:self.bussnessModels[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsVC *detail = [[GoodsVC alloc] init];
    detail.good = self.bussnessModels[indexPath.row];
    [self .navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
