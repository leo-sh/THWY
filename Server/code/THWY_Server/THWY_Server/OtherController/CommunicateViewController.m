//
//  CommunicateViewController.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "CommunicateViewController.h"
#import "ServicesManager.h"
@interface CommunicateViewController ()

@end

@implementation CommunicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];

    // Do any additional setup after loading the view.
}

- (void)getData
{
    [[ServicesManager getAPI] getMsgs:self.friendId endId:@"" onComplete:^(NSString *errorMsg, NSArray *list) {
        
    }];
}

- (void)ViewInitSetting
{
    self.title = @"发送短消息";
    self.view.backgroundColor = [UIColor greenColor];
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
