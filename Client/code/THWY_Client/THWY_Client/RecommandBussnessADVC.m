//
//  RecommandBussnessADVC.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecommandBussnessADVC.h"
#import "AdVO.h"
#import "BussnessADCell.h"
#import "ProclamationInfoViewController.h"


@interface RecommandBussnessADVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *bussnessModels;
@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) int page;

@end

@implementation RecommandBussnessADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家公告";
    self.bussnessModels = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];
    
    [self initViews];
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    [self getBussnessData];
}


- (void)getBussnessData{
    [self.bussnessModels removeAllObjects];
    self.page = 0;
    [[ServicesManager getAPI] getAds:self.page onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{

            for (AdVO *model in list) {
                [self.bussnessModels addObject:model];
            }
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)initViews{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.view.width, self.view.height-10-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 300/667.0*My_ScreenH;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"BussnessADCell" bundle:nil]forCellReuseIdentifier:@"BussnessADCell"];
    [self initRefreshView];
    [self.view addSubview:self.tableView];
    
}

//设置上拉下拉刷新
- (void)initRefreshView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getBussnessData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
}

- (void)loadMoreData{
    [[ServicesManager getAPI] getAds:++self.page onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
            
            if (self.page != 0) {
                self.page--;
            }
            
        }else{
            
            if (list && list.count == 0 && self.page != 0) {
                self.page--;
            }
            for (AdVO *model in list) {
                [self.bussnessModels addObject:model];
            }
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
        
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bussnessModels.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BussnessADCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BussnessADCell" forIndexPath:indexPath];
    [cell loadDataFromMercharge:self.bussnessModels[indexPath.row]];
    cell.vc = self;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AdVO* adVO = self.bussnessModels[indexPath.row];
    ProclamationInfoViewController *detail = [[ProclamationInfoViewController alloc] init];
    detail.proclamationId = adVO.Id;
    detail.type = 1;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
