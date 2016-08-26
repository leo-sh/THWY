//
//  ProclamationViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ProclamationViewController.h"
#import "ProclamationTableViewCell.h"
#import "ServicesManager.h"
#import "Masonry/Masonry.h"
#import "ProclamationInfoViewController.h"
@interface ProclamationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray *data;
@property CGFloat topHeight;
@property UITableView *tableView;
@property int pageNumber;
@property NSDictionary *rowAndHeight;
@end

@implementation ProclamationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"业主公告";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"公告背景"]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.data = [NSMutableArray array];
    self.pageNumber = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"giveHeight" object:nil];
}

- (void)getData
{    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];

    [[ServicesManager getAPI] getNotes:self.pageNumber onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            });
            self.pageNumber --;
        }
        
        else if (list.count == 0 && errorMsg == nil) {
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
        }
        else
        {
            NSLog(@"%@",list);
            
            [self.data addObjectsFromArray:list];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    }];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.data) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.pageNumber = 0;
            [self.data removeAllObjects];
            [self getData];
        }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.pageNumber++;
            [self getData];
        }];

    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-10);
    }];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProclamationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ProclamationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        self.topHeight = CGRectGetMaxY(cell.time.frame);
    }
    NSString *time = [NSString stringDateFromTimeInterval:[[self.data[indexPath.section] ctime] intValue] withFormat:@"YYYY-MM-dd HH:mm"];
    cell.row = indexPath.section;
    [cell setTitle:[self.data[indexPath.section] title]  time:time content:[self.data[indexPath.section] content] width:tableView.width];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];

    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.data) {
        
        NSString *rowS = [self.rowAndHeight allKeys][0];
        
        if (indexPath.section == [rowS integerValue] && [self.rowAndHeight[rowS] integerValue] != 0) {
            
            return [self.rowAndHeight[rowS] integerValue];
        }
        else
        {
        //添加上面固定内容的高度 + 下面内容的高度 + 与下边界的距离
            return 200;
        }
    }
    else
    {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProclamationInfoViewController *pushView = [[ProclamationInfoViewController alloc]init];
    pushView.proclamationId = [self.data[indexPath.section] Id];
    
    [self.navigationController pushViewController:pushView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)change:(NSNotification *)notification
{
//    self.changeHeightStatu = YES;
//    self.cellHeight = [[notification.object firstObject] floatValue];
    self.rowAndHeight = notification.object;
    [self.tableView reloadData];
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
