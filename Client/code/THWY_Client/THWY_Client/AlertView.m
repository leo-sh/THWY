//
//  AlertView.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertView.h"
#import "UIView+TYAlertView.h"
#import "Masonry.h"
#define NavigationBarMaxY 66
@interface AlertView()
@property UIButton *leftBtn;
@property UIButton *rightBtn;
@property NSInteger number;
@property UILabel *placeholderLabel;
@end
@implementation AlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
        self.number = 1;
        self.title.text = @"";
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont systemFontOfSize:20];
        
        self.textView.text = @"";
        
        [self addSubview:self.title];
        
        CGFloat heighAndWidth = 50;
        
        self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, heighAndWidth, heighAndWidth)];
        [self.leftBtn setImage:[UIImage imageNamed:@"√"] forState:UIControlStateNormal];
        self.leftBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 15,  15 , 15);
        [self addSubview:self.leftBtn];

        self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.right - heighAndWidth - 10, 0, heighAndWidth, heighAndWidth)];
        
        [self.rightBtn setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
//        self.rightBtn.backgroundColor = [UIColor blackColor];
        
        self.rightBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 15,15, 15);

        
        [self.rightBtn addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.title.frame), self.width, 0.5)];
        label.backgroundColor = CellUnderLineColor;
        [self addSubview:label];
        
        self.textView = [[UITextView alloc]init];
        self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textView.textAlignment = NSTextAlignmentLeft;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];

        
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 7, 200, CONTENT_FONT)];
    self.placeholderLabel.text = placeholder;
//    self.placeholderLabel.backgroundColor = [UIColor blackColor];
    self.placeholderLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    [self.textView addSubview:self.placeholderLabel];
}

- (void)show
{
    [self showInWindow];
}

- (void)hide
{
    [self hideInWindow];
}

- (void)addSubOhterview:(UIView *)view
{
    if (self.number == 1) {
        CGRect rect = view.frame;
        
        rect.origin.y +=50.5;
        
        view.frame = rect;

    }
    if (view != self.textView) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) + 0.5, self.width, 0.5)];
        label.backgroundColor = CellUnderLineColor;
        [self addSubview:label];
    }
    [self addSubview:view];
    
    self.number ++;
}

- (void)addLeftBtnTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.leftBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)clickRight
{
    [self hide];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        self.placeholderLabel.alpha = 1;
    }
    else{
        self.placeholderLabel.alpha = 0;
    }

}

- (void)keyboardShow:(NSNotification *)notification
{
    NSLog(@"弹出键盘");
    
    NSDictionary *info = notification.userInfo;
    
    NSValue *value = [info valueForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGRect rect = [value CGRectValue];
    
    CGRect selfFrameRect = self.frame;
    
    NSLog(@"------------keyboradHeight%f,self.frame.y%f",rect.size.height,self.y);
    
    
    
    if (selfFrameRect.origin.y - rect.size.height >= 0) {
        
        selfFrameRect.origin.y -=rect.size.height;
    }
    else
    {
        selfFrameRect.origin.y = 20;
    }
    
    self.frame = selfFrameRect;
    
    
    
}

- (void)keyboardHide
{
    NSLog(@"收回键盘");
    
    [UIView animateWithDuration:0.2 animations:^{
        self.center = [self superview].center;
    }];
    
    
}

@end
