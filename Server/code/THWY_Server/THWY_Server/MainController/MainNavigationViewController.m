//
//  MainNavigationViewController.m
//  snowonline
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MainNavigationViewController.h"
#import "RepairDetailController.h"
#import "ProclamationInfoViewController.h"
#import "CommunicateViewController.h"
#import "UMessage.h"
#import "BannerNotice.h"
#import "CommunicateViewController.h"

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
    [UMessage sendClickReportForRemoteNotification:userInfo];
    NSString* pushType = [NSString stringWithFormat:@"%ld",[userInfo[@"push_type"] integerValue]];
    NSString* Id = userInfo[@"pk"];
    if ([pushType isEqualToString:@"1"])
    {
        CommunicateViewController *vc = [[CommunicateViewController alloc]init];
        
            vc.s_admin_id = userInfo[@"s_admin_id"];
        if ([userInfo[@"s_photo"] rangeOfString:@"http"].location == NSNotFound) {
            
            vc.s_photo = [NSString stringWithFormat:@"%@%@",API_Prefix,userInfo[@"s_photo"]];
        }else
        {
            vc.s_photo = userInfo[@"s_photo"];
        }
        
        vc.Id = @"1";
        
        [self pushViewController:vc animated:YES];
//        Id                 聊天记录ID值
//        s_photo            发送方头像绝对路径
//        re_photo           接收方头像绝对路径
//        s_admin_id         发送方账号ID值
//        re_admin_id        接收方账号ID值
        
        
    }else if ([pushType isEqualToString:@"2"])
    {
        //物业公告－行政公告
        ProclamationInfoViewController *infoVC = [[ProclamationInfoViewController alloc]init];
        
        infoVC.type = GetAdministrationData;
        infoVC.proclamationId = Id;
        
        [self pushViewController:infoVC animated:YES];

        
    }else if ([pushType isEqualToString:@"3"])
    {
        //物业公告－商圈公告
        ProclamationInfoViewController *infoVC = [[ProclamationInfoViewController alloc]init];
        
        infoVC.type = GetBusinessData;
        infoVC.proclamationId = Id;
        
        [self pushViewController:infoVC animated:YES];

    }else if ([pushType isEqualToString:@"4"])
    {
        //报修接单
        RepairDetailController *detail = [[RepairDetailController alloc] init];
        detail.repairVOId = Id;
        detail.displayType = RepairStatisticsDetailType;
        if ([userInfo[@"repair_type"] isEqualToString:@"o"]) {
            detail.type = 1;
        }else{
            detail.type = 2;
        }
        [self pushViewController:detail animated:YES];
    
    }
    if (_userInfo) {
        _userInfo = nil;
    }
}

-(void)showAlertWithUserInfo:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString* pushType = [NSString stringWithFormat:@"%ld",[userInfo[@"push_type"] integerValue]];
    if ([pushType isEqualToString:@"1"] && [self.topViewController isKindOfClass:[CommunicateViewController class]])
    {
        return;
    }
    
    _userInfo = userInfo;
    tapGestureBool = YES;
    
    NSString* bannerName = @"通惠物业";
    if (userInfo[@"title"]) {
        bannerName = userInfo[@"title"];
    }
    
    UIView *viewBanner = [BannerNotice bannerWith:[UIImage imageNamed:@"ios4"] bannerName:bannerName bannerContent:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
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
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    
    [viewBanner addGestureRecognizer:swipe];
    
    [My_KeyWindow addSubview:viewBanner];
}

-(void)swipe:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.5 animations:^{
            swipe.view.transform = CGAffineTransformMakeTranslation(0, -70);
        }completion:^(BOOL finished) {
            [swipe.view removeFromSuperview];
        }];
    }
}

- (void)event:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.5 animations:^{
        gesture.view.transform = CGAffineTransformMakeTranslation(0, -70);
    }completion:^(BOOL finished) {
        [gesture.view removeFromSuperview];
    }];
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
    att[NSFontAttributeName] = [UIFont fontWithDeviceName:My_RegularFontName size:18];
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
        [back setBackgroundImage:[UIImage imageNamed:@"main_back-icon"] forState:UIControlStateNormal];
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
