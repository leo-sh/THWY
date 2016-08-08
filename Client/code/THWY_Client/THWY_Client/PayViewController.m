//
//  PayViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PayViewController.h"
#import "ServicesManager.h"
#import "Masonry.h"
#import "PayTableViewCell.h"
#import "PayInfoViewController.h"
#import "AlertButton.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property NSArray *data;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"缴费台账";
    //    [self.navigationController pushViewController:[[PayInfoViewController alloc]init] animated:YES];
}

- (void)getData
{    [SVProgressHUD showWithStatus:@"正在加载数据，请稍等······"];

    [[ServicesManager getAPI]getFees:1 year:0 feeState:All onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            NSLog(@"%@",errorMsg);
        }
        self.data = list;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];

        });
        
    }];
}

- (void)createUI
{
    //创建搜索视图
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,40)];
    
    AlertButton *chooseYearBtn = [[AlertButton alloc]initWithFrame:CGRectMake(5, 5, self.view.width * 0.35 , 30)];
    
    [chooseYearBtn setTitle:@"选择年份" forState:UIControlStateNormal];
    
    [searchView addSubview:chooseYearBtn];
    
    AlertButton *chooseStatuBtn = [[AlertButton alloc]initWithFrame:CGRectMake(chooseYearBtn.right + 5, 5, self.view.width * 0.35, 30)];
    
    [chooseStatuBtn setTitle:@"选择状态" forState:UIControlStateNormal];
    
    [searchView addSubview:chooseStatuBtn];
    
    UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(chooseStatuBtn.right + 5, 5, self.view.width - chooseStatuBtn.right - 10, 30)];
    
    search.backgroundColor = My_NAV_BG_Color;
    
    [search setTitle:@"查询" forState:UIControlStateNormal];
    
    [searchView addSubview:search];
    
    [self.view addSubview:searchView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchView.bottom, self.view.width, self.view.height - searchView.height) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    self.tableView.rowHeight = 200;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[PayTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    FeeVO *item = self.data[indexPath.row];
    [cell giveData:item];
    [cell updateFrame:CGSizeMake(tableView.width, 100)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayInfoViewController *pushView = [[PayInfoViewController alloc]init];
    
    pushView.feeId = [self.data[indexPath.row] Id];
    
    [self.navigationController pushViewController:pushView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
