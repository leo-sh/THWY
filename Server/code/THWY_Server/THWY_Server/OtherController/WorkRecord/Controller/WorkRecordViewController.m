//
//  WorkRecordViewController.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/23.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WorkRecordViewController.h"

#import "Masonry.h"
#import "ProclamationTableViewCell.h"
#import "ProclamationInfoViewController.h"
#import "ReviseBtn.h"
#import "AddBtn.h"
#import "WRTableViewCell.h"
#import "RunSliderLabel.h"
#define TopViewH 60
@interface WorkRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property UISegmentedControl *segmentedControl;
@property NSMutableArray *data;
@property UIView *topView;
@property UIImageView *segementBackgroundImageView;
@property GetMethod method;
@property int page;
@property NSMutableArray *clickStatuA;
@property NSDictionary *rowAndHeight;
@property BOOL refreshBtnClickStatu;
@property int public;
@property int belong;
@end

@implementation WorkRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"工作日志";
    
    UIImage *image = [UIImage imageNamed:@"背景2"];
    
    self.view.layer.contents = (id)image.CGImage;
    
    self.data = [NSMutableArray array];
    self.clickStatuA = [NSMutableArray array];
    self.method = GetAdministrationData;
    self.page = 0;
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)getData
{
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
//    [[ServicesManager getAPI]getDocTypes:^(NSString *errorMsg, NSArray *list) {
//        NSLog(@"12313");
//    }];
    if (!self.refreshBtnClickStatu) {
        self.public = 2;
        self.belong = 0;
    }
    else
    {
        self.public = 1;
        self.belong = 1;
    }
    if (self.method == GetAdministrationData) {
        

        
        [[ServicesManager getAPI]getDocs:self.page docTypeId:@"1" public:self.public belong:self.belong onComplete:^(NSString *errorMsg, NSArray *list) {
            
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_header endRefreshing];
                });
                self.page --;
            }
            else if (list.count == 0 && errorMsg == nil) {
                [self.tableView.mj_footer endRefreshing];
                [SVProgressHUD dismiss];
            }
            
            else
            {
                [self.data addObjectsFromArray:list];
                for (int i = 0; i < list.count; i ++) {
                    [self.clickStatuA addObject:[NSNumber numberWithBool:NO]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                    [SVProgressHUD dismiss];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_header endRefreshing];
                });
            }
            
        }];
    }
    
    else
    {
        [[ServicesManager getAPI]getDocs:0 docTypeId:@"2" public:self.public belong:self.belong onComplete:^(NSString *errorMsg, NSArray *list) {
            
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_header endRefreshing];
                });
                self.page --;
            }
            else if (list.count == 0 && errorMsg == nil) {
                [self.tableView.mj_footer endRefreshing];
                [SVProgressHUD dismiss];
            }
            else
            {
                [self.data addObjectsFromArray:list];

                for (int i = 0; i < list.count; i ++) {
                    [self.clickStatuA addObject:[NSNumber numberWithBool:NO]];
                }                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                    [SVProgressHUD dismiss];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_header endRefreshing];
                });
            }
        }];
    }
    
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
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"工作日志",@"心得笔记"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.frame = CGRectMake(40, 15,My_ScreenW - 100 ,  40);
    self.segmentedControl.center = CGPointMake(My_ScreenW/2, self.segmentedControl.center.y);
    self.segmentedControl.layer.cornerRadius = 10;
    self.segmentedControl.clipsToBounds = YES;
    self.segmentedControl.layer.borderWidth = 1;
    self.segmentedControl.layer.borderColor = My_NAV_BG_Color.CGColor;
    self.segmentedControl.tintColor = My_NAV_BG_Color;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:My_NAV_BG_Color,NSForegroundColorAttributeName,FontSize(CONTENT_FONT + 2),NSFontAttributeName ,nil];
    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [self.topView addSubview:self.segmentedControl];
    
    [self.segmentedControl addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];
    
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.segmentedControl.y, self.segmentedControl.height, self.segmentedControl.height)];
    [refreshBtn setImage:[UIImage imageNamed:@"icon_work_diary_switch"] forState:UIControlStateNormal];
    refreshBtn.centerX = self.segmentedControl.centerX;
    refreshBtn.layer.cornerRadius = self.segmentedControl.height/2;
    [refreshBtn addTarget:self action:@selector(clickRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:refreshBtn];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.alpha = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.data removeAllObjects];
        [self.clickStatuA removeAllObjects];
        self.page = 0;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self getData];
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(0);
        
        
        UIView *view = [[UIView alloc]init];
        
        view.backgroundColor = WhiteAlphaColor;
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.tableView.mas_bottom).with.offset(-70);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            
        }];
        
        AddBtn *btn = [[AddBtn alloc]initWithFrame:CGRectMake(40, 15, self.view.width - 80, 40)];
        [btn setLeftImageView:@"记录" andTitle:@"记录"];
        [btn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];

    }];
    
    
}

