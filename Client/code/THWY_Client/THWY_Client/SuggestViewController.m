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
#import "ReviseBtn.h"
#import "AlertView.h"
#import "SuggestAlertView.h"
#import "BlueRedioButton.h"
#define TopViewH 70
@interface SuggestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property SuggestAlertView *alertView;
@property UITableView *tableView;
@property UISegmentedControl *segmentedControl;
@property NSMutableArray *FeedBackTypeArray;
@property NSArray *data;
@property UIView *topView;
@property UIImageView *segementBackgroundImageView;
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData:@"1"];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"建议意见";
    
    UIImage *image = [UIImage imageNamed:@"背景2"];
    
    self.view.layer.contents = (id)image.CGImage;
    
    self.FeedBackTypeArray = [NSMutableArray array];
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)getData:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"正在加载数据，请稍等······"];
    [[ServicesManager getAPI] getFeedBackTypes:^(NSString *errorMsg, NSArray *list) {
        
        for (FeedBackTypeVO *temp in list) {
            
            [self.FeedBackTypeArray addObject:temp];
        }
        
        [[ServicesManager getAPI]getFeedBackList:type onComplete:^(NSString *errorMsg, NSArray *list) {
            
            self.data = list;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            });
            
        }];
        
    }];
}

- (void)createUI
{
    
    self.topView = [[UIImageView alloc]init];
    
    self.topView.backgroundColor = [UIColor clearColor];
    
    self.topView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(TopViewH);
    }];
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"建议",@"意见"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.frame = CGRectMake(40, 15,My_ScreenW - 80 ,  40);
//    self.segmentedControl.tintColor = [UIColor clearColor];
//    
//    self.segementBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.segmentedControl.width, self.segmentedControl.height)];
//    
//    NSDictionary *titleSelectDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
//    
//    [self.segmentedControl setTitleTextAttributes:titleSelectDic forState:UIControlStateSelected];
//    
//    NSDictionary *titleDeselectDic = [NSDictionary dictionaryWithObjectsAndKeys:My_NAV_BG_Color,NSForegroundColorAttributeName, nil];
//
//    [self.segmentedControl setTitleTextAttributes:titleDeselectDic forState:UIControlStateNormal];
//
    
    self.segmentedControl.tintColor = My_NAV_BG_Color;
    [self.topView addSubview:self.segmentedControl];
    
    [self.segmentedControl addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.alpha = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.data = @[];
            [self getData:[self.FeedBackTypeArray[self.segmentedControl.selectedSegmentIndex] Id]];
        }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }];
        
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-80);
    }];
    
    UIView *view = [[UIView alloc]init];
    
    
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.8;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tableView.mas_bottom).with.offset(10);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        
    }];
    
    ReviseBtn *btn = [[ReviseBtn alloc]initWithFrame:CGRectMake(40, 15, self.view.width - 80, 40)];
    [btn setLeftImageView:@"建议意见 添加" andTitle:@"添加"];
    [btn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];

    
}

#pragma mark --tableViewDelegate与tableViewDataSource方法的实现
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
    }
    NSString *time = [NSString stringDateFromTimeInterval:[[self.data[indexPath.section] ctime] intValue] withFormat:@"YYYY-MM-dd"];
    [cell setTitle:@"" time:time content:[self.data[indexPath.section] content] width:tableView.width];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat contenHeight = [[self.data[indexPath.section] content] sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT] maxSize:CGSizeMake(tableView.width, 4000)].height;
    NSArray *cellArray = @[[NSNumber numberWithFloat:contenHeight + 52 + 8 + 10],[NSNumber numberWithFloat:tableView.width]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cellHeight" object:cellArray];
    //添加上面固定内容的高度 + 下面内容的高度 + 与下边界的距离
    return contenHeight + 52 + 8 + 10;
}

- (void)change
{
    
    NSLog(@"%@ld",self.FeedBackTypeArray);
    
    if ([ServicesManager getAPI].status != NotReachable) {
        [self getData:[self.FeedBackTypeArray[self.segmentedControl.selectedSegmentIndex] Id]];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"网络访问错误"];
    }
    
    
//    UILabel * houseLabel = [UILabel labelWithTitle:@"房源" frameX:10 Height:30];
//    houseLabel.textColor = [UIColor yellowColor];
//    NSLog(@"%f",houseLabel.width)
//    UILabel *houseLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    houseLabel.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:houseLabel];
    
}

- (void)clickAddBtn
{
    self.alertView = [[SuggestAlertView alloc]initWithFrame:CGRectMake(10, 0, self.view.width - 20, 0)];
    
    self.alertView.backgroundColor = [UIColor whiteColor];
    [self.alertView show];
    [self.alertView addLeftBtnTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submit
{
    int back;
    if (self.alertView.suggestOne.chooseStatu) {
        back = 1;
    }
    else
    {
        back = 2;
    }
    if (self.alertView.textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
    }
    else
    {
        [[ServicesManager getAPI]addFeedBack:back content:self.alertView.textView.text onComplete:^(NSString *errorMsg) {
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            }
            
        }];
    }

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
