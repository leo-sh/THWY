//
//  FindPasswordVC.m
//  THWY_Client
//
//  Created by Mr.S on 16/8/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "FindPasswordVC.h"
#define CODE_MAX 6

@interface FindPasswordVC ()<UITextFieldDelegate>

@property UIView* mainView;

@property UITextField* userNameTf;
@property UITextField* phoneNumTf;
@property UITextField* numTf;
@property UITextField* passWordTf;

@property UIButton* subMitBtn;
@property UIButton* sendCodeBtn;

@property NSArray<UITextField *>* tfArr;

@property NSTimer* sendCodeTimer;

@property int time;
@end

@implementation FindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    [self createUI];
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (UITextField* tf in self.tfArr) {
        [tf endEditing:YES];
    }
}

-(void)createUI
{
    UIImageView* imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Integral_背景"]];
    imv.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    imv.userInteractionEnabled = YES;
    [self.view addSubview:imv];
    
    self.mainView = [[UIView alloc]initWithFrame:imv.frame];
    [self.view addSubview:self.mainView];
    
    self.userNameTf = [[UITextField alloc]init];
    self.userNameTf.placeholder = @"请输入账号";
    self.userNameTf.delegate = self;
    
    self.phoneNumTf = [[UITextField alloc]init];
    self.phoneNumTf.placeholder = @"请输入手机号码";
//    self.phoneNumTf.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTf.delegate = self;
    
    self.numTf = [[UITextField alloc]init];
    self.numTf.placeholder = @"请输入验证码";
//    self.numTf.keyboardType = UIKeyboardTypeNumberPad;
    self.numTf.delegate = self;
    
    self.passWordTf = [[UITextField alloc]init];
    self.passWordTf.placeholder = @"请输入6-20位字符的新密码";
    self.passWordTf.keyboardType = UIKeyboardTypeASCIICapable;
//    self.passWordTf.keyboardAppearance = UIKeyboardAppearanceDark;
    self.passWordTf.delegate = self;
    self.passWordTf.secureTextEntry = YES;
    
    self.tfArr = @[self.userNameTf,self.phoneNumTf,self.numTf,self.passWordTf];
    
    for (int i = 0; i < self.tfArr.count; i++) {
        UITextField* tf = self.tfArr[i];
        tf.frame = CGRectMake(0, 35/375.0*My_ScreenW + i*50/375.0*My_ScreenW, My_ScreenW, 50/375.0*My_ScreenW);
        tf.backgroundColor = [UIColor whiteColor];
        tf.returnKeyType = UIReturnKeyNext;
        tf.font = FontSize(CONTENT_FONT + 1);
        tf.leftViewMode = UITextFieldViewModeAlways;
        
        UIView* leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tf.height, tf.height)];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5/375.0*My_ScreenW, 0, leftView.width - 15/375.0*My_ScreenW, leftView.height - 10/375.0*My_ScreenW)];
        imageView.backgroundColor = My_RandomColor;
        imageView.center = CGPointMake(imageView.center.x, leftView.height/2);
        [leftView addSubview:imageView];
        tf.leftView = leftView;
        
        if (i == self.tfArr.count - 1) {
            tf.y += 25/375.0*My_ScreenW;
            tf.returnKeyType = UIReturnKeyDone;
        }
        
        [self.mainView addSubview:tf];
        
        if (i < self.tfArr.count - 1 && i>0) {
            UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(50/375.0*My_ScreenW, tf.y - 0.25, My_ScreenW - 50/375.0*My_ScreenW, 0.5)];
            lineView.backgroundColor = CellUnderLineColor;
            [self.mainView addSubview:lineView];
        }
    }
    
    self.numTf.rightViewMode = UITextFieldViewModeAlways;
    UIView* numRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110/375.0*My_ScreenW, self.numTf.height)];
    
    self.sendCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 8/375.0*My_ScreenW, numRightView.width - 15/375.0*My_ScreenW, self.numTf.height - 16/375.0*My_ScreenW)];
    self.sendCodeBtn.enabled = NO;
    [self.sendCodeBtn setBackgroundImage:[UIImage createImageWithColor:My_NAV_BG_Color] forState:UIControlStateNormal];
    [self.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendCodeBtn.titleLabel.font = FontSize(CONTENT_FONT);
    self.sendCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.sendCodeBtn.clipsToBounds = YES;
    self.sendCodeBtn.layer.cornerRadius = self.sendCodeBtn.height/2;
    [self.sendCodeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    [numRightView addSubview:self.sendCodeBtn];
    
    self.numTf.rightView = numRightView;
    
    self.subMitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.passWordTf.bottom + 25/375.0*My_ScreenW, My_ScreenW - 30/375.0*My_ScreenW, self.passWordTf.height)];
    self.subMitBtn.clipsToBounds = YES;
    self.subMitBtn.layer.cornerRadius = self.subMitBtn.height/2;
    self.subMitBtn.center = CGPointMake(self.mainView.width/2, self.subMitBtn.center.y);
    [self.subMitBtn addTarget:self action:@selector(subMit) forControlEvents:UIControlEventTouchUpInside];
    [self.subMitBtn setBackgroundImage:[UIImage createImageWithColor:My_NAV_BG_Color] forState:UIControlStateNormal];
    [self.subMitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.subMitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.subMitBtn.titleLabel.font = FontSize(CONTENT_FONT+8);
    self.subMitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.subMitBtn.enabled = NO;
    [self.mainView addSubview:self.subMitBtn];
}

