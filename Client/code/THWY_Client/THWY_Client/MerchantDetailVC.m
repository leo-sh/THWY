//
//  MerchantDetailVC.m
//  THWY_Client
//
//  Created by wei on 16/8/11.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MerchantDetailVC.h"
#import "RecommandMerchantCell.h"
#import "GoodsVC.h"

@interface MerchantDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

//@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation MerchantDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家详情";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]];
    [self initViews];

}

- (void)initViews{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, self.view.height-84)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 100/667.0*My_ScreenH;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommandMerchantCell" bundle:nil]forCellReuseIdentifier:@"RecommandMerchantCell"];
    [self.view addSubview:self.tableView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.merchant.products.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommandMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommandMerchantCell" forIndexPath:indexPath];
    [cell loadDataFromMercharge:self.merchant.products[indexPath.row]];
    cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsVC *goodvc = [[GoodsVC alloc] init];
    goodvc.good = self.merchant.products[indexPath.row];
    [self.navigationController pushViewController:goodvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

@end
