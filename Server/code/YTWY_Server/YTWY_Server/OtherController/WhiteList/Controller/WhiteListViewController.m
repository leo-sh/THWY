//
//  WhiteListViewController.m
//  YTWY_Server
//
//  Created by HuangYiZhe on 16/8/21.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WhiteListViewController.h"
#import "ServicesManager.h"
#import "AddBtn.h"
#import "WhiteListTableViewCell.h"
#import "AlerView.h"
@interface WhiteListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property NSMutableArray *data;
@end

@implementation WhiteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    UIImage *backGroundImage = [UIImage imageNamed:@"b背景"];
    
    self.view.layer.contents = (id)backGroundImage.CGImage;
    
    self.data = [NSMutableArray array];
    self.title = @"IP白名单";
}

- (void)getData
{
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    
    [[ServicesManager getAPI] getIpAllows:^(NSString *errorMsg, NSArray *list) {
        [SVProgressHUD dismiss];
        self.data.array = list;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
        });
        
    }];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 10, self.view.height) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-70);
    }];
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = WhiteAlphaColor;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tableView.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        
    }];
    
    AddBtn *btn = [[AddBtn alloc]initWithFrame:CGRectMake(40, 15, self.view.width - 80, 40)];
    [btn setLeftImageView:@"记录" andTitle:@"添加"];
    [btn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhiteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[WhiteListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.width = tableView.width;
    [cell setEstate:[self.data[indexPath.row] the_user] IP:[self.data[indexPath.row] ip]Id:[self.data[indexPath.row] Id]];
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = My_AlphaColor(236, 252, 245, 0.5);
//    [cell setSelectedBackgroundView:view];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row != self.data.count - 1) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.bottom, tableView.width, 0.5)];
        line.backgroundColor = CellUnderLineColor;
        
        [cell.contentView addSubview:line];
    }
    cell.backgroundColor = WhiteAlphaColor;
    
    NSLog(@"tableViewWidth:%f",tableView.width);
    return cell;
}

- (void)clickAdd
{
    NSLog(@"添加");
    AlerView * view =[[AlerView alloc]initWithFrame:CGRectMake(10,0, self.view.width - 20, 0)];
    view.method = Add;
    [view showInWindow];
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