#pragma mark --tableViewDelegate与tableViewDataSource方法的实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.clickStatuA[section] boolValue]) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.data[indexPath.section] content];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = WhiteAlphaColor;

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 15, 15)];
    
    CGFloat top = 10;
    CGFloat height = 20;
    
    CGFloat btnW = 70;
//    CGFloat btnH = 20;
    CGFloat btnL = 10;
    
    CGFloat labelL = imageView.right + 10;
    CGFloat labelW  = tableView.width - (btnW + btnL) * 2 - imageView.right - 10;
    
    RunSliderLabel *label = [[RunSliderLabel alloc]initWithFrame:CGRectMake(labelL, top, labelW, height)];
    [label setTitle:[self.data[section] title]];
    
    [view addSubview:label];
    
    imageView.image = [UIImage imageNamed:@"属性-公开"];
//    imageView.backgroundColor = [UIColor whiteColor];
    [view addSubview:imageView];
    
    view.tag = 300 + section;
    
    
    if (!self.refreshBtnClickStatu) {
        ReviseBtn *revise = [[ReviseBtn alloc]initWithFrame:CGRectMake(0, top, btnW, CONTENT_FONT)];
        
        revise.centerY = imageView.centerY;
        
        revise.x = label.right + btnL;
        
        [revise setLeftImageView:@"b修改" andTitle:@"修改"];
        
        revise.titleLabel.font = FontSize(CONTENT_FONT);
        
        [view addSubview:revise];
        
        ReviseBtn *delete = [[ReviseBtn alloc]initWithFrame:CGRectMake(0, top, btnW, CONTENT_FONT)];
        
        delete.x = revise.right + btnL;
        
        delete.centerY = imageView.centerY;
        
        [delete setLeftImageView:@"b删除" andTitle:@"删除"];
        
        delete.titleLabel.font = FontSize(CONTENT_FONT);
        
        [view addSubview:delete];

    }
    else
    {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, top, view.width - label.right - btnL, CONTENT_FONT)];
        nameLabel.x = label.right +btnL;
        nameLabel.centerY = imageView.centerY;
        
        if ([[self.data[section] real_name] isEqualToString:@"0"]) {
            NSLog(@"%@",[self.data[section] real_name]);
            nameLabel.text = @"false";
        }
        else
        {
            nameLabel.text = [self.data[section] real_name];

        }
        nameLabel.font = FontSize(CONTENT_FONT);
        
        [view addSubview:nameLabel];

    }
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelL, label.bottom + 10, tableView.width, Content_Ip_Font)];
    
    NSString *time = [self.data[section] ctime];
    
    timeLabel.text = [NSString stringDateFromTimeInterval:[time integerValue] withFormat:@"YYYY-MM-dd hh:ss"];
    timeLabel.font = FontSize(Content_Ip_Font);
    [view addSubview:timeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    
    [view addGestureRecognizer:tap];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.01;
}


- (void)change
{
    self.method =(int)self.segmentedControl.selectedSegmentIndex;
    [self.data removeAllObjects];
    [self.clickStatuA removeAllObjects];
    self.rowAndHeight = nil;
    [self getData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProclamationInfoViewController *pushView = [[ProclamationInfoViewController alloc]init];
    pushView.proclamationId = [self.data[indexPath.section] Id];
    pushView.type = self.method;
    [self.navigationController pushViewController:pushView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 点击刷新按钮
- (void)clickRefreshBtn
{
    NSLog(@"刷新");
    self.refreshBtnClickStatu = !self.refreshBtnClickStatu;
    [self.data removeAllObjects];
    [self getData];
}
#pragma mark -- 点击添加按钮
- (void)clickAdd
{
    NSLog(@"添加");
}
#pragma mark -- view点击事件
- (void)click:(UIGestureRecognizer *)sender
{
    if ([self.clickStatuA[sender.view.tag - 300] boolValue]) {
        [self.clickStatuA replaceObjectAtIndex:sender.view.tag - 300 withObject:[NSNumber numberWithBool:NO]];
    }
    else
    {
        [self.clickStatuA replaceObjectAtIndex:sender.view.tag - 300 withObject:[NSNumber numberWithBool:YES]];
    }
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:sender.view.tag - 300];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    NSLog(@"%d",sender.view.tag - 300);
}
@end