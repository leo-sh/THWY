//
//  WhiteListViewController.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/21.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WhiteListViewController.h"
#import "ServicesManager.h"
#import "WhiteListTableViewCell.h"
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
    [[ServicesManager getAPI] getIpAllows:^(NSString *errorMsg, NSArray *list) {
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
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhiteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[WhiteListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.width = tableView.width;
    [cell setEstate:[self.data[indexPath.row] Id] IP:[self.data[indexPath.row] ip]];
    cell.backgroundColor = WhiteAlphaColor;
    
    NSLog(@"tableViewWidth:%f",tableView.width);
    return cell;
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
