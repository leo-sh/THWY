//
//  SuggestViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "SuggestViewController.h"
#import "Masonry/Masonry.h"
#import "ProclamationTableViewCell.h"
@interface SuggestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property UISegmentedControl *segmentedControl;
@property NSArray *data;
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createUI];

    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"建议意见";
    
    UIImage *image = [UIImage imageNamed:@"背景2"];
    
    self.view.layer.contents = (id)image.CGImage;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)getData
{
    
}

- (void)createUI
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,My_ScreenW, 70)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"建议",@"意见"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.frame = CGRectMake(40, 15,My_ScreenW - 80 ,  40);
    self.segmentedControl.tintColor = My_NAV_BG_Color;
    self.segmentedControl.opaque = NO;
    [topView addSubview:self.segmentedControl];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.alpha = 1;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.clipsToBounds = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom).with.offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 15,My_ScreenW ,  40)];
    [self.view addSubview:view];
    
}

#pragma mark --tableViewDelegate与tableViewDataSource方法的实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProclamationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[ProclamationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    [cell setTitle:@"1" time:@"1" content:@"1" width:tableView.width];
//    if (indexPath.row < ) {
//        <#statements#>
//    }
//    cell.preservesSuperviewLayoutMargins = NO;
//    cell.separatorInset = UIEdgeInsetsZero;
//    cell.layoutMargins = UIEdgeInsetsZero;
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
    
    CGFloat contenHeight = [[self.data[indexPath.section] content] sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT] maxSize:CGSizeMake(tableView.width, 4000)].height;
    //添加上面固定内容的高度 + 下面内容的高度 + 与下边界的距离
    return contenHeight + 52 + 8 + 10;
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
