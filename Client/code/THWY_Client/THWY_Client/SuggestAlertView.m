//
//  SuggestAlertView.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "SuggestAlertView.h"
#import "BlueRedioButton.h"
@interface SuggestAlertView()

@end
@implementation SuggestAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.title.text = @"发表建议/意见";
    
    UIView *suggestView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
    [self addSubOhterview:suggestView];
    
    UILabel * suggestLabel = [UILabel labelWithTitle:@"留言类别：" frameX:10 Height:suggestView.height];
    
    suggestLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    [suggestView addSubview:suggestLabel];
    
    CGFloat suggestBtn_W = self.width - CGRectGetMaxX(suggestLabel.frame)/2;
    
    self.suggestOne = [[BlueRedioButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(suggestLabel.frame), 0, suggestBtn_W , 40)];
    self.suggestOne.tag = 101;
    [self.suggestOne initDefaultImageName:@"repaire_unselected" choosedImageName:@"repaire_selected" title:@"建议"];
    [self.suggestOne setChoosed];
//    self.suggestOne.chooseStatu = YES;
    [suggestView addSubview:self.suggestOne];
    
    self.suggestTwo = [[BlueRedioButton alloc]initWithFrame:CGRectMake(150, 0, suggestBtn_W , 40)];
    self.suggestTwo.tag = 102;
    [self.suggestTwo initDefaultImageName:@"repaire_unselected" choosedImageName:@"repaire_selected" title:@"意见"];
    
    [suggestView addSubview:self.suggestTwo];
    
//    BlueRedioButton *suggestT = [[BlueRedioButton alloc]initWithFrame:CGRectMake(220, 0, suggestBtn_W , 30)];
//    
//    [suggestT initDefaultImageName:@"repaire_unselected" choosedImageName:@"repaire_selected" title:@"意见"];
//    
//    [suggestView addSubview:suggestT];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, suggestView.bottom + 1, self.width - 20, 100)];
    
    self.textView.delegate = self;
    
    [self addSubOhterview:self.textView];
    
    [self setPlaceholder:@"请输入内容"];
    
    self.height = self.textView.bottom + CONTENT_FONT;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
