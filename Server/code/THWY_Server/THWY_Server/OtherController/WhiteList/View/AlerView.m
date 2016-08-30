//
//  AlerView.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/24.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlerView.h"
#import "ServicesManager.h"
#import "SVProgressHUD.h"
@interface AlerView()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property UITextField *userTF;
@property NSMutableArray *ipTFArray;
@end
@implementation AlerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];

        self.ipTFArray = [NSMutableArray array];
        
        CGFloat left = 10;
        CGFloat top = 10;
        CGFloat width = self.width - left * 2;
        CGFloat height = 25;
        UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, top, width, height)];
        userLabel.text = @"使用者";
        userLabel.font = FontSize(CONTENT_FONT);

        userLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:userLabel];
        
        self.userTF = [[UITextField alloc]initWithFrame:CGRectMake(left, userLabel.bottom + top, width, height)];
        self.userTF.layer.borderWidth = 0.5;
        self.userTF.layer.borderColor = CellUnderLineColor.CGColor;
        self.userTF.delegate = self;
        [self addSubview:self.userTF];
        
        UILabel *ipLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, self.userTF.bottom + top, width, height)];
        
        ipLabel.text = @"IP地址";
        ipLabel.font = FontSize(CONTENT_FONT);
        ipLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:ipLabel];
        
        CGFloat tf_L = 10;
        CGFloat tf_W = self.width/7.5;
        CGFloat tf_H = 25;
        CGFloat tf_Y =ipLabel.bottom + 10;
        for (int i = 0; i < 7; i ++) {
            
            if (i % 2 == 0) {
                
                UITextField *ipTF = [[UITextField alloc]initWithFrame:CGRectMake(tf_L + tf_W * i, tf_Y, tf_W, tf_H)];
                ipTF.layer.borderWidth = 0.5;
                ipTF.layer.borderColor = CellUnderLineColor.CGColor;
                ipTF.delegate = self;
                [self.ipTFArray addObject:ipTF];
                
                [self addSubview:ipTF];
            }
            else if (i % 2 == 1)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(tf_L + tf_W * i, tf_Y, tf_W, tf_H)];
                label.text = @"—";
                label.textAlignment = NSTextAlignmentCenter;
                
                [self addSubview:label];
            }
        }
        
        UITextField *temp = [self.ipTFArray firstObject];
        
        CGFloat btnY = temp.bottom + 15;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(left, btnY, width, 40)];
        
        btn.backgroundColor = My_NAV_BG_Color;
        
        [btn setTitle:@"添加" forState:UIControlStateNormal];
        
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.height = btn.bottom + 15;
        
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)clickBtn
{
//    NSLog(@"添加");
    
    BOOL isError = NO;
    
    if (self.method == Edit) {
        
        IPAllowVO *temp = [[IPAllowVO alloc]init];
        temp.Id = self.allowId;
        temp.the_user = self.userTF.text;
        NSMutableString *ipString = [[NSMutableString alloc]init];
        for (int i = 0 ;i < self.ipTFArray.count; i ++) {
            
            UITextField *temp = self.ipTFArray[i];
            if (temp.text.length ==0) {
                [SVProgressHUD showErrorWithStatus:@"ip地址格式错误"];
                isError = YES;
            }
            [ipString appendString:temp.text];
            if (i != self.ipTFArray.count) {
                [ipString appendString:@"."];
            }
            
        }
        temp.ip = ipString;
        if (!isError) {
            [[ServicesManager getAPI]editAIpAllow:temp onComplete:^(NSString *errorMsg) {
                
                if (errorMsg) {
                    [SVProgressHUD showWithStatus:errorMsg];
                }
                else
                {
                    [self hide];
                }
                
            }];
        }
        
    }
    else
    {
        IPAllowVO *temp = [[IPAllowVO alloc]init];
        temp.the_user = self.userTF.text;
        NSMutableString *ipString = [[NSMutableString alloc]init];
        for (int i = 0 ;i < self.ipTFArray.count; i ++) {
            
            UITextField *temp = self.ipTFArray[i];
            if (temp.text.length ==0 || [temp.text intValue] >255) {
                [SVProgressHUD showErrorWithStatus:@"ip地址格式错误"];
                isError = YES;
            }
            [ipString appendString:temp.text];
            if (i != self.ipTFArray.count) {
                [ipString appendString:@"."];
            }
            
        }
        temp.ip = ipString;
        if (!isError) {
            [[ServicesManager getAPI] addAIpAllow:temp onComplete:^(NSString *errorMsg) {
                
                if (errorMsg) {
                    [SVProgressHUD showWithStatus:errorMsg];
                }
                
                else
                {
                    [self hide];
                }
                
            }];
        }
        
    }
    
}

- (void)setUser:(NSString *)user IP:(NSString *)ip
{
    self.userTF.text = user;
    self.userTF.font = FontSize(CONTENT_FONT);
    
    NSArray *ipArray = [ip componentsSeparatedByString:@"."];
    
    for (int i = 0; i < self.ipTFArray.count; i ++) {
        UITextField *temp = self.ipTFArray[i];
        
        temp.text = ipArray[i];
        temp.font = FontSize(CONTENT_FONT);
    }
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)showInWindow
{
    if (self.superview == nil) {
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:My_KeyWindow.bounds];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [backgroundView addGestureRecognizer:tap];
        [My_KeyWindow addSubview:backgroundView];
        
        self.center = backgroundView.center;
        
        [backgroundView addSubview:self];
        
    }

}

- (void)hide
{
    if (self.superview) {
        [self.superview removeFromSuperview];
    }
}

- (void)tap
{
    [self hide];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"AlerView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark -- uitextfield代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma 键盘监听
- (void)keyboardShow:(NSNotification *)notification
{
    NSLog(@"弹出键盘");
    
    NSDictionary *info = notification.userInfo;
    
    NSValue *value = [info valueForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGRect rect = [value CGRectValue];
    
    NSLog(@"------------keyboradHeight%f,self.frame.y%f,self.frame.bottom%f",rect.size.height,self.y,self.bottom);
    
    
    
    if ([UIScreen mainScreen].bounds.size.height - rect.size.height - self.height > 20 ) {
        
        self.y = [UIScreen mainScreen].bounds.size.height - rect.size.height - self.height;
    }
    else
    {
        self.y = 20;
    }
    
}
- (void)keyboardHide
{
    self.center = self.superview.center;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
