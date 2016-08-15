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
#import "ADDetailVC.h"


@interface RecommandBussnessADVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *bussnessModels;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RecommandBussnessADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家公告";
    self.bussnessModels = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];
    
    [self initViews];
    [self getBussnessData];
    
}


- (void)getBussnessData{
    [SVProgressHUD showWithStatus:@"数据加载中..."];

    [[ServicesManager getAPI] getAds:1 onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg){
            
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        
        for (AdVO *model in list) {
            [self.bussnessModels addObject:model];
        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    }];
    
}

- (void)initViews{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, self.view.height-20-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 300;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"BussnessADCell" bundle:nil]forCellReuseIdentifier:@"BussnessADCell"];
    [self.view addSubview:self.tableView];
    
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
    ADDetailVC *detail = [[ADDetailVC alloc] init];
    detail.advo = self.bussnessModels[indexPath.row];
    [self .navigationController pushViewController:detail animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