-(void)subMit
{
    for (UITextField* tf in self.tfArr) {
        [tf endEditing:YES];
    }
    
    if ([self.phoneNumTf.text isValidateMobile]) {
        if (self.numTf.text.length < 4) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            [self.numTf becomeFirstResponder];
            return;
        }
        
        if (self.userNameTf.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
            [self.userNameTf becomeFirstResponder];
            return;
        }
        
        if (self.passWordTf.text.length < 6 || self.passWordTf.text.length > 20) {
            [SVProgressHUD showErrorWithStatus:@"新密码长度不正确"];
            [self.passWordTf becomeFirstResponder];
            return;
        }
    }else
    {
        if (self.phoneNumTf.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
            [self.phoneNumTf becomeFirstResponder];
            return;
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
            [self.phoneNumTf becomeFirstResponder];
            return;
        }
        
    }
    
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    [My_ServicesManager setNewPassword:self.userNameTf.text phoneNum:self.phoneNumTf.text code:self.numTf.text newPassword:self.passWordTf.text onComplete:^(NSString *errorMsg) {
        if (errorMsg == nil) {
            [SVProgressHUD showErrorWithStatus:@"重置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
    }];
    
}

-(void)sendCode
{
    if (self.userNameTf.text.length > 0) {
        if ([self.phoneNumTf.text isValidateMobile]) {
            [self.phoneNumTf endEditing:YES];
            [self.numTf becomeFirstResponder];
            self.sendCodeBtn.enabled = NO;
            
            [SVProgressHUD showWithStatus:@"发送中..."];
            [My_ServicesManager sendCode:self.userNameTf.text phoneNum:self.phoneNumTf.text onComplete:^(NSString *errorMsg) {
                if (errorMsg == nil) {
                    [SVProgressHUD showErrorWithStatus:@"发送成功"];
                    self.time = 60;
                    if (self.sendCodeTimer) {
                        [self.sendCodeTimer invalidate];
                    }
                    
                    self.sendCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSendTime) userInfo:nil repeats:YES];
                    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%dS",self.time] forState:UIControlStateDisabled];
                    [self.numTf becomeFirstResponder];
                }else
                {
                    self.sendCodeBtn.enabled = YES;
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
            return;
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    
}

-(void)updateSendTime
{
    self.time --;
    if (self.time == 0) {
        self.sendCodeBtn.enabled = YES;
        [self.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [self.sendCodeTimer invalidate];
        self.time = 60;
    }else
    {
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%dS",self.time] forState:UIControlStateDisabled];
    }
}

#pragma mark TextFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    NSString* resultStr = textField.text;
    if (string > 0) {
        resultStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }else
    {
        if (textField.text.length > 0) {
            if (textField.text.length == 1) {
                resultStr = @"";
            }else
            {
                resultStr = [textField.text substringToIndex:textField.text.length - 1];
            }
        }else
        {
            resultStr = @"";
        }
    }
    
    if (resultStr.length > 20) {
        return NO;
    }
    
    NSString* userName = self.userNameTf.text;
    NSString* phoneNum = self.phoneNumTf.text;
    NSString* code = self.numTf.text;
    NSString* passWord = self.passWordTf.text;
    
    if (textField == self.userNameTf) {
        userName = resultStr;
    }else if (textField == self.phoneNumTf){
        phoneNum = resultStr;
        if (resultStr.length > 11) {
            return NO;
        }
        if ([resultStr isValidateMobile]) {
            self.sendCodeBtn.enabled = YES;
        }else
        {
            self.sendCodeBtn.enabled = NO;
        }
    }else if (textField == self.numTf){
        code = resultStr;
        if (resultStr.length > CODE_MAX) {
            return NO;
        }
    }else if (textField == self.passWordTf){
        passWord = resultStr;
    }
    
    if (userName.length > 0 && [phoneNum isValidateMobile] && code.length == CODE_MAX && passWord.length >= 6 && passWord.length <= 20) {
        self.subMitBtn.enabled = YES;
    }else
    {
        self.subMitBtn.enabled = NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.userNameTf) {
        [self.phoneNumTf becomeFirstResponder];
    }else if (textField == self.phoneNumTf){
        [self.numTf becomeFirstResponder];
    }else if (textField == self.numTf){
        [self.passWordTf becomeFirstResponder];
    }else if (textField == self.passWordTf){
        if (self.userNameTf.text.length > 0 && [self.phoneNumTf.text isValidateMobile] && self.numTf.text.length == CODE_MAX && self.passWordTf.text.length >= 6 && self.passWordTf.text.length <= 20) {
            
            [self subMit];
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITextField* tf in self.tfArr) {
        if (![tf isExclusiveTouch] && [tf isEditing]) {
            [tf endEditing:YES];
        }
    }
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
