//
//  MainNavigationViewController.m
//  snowonline
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MainNavigationViewController.h"
#import "RecommandBussnessADVC.h"
#import "RepairDetailController.h"

@interface MainNavigationViewController () <UINavigationControllerDelegate>
//@property (nonatomic, strong) id popDelegate;
{
    BOOL tapGestureBool;
    NSDictionary* _userInfo;
}
@end

@implementation MainNavigationViewController

-(void)popWithUserInfo:(NSDictionary *)userInfo
{
    NSString* pushType = userInfo[@"push_type"];
    if ([pushType isEqualToString:@"4"]) {
//        报修接单
        RepairDetailController *detail = [[RepairDetailController alloc] init];
#pragma - TODO RepairVO
        detail.model = [[RepairVO alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if ([pushType isEqualToString:@"5"])
    {
//        业主公告
        
    }else if ([pushType isEqualToString:@"6"])
    {
//        社区商圈-商圈公告
        RecommandBussnessADVC *advc = [[RecommandBussnessADVC alloc] init];
        [self.navigationController pushViewController:advc animated:YES];
        
    }else if ([pushType isEqualToString:@"7"])
    {
//        缴费台账
        
    }
    if (_userInfo) {
        _userInfo = nil;
    }
}

-(void)showAlertWithUserInfo:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
    tapGestureBool = YES;
    UIView *viewBanner = [BannerNotice bannerWith:[UIImage imageNamed:@"ios4"] bannerName:@"泰生活" bannerContent:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    [viewBanner addGestureRecognizer:tapGesture];
    
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (tapGestureBool) {
            //转换成一个本地通知，显示到通知栏，
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.userInfo = userInfo;
            localNotification.alertAction = @"查看";
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            localNotification.fireDate = [NSDate date];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    });
    
    [My_KeyWindow addSubview:viewBanner];
}

- (void)event:(UITapGestureRecognizer *)gesture
{
    tapGestureBool = NO;
    [self popWithUserInfo:_userInfo];
}

+ (void)initialize {
    // 设置UIUINavigationBar的主题
    [self setupNavigationBarTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupNavigationBarTheme {
    // 通过appearance对象能修改整个项目中所有UIBarbuttonItem的样式
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 1.设置导航条的背景
    [appearance setBackgroundImage:[UIImage createImageWithColor:My_NAV_BG_Color] forBarMetrics:UIBarMetricsDefault];
    
    // 设置文字
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = [UIFont fontWithDeviceName:My_RegularFontName size:17];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:att];
    
    appearance.tintColor = My_BlackColor;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {// 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        //        viewController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -5;
        
        //设置导航栏的按钮
        UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [back setBackgroundImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
        
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}

//// 完全展示完调用
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 如果展示的控制器是根控制器，就还原pop手势代理
//    if (viewController == [self.viewControllers firstObject]) {
//        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
//    }
//}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
