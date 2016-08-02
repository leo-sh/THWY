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
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property NSArray *data;
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
    //    [self.navigationController pushViewController:[[PayInfoViewController alloc]init] animated:YES];
}

- (void)getData
{
    [[ServicesManager getAPI]getFees:1 year:0 feeState:All onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            NSLog(@"%@",errorMsg);
        }
        self.data = list;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
        });
        
    }];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
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
