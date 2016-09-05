//
//  userAndPassWordTextField.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "userAndPassWordTextField.h"

@implementation userAndPassWordTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect rect = CGRectMake(self.height * 0.4, self.height * 0.3, self.height * 0.35,self.height * 0.4);
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x +=self.height *0.2;
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x +=self.height *0.2;
    return rect;
}

- (void)setLeftIcon:(NSString *)iconName placeholder:(NSString *)placeholder backgroundColor:(UIColor *)color
{
    self.backgroundColor = color;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    self.placeholder = placeholder;
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
}

@end
