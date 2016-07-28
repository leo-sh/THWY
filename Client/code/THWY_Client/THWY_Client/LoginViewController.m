//
//  LoginViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "userAndPassWordTextField.h"
#import "BlueCheckButton.h"
#import "ServicesManager.h"
#import "MainVC.h"
@interface LoginViewController ()
@property UIImageView *LogoView;
@property userAndPassWordTextField *userTF;
@property userAndPassWordTextField *passWordTF;
@property BlueCheckButton *rememberPassWordBtn;
@property BlueCheckButton *adminLoginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ViewInitSetting];
    [self createLogoImageView];
    [self createUserAndPasswordTextfiled];
    [self createButton];
}

- (void)ViewInitSetting
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    backgroundImageView.image = [UIImage imageNamed:@"大背景"];
    
    [self.view addSubview:backgroundImageView];
}

- (void)createLogoImageView
{
    self.LogoView = [[UIImageView alloc]init];
    
    self.LogoView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.LogoView];
    
    [self.LogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.height * 0.1);
        make.width.mas_equalTo(self.view.width *0.6);
        make.height.equalTo(@40);
    }];
}

- (void)createUserAndPasswordTextfiled
{
    self.userTF =[[userAndPassWordTextField alloc]init];
    
    [self.view addSubview:self.userTF];
    
    CGFloat userAndPassWordTFWidth = self.view.width *0.9;
    CGFloat userTFTop = self.view.height * 0.1;
    CGFloat userAndPassWordHeight = self.view.height * 0.08;
    
    [self.userTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LogoView.mas_bottom).with.offset(userTFTop);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(userAndPassWordTFWidth);
        make.height.mas_equalTo(userAndPassWordHeight);

    }];
    
    [self.userTF setLeftIcon:@"账号" placeholder:@"请输入账号" backgroundColor:[UIColor whiteColor]];
    
    self.userTF.text = [[UDManager getUD]getUserName];
    
    NSLog(@"%@",[[UDManager getUD]getUserName]);
    NSLog(@"%@",[[UDManager getUD]getPassWord]);
    
    self.passWordTF =[[userAndPassWordTextField alloc]init];
    [self.passWordTF setSecureTextEntry:YES];
    [self.view addSubview:self.passWordTF];
    
    CGFloat passWordTFTop = self.view.height * 0.001;
    
    [self.passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userTF.mas_bottom).with.offset(passWordTFTop);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(userAndPassWordTFWidth);
        make.height.mas_equalTo(userAndPassWordHeight);
    }];
    
    [self.passWordTF setLeftIcon:@"密码" placeholder:@"请输入密码" backgroundColor:[UIColor whiteColor]];
    
    self.passWordTF.text = [[UDManager getUD]getPassWord];

    
}

- (void)createButton
{
    self.rememberPassWordBtn = [[BlueCheckButton alloc]initDefaultImageName:@"框不带勾" choosedImageName:@"框带勾" title:@"忘记密码"];
    
    [self.view addSubview:self.rememberPassWordBtn];

    CGFloat rememberPassWordBtnLeft = self.view.width *0.056;
    CGFloat topOffset = self.view.height * 0.03;
    CGFloat rememberPassWordBtnWidth = self.view.width *0.26;
    CGFloat rememberPassWordBtnHeight = self.view.height *0.02;
    
    [self.rememberPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rememberPassWordBtnLeft);
        make.top.equalTo(self.passWordTF.mas_bottom).with.offset(topOffset);
        make.width.mas_equalTo(rememberPassWordBtnWidth);
        make.height.mas_equalTo(rememberPassWordBtnHeight);
    }];
    
    self.rememberPassWordBtn.titleLabel.font = [UIFont systemFontOfSize:rememberPassWordBtnHeight];

    
    [self.rememberPassWordBtn addTarget:self action:@selector(clickRememberPassWordBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.adminLoginBtn = [[BlueCheckButton alloc]initDefaultImageName:@"框不带勾" choosedImageName:@"框带勾" title:@"管理员登录"];
    [self.view addSubview:self.adminLoginBtn];
    
    CGFloat adminLoginBtnRightOffset = -self.view.width *0.016;
    CGFloat adminLoginBtnWidth = self.view.width *0.26;
    CGFloat adminLoginBtnHeight = self.view.height *0.02;
    
    [self.adminLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(adminLoginBtnRightOffset);
        make.top.equalTo(self.passWordTF.mas_bottom).with.offset(topOffset);
        make.width.mas_equalTo(adminLoginBtnWidth);
        make.height.mas_equalTo(adminLoginBtnHeight);
    }];
    
    self.adminLoginBtn.titleLabel.font = [UIFont systemFontOfSize:adminLoginBtnHeight];
    
    
    [self.adminLoginBtn addTarget:self action:@selector(clickAdminLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *LoginBtn = [[UIButton alloc]init];
    
    [LoginBtn setImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
    [LoginBtn setImage:[UIImage imageNamed:@"登录按下"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:LoginBtn];
    
    CGFloat LoginBtnBottomOffset = -self.view.height * 0.4;
    CGFloat LoginBtnWidth = self.view.width * 0.8;
    CGFloat LoginBtnHeight = self.view.height * 0.08;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LoginBtnWidth, LoginBtnHeight)];
    label.text = @"登录";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:label.height/2.668];
    [LoginBtn addSubview:label];
    
    [LoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(LoginBtnBottomOffset);
        make.width.mas_equalTo(LoginBtnWidth);
        make.height.mas_equalTo(LoginBtnHeight);
    }];
    
    [LoginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clickAdminLoginBtn
{
    [self.adminLoginBtn click];
    
}

- (void)clickRememberPassWordBtn
{
    [self.rememberPassWordBtn click];
}
- (void)login
{
    [[ServicesManager getAPI] login:self.userTF.text password:self.passWordTF.text onComplete:^(NSString *errorMsg, UserVO *user) {
        NSLog(@"%@",user);
        if (errorMsg) {
            NSLog(@"%@",errorMsg);
        }
        else if (user) {
            [[UDManager getUD] saveUser:user];
            
            [[UDManager getUD]saveUserName:self.userTF.text];
            
                if (self.rememberPassWordBtn.chooseStatu) {
                    [[UDManager getUD]saveUserPassWord:self.passWordTF.text];
                }
            NSLog(@"%@",self.userTF.text);
            NSLog(@"%@",self.passWordTF.text);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
    NSLog(@"%@",[[UDManager getUD]getUserName]);
    NSLog(@"%@",[[UDManager getUD]getPassWord]);
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
