//
//  GoodsVC.m
//  THWY_Client
//
//  Created by wei on 16/8/8.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "GoodsVC.h"
#import "RecommandMerchantCell.h"

@interface GoodsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bussnessModels;
@property (assign, nonatomic) int page;

@end

@implementation GoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.page = 0;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]];
    [self initViews];
    [self getBussnessData];
    
}

- (void)initViews{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, self.view.height-84)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 100;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommandMerchantCell" bundle:nil]forCellReuseIdentifier:@"RecommandMerchantCell"];
//    [self initRefreshView];
    [self.view addSubview:self.tableView];

    
}

- (void)getBussnessData{
    
    [SVProgressHUD showWithStatus:@"正在加载数据，请稍等......"];
    self.bussnessModels = [NSMutableArray array];
    [My_ServicesManager getAGood:self.good.Id onComplete:^(NSString *errorMsg, GoodVO *merchant) {

        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            [self.bussnessModels addObject:merchant];
        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bussnessModels.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommandMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommandMerchantCell" forIndexPath:indexPath];
    [cell loadDataFromMercharge:self.bussnessModels[indexPath.row]];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    BussnessDetailVC *detail = [[BussnessDetailVC alloc] init];
    //    detail.merchant = self.bussnessModels[indexPath.row];
    
}


@end
