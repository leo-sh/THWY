//
//  RootVC.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RootVC.h"
#import "LoginViewController.h"
@interface RootVC ()

@end

@implementation RootVC

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self customNVBar];
    
    if (![[ServicesManager getAPI]isLogin]) {
        LoginViewController *presentView = [[LoginViewController alloc]init];
        [self presentViewController:presentView animated:YES completion:nil];
    }

}

- (void)customNVBar{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [button setBackgroundImage:[UIImage imageNamed:@"注销按钮"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(signOut)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)signOut{
    NSLog(@"signout");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
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
