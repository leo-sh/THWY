//
//  PushSettingVC.m
//  THWY_Client
//
//  Created by wei on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PushSettingVC.h"
#import "UMessage.h"

@interface PushSettingVC ()

@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;

@property (strong, nonatomic) NSArray *bools;

@end

@implementation PushSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推送设置";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];
    [self initViews];
    
    self.bools = @[@YES, @NO, @NO];
}

- (void)initViews{
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pushsetting_bg_bai"]]];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(10);
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.5);
    }];
    
    UILabel *accept = [[UILabel alloc] init];
    accept.text = @"  接受推送";
    accept.textAlignment = NSTextAlignmentLeft;
    accept.textColor = [UIColor blackColor];
    accept.layer.borderWidth = 1;
    accept.userInteractionEnabled = YES;
    accept.layer.borderColor = [UIColor lightGrayColor].CGColor;
    accept.font = [UIFont fontWithName:My_RegularFontName size:17.0];
    [accept sizeToFit];
    [bgView addSubview:accept];
    [accept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bgView.mas_width);
        make.height.mas_equalTo(bgView.mas_height).multipliedBy(0.2);
        make.left.mas_equalTo(bgView.mas_left);
        make.top.mas_equalTo(bgView.mas_top);
    }];
    
    self.button1 = [[UIButton alloc] init];
    self.button1.tag = 11;
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"pushsetting_开"] forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [accept addSubview:self.button1];
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(accept.mas_right).offset(-15);
        make.centerY.mas_equalTo(accept.mas_centerY);
        make.height.mas_equalTo(accept.mas_height).multipliedBy(0.5);
    }];
    
    UILabel *lisheng = [[UILabel alloc] init];
    lisheng.text = @"  铃声提醒";
    lisheng.textAlignment = NSTextAlignmentLeft;
    lisheng.textColor = [UIColor blackColor];
    lisheng.layer.borderWidth = 1;
    lisheng.userInteractionEnabled = YES;
    lisheng.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lisheng.font = [UIFont fontWithName:My_RegularFontName size:17.0];
    [lisheng sizeToFit];
    [bgView addSubview:lisheng];
    [lisheng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bgView.mas_width);
        make.height.mas_equalTo(bgView.mas_height).multipliedBy(0.2);
        make.left.mas_equalTo(bgView.mas_left);
        make.top.mas_equalTo(accept.mas_bottom).offset(-1);
    }];
    
    self.button2 = [[UIButton alloc] init];
    self.button2.tag = 12;
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"pushsetting_关"] forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [accept addSubview:self.button2];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(accept.mas_right).offset(-15);
        make.centerY.mas_equalTo(lisheng.mas_centerY);
        make.height.mas_equalTo(accept.mas_height).multipliedBy(0.5);
    }];

    UILabel *zhendong = [[UILabel alloc] init];
    zhendong.text = @"  接受推送";
    zhendong.textAlignment = NSTextAlignmentLeft;
    zhendong.textColor = [UIColor blackColor];
    zhendong.layer.borderWidth = 1;
    zhendong.userInteractionEnabled = YES;
    zhendong.layer.borderColor = [UIColor lightGrayColor].CGColor;
    zhendong.font = [UIFont fontWithName:My_RegularFontName size:17.0];
    [zhendong sizeToFit];
    [bgView addSubview:zhendong];
    [zhendong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bgView.mas_width);
        make.height.mas_equalTo(bgView.mas_height).multipliedBy(0.2);
        make.left.mas_equalTo(bgView.mas_left);
        make.top.mas_equalTo(lisheng.mas_bottom).offset(-1);
    }];
    
    self.button3 = [[UIButton alloc] init];
    self.button3.tag = 11;
    [self.button3 setBackgroundImage:[UIImage imageNamed:@"pushsetting_开"] forState:UIControlStateNormal];
    [self.button3 addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [accept addSubview:self.button3];
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(accept.mas_right).offset(-15);
        make.centerY.mas_equalTo(zhendong.mas_centerY);
        make.height.mas_equalTo(accept.mas_height).multipliedBy(0.5);
    }];
    
}

- (void)btnOnclicked:(UIButton *)sender{

    NSInteger index = sender.tag-11;
    if ([self.bools[index] boolValue]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"pushsetting_关"] forState:UIControlStateNormal];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"pushsetting_开"] forState:UIControlStateNormal];
    }
    
    __block UIRemoteNotificationType types7 = UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound;
    __block UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    
    switch (index) {
        case 0:{//接受推送
            if (([self.bools[index] boolValue])) {
                [UMessage unregisterForRemoteNotifications];
            }else{
                [UMessage registerForRemoteNotifications];
            }
            break;
        }
        case 1:{//铃声提醒
            if ([self.bools[index] boolValue]) {
                types7 = UIRemoteNotificationTypeNone;
                types8 = UIUserNotificationTypeNone;
            }else{
                types7 = UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound;
                types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
            }
            [UMessage registerForRemoteNotifications:nil withTypesForIos7:types7 withTypesForIos8:types8];
            break;
        }
        case 2:{//震动提醒
            
            break;
        }
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
