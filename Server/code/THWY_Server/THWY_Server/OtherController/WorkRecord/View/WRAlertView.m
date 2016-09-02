//
//  WRAlertView.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WRAlertView.h"
#import "BlueRedioButton.h"
#import "ServicesManager.h"
#import "SVProgressHUD.h"
@interface WRAlertView()<UIGestureRecognizerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property UITextField *title;
@property UITextView *textView;
@property UIButton *leftBtn;
@property UIButton *rightBtn;
@property NSInteger number;
@property UILabel *placeholderLabel;
@property NSString *docId;
@property NSString *titleString;
@property NSString *contentString;
@property BlueRedioButton *public;
@end
@implementation WRAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
        [self addObserver:self forKeyPath:@"typeId" options:NSKeyValueObservingOptionNew context:nil];
        self.backgroundColor = [UIColor whiteColor];
        self.textView.text = @"";
        CGFloat heighAndWidth = 50;
        
        self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, heighAndWidth, heighAndWidth)];
        [self.leftBtn setImage:[UIImage imageNamed:@"√"] forState:UIControlStateNormal];
        self.leftBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 14.5,  15 , 14.5);
        [self addSubview:self.leftBtn];
        [self.leftBtn addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.right - heighAndWidth - 10, 0, heighAndWidth, heighAndWidth)];
        
        [self.rightBtn setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
        //        self.rightBtn.backgroundColor = [UIColor blackColor];
        
        self.rightBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 14.5,15, 14.5);
        
        
        [self.rightBtn addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
        
        self.title = [[UITextField alloc]initWithFrame:CGRectMake(self.leftBtn.right, 0, self.width - self.leftBtn.right * 2, 50)];
        self.number = 1;
        self.title.delegate = self;
        [self.title becomeFirstResponder];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.title];
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(15, self.title.bottom, self.width - 30, 100)];
        self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textView.font = FontSize(CONTENT_FONT);
        self.textView.textAlignment = NSTextAlignmentLeft;
        self.textView.layer.borderColor = CellUnderLineColor.CGColor;
        self.textView.layer.borderWidth = 0.5;
        self.textView.delegate = self;
        [self addSubview:self.textView];
        //        self.textView.font = FontSize(CONTENT_FONT);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
        
        CGFloat top = self.textView.bottom + 20;
        
        self.public = [[BlueRedioButton alloc]initWithFrame:CGRectMake(15, top, 70, 20)];
        [self.public initDefaultImageName:@"repaire_unselected" choosedImageName:@"repaire_selected" title:@"公开"];
        self.public.titleLabel.font = FontSize(CONTENT_FONT);
        [self.public setChoosed];
        [self addSubview:self.public];

        
        BlueRedioButton *private = [[BlueRedioButton alloc]initWithFrame:CGRectMake(self.public.right, top, 70, 20)];
        [private initDefaultImageName:@"repaire_unselected" choosedImageName:@"repaire_selected" title:@"个人"];
        private.titleLabel.font = FontSize(CONTENT_FONT);
    
        
        [self addSubview:private];
        
        self.height = private.bottom + 20;
        

        
    }
    return self;
}

- (void)setTitle:(NSString *)title Content:(NSString *)content typeId:(NSString *)typeId docId:(NSString *)docId{
    self.typeId = typeId;
    self.title.text = title;
    self.textView.text = content;
    self.contentString = content;
    self.titleString = title;
    self.docId = docId;
}

- (void)clickRight
{
    [self hide];
}

- (void)clickLeft
{
    NSLog(@"%@",self.typeId);
    if (self.reviseStatu) {
        if (self.textView.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"内容不能为空"];

        }
        
        else if ([self.textView.text isEqualToString:self.contentString] && [self.title.text isEqualToString:self.titleString])
        {
            [self hide];
        }
        
        else
        {
            [[ServicesManager getAPI]editDoc:self.docId typeId:self.typeId public:self.public.chooseStatu title:self.title.text content:self.textView.text onComplete:^(NSString *errorMsg) {
                
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"修改成功"];
                    [self hide];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Relodata object:nil];
                }
                
            }];
        }
    }
    else
    {
        if (self.textView.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
            
        }
        else if ([self.textView.text isEqualToString:self.contentString] && [self.title.text isEqualToString:self.titleString])
        {
            [self hide];
        }
        
        else
        {
            [[ServicesManager getAPI]addDoc:self.typeId public:self.public.chooseStatu title:self.title.text content:self.textView.text onComplete:^(NSString *errorMsg) {
                
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"修改成功"];
                    [self hide];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Relodata object:nil];
                    
                }
            }];
        }

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
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"WRAlertView"]) {
        return NO;
    }
    return  YES;
}

- (void)keyboardHide
{
    NSLog(@"收回键盘");
    
    [UIView animateWithDuration:0.2 animations:^{
        self.center = [self superview].center;
    }];
    
    
}

- (void)keyboardShow:(NSNotification *)notification
{
    NSLog(@"弹出键盘");
    
    NSDictionary *info = notification.userInfo;
    
    NSValue *value = [info valueForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGRect rect = [value CGRectValue];
    
    
    //    NSLog(@"------------keyboradHeight%f,self.frame.y%f",rect.size.height,rect.origin.y - rect.size.height - self.bottom);
    
    
    
    if ([UIScreen mainScreen].bounds.size.height - rect.size.height - self.height - 40 > 20 ) {
        
        self.y = [UIScreen mainScreen].bounds.size.height - rect.size.height - self.height - 40;
    }
    else
    {
        self.y = 20;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([self.typeId isEqualToString:@"1"]) {
        self.title.text = @"填入工作日志标题";
    }
    else
    {
        self.title.text = @"填入心得笔记标题";
        
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"typeId"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
