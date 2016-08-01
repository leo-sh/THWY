//
//  ComplainDetailViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ComplainDetailViewController.h"
#import "ServicesManager.h"
#import "Masonry.h"
@interface ComplainDetailViewController ()
@property NSArray *data;
@property UITableView *tableView;
@end

@implementation ComplainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"投诉详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [[ServicesManager getAPI] getAComplaint:self.complianId onComplete:^(NSString *errorMsg, ComplaintVO *complaint) {
        if (errorMsg) {
            NSLog(@"%@",errorMsg);
        }
        NSLog(@"%@",complaint);
        NSLog(@"%@",self.complianId);
        NSArray *sectionOneData = @[];
        NSArray *sectionTwoData = @[];
        NSArray *sectionThreeData = @[];
        
        self.data = @[sectionOneData,sectionTwoData,sectionThreeData];
        
        
    }];
    NSLog(@"%@",self.data);
}

- (void)createUI
{
    
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
