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
#import "ReviseBtn.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property NSArray *data;
@property AlertButton *chooseYearBtn;
@property AlertButton *chooseStatuBtn;
@property int page;
@property int year;
@property int statu;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"缴费台账";
    UIImage *backgroundImage = [UIImage imageNamed:@"背景2"];
    self.view.layer.contents = (id) backgroundImage.CGImage;
    self.page = 0;
    self.year = 0;
    self.statu = All;
    //    [self.navigationController pushViewController:[[PayInfoViewController alloc]init] animated:YES];
}

- (void)getData
{
    [SVProgressHUD showWithStatus:@"正在加载数据，请稍等······"];

    [[ServicesManager getAPI]getFees:self.page year:self.year feeState:self.statu onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            });
            
        }
        else
        {
            self.data = list;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [SVProgressHUD dismiss];

            });
        }
        
    }];
}

- (void)createUI
{
    //创建搜索视图
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,40)];
    
    self.chooseYearBtn = [[AlertButton alloc]initWithFrame:CGRectMake(5, 5, self.view.width * 0.35 , 30)];
    
    [self.chooseYearBtn setTitle:@"选择年份" forState:UIControlStateNormal];
    
    NSArray *data = @[@"选择年份",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019"];
    
    [self.chooseYearBtn setGetDataMethod:GetYear OriginY:self.chooseYearBtn.bottom - 10 + 66 showCentenX:self.chooseYearBtn.centerX withData:data];
    
    [searchView addSubview:self.chooseYearBtn];
    
    self.chooseStatuBtn = [[AlertButton alloc]initWithFrame:CGRectMake(self.chooseYearBtn.right + 5, 5, self.view.width * 0.35, 30)];
    
    data = @[@"选择状态",@"未缴",@"未缴齐",@"已缴齐",@"已退款"];
    
    [self.chooseStatuBtn setGetDataMethod:GetPayStatu OriginY:self.chooseYearBtn.bottom - 10 + 66 showCentenX:self.chooseStatuBtn.centerX withData:data];
    self.chooseStatuBtn.postID = @"-1";
    [self.chooseStatuBtn setTitle:@"选择状态" forState:UIControlStateNormal];
    
    [searchView addSubview:self.chooseStatuBtn];
    
    UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(self.chooseStatuBtn.right + 15, 5, self.view.width - self.chooseStatuBtn.right - 25, 30)];
    
    search.backgroundColor = My_NAV_BG_Color;
    search.layer.cornerRadius = 5;
    search.clipsToBounds = YES;
    search.titleLabel.font = [UIFont systemFontOfSize:CONTENT_FONT - 1];
    [search setTitle:@"查询" forState:UIControlStateNormal];
    [search addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:search];
    
    [self.view addSubview:searchView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, searchView.bottom, self.view.width - 10, self.view.height - searchView.height) style:UITableViewStyleGrouped];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
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
    cell.backgroundColor = WhiteAlphaColor;
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

- (void)clickSearchBtn
{
    self.year = [self.chooseYearBtn.postID intValue];
    self.statu = [self.chooseStatuBtn.postID intValue];
    [self getData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != self.data.count - 1) {
        return 2;
    }
    else
    {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != self.data.count - 1) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"彩条"]];
        return imageView;
    }
    else
    {
        return nil;
    }
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
