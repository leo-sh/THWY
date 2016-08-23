//
//  PersonInfoLabel.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PersonInfoLabel.h"
#import "Masonry.h"
@interface PersonInfoLabel()
@property UIImageView *imageView;
@property UILabel *label;
@property UILabel *infoLabel;
@end
@implementation PersonInfoLabel
- (instancetype)init
{
    if (self = [super init]) {
        
        self.imageView = [[UIImageView alloc]init];
        
        self.label = [[UILabel alloc]init];
        
        self.textField = [[UITextField alloc]init];
        
        self.infoLabel = [[UILabel alloc]init];
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self addSubview:self.textField];
        [self addSubview:self.infoLabel];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc]init];

        self.label = [[UILabel alloc]init];
        self.infoLabel = [[UILabel alloc]init];
        self.textField = [[UITextField alloc]init];
        self.textField.font = FontSize(CONTENT_FONT);
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
        self.textField.clipsToBounds = NO;

        UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickClear) forControlEvents:UIControlEventTouchUpInside];
        [right addSubview:btn];
        self.textField.rightView = right;
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self addSubview:self.textField];
        [self addSubview:self.infoLabel];
    }
    return self;
}


- (void)updateFrame:(NSString *)string
{
    NSLog(@"%f-%f-%f-%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    
    CGFloat topOffSet = self.frame.size.height * 0.3;
    CGFloat imageViewWidthAndHeight = self.frame.size.height * 0.4;
    CGFloat imageViewLeft = self.frame.size.height * 0.2;
    NSLog(@"labelWidth :%f",self.label.width);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topOffSet);
        make.size.mas_equalTo(CGSizeMake(imageViewWidthAndHeight, imageViewWidthAndHeight));
        make.left.mas_equalTo(imageViewLeft);
    }];
    
    CGFloat labelLeft = imageViewLeft;
    CGFloat labelWidth = self.label.width;
    CGFloat labelHeight = self.height;
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(topOffSet);
        make.size.mas_equalTo(CGSizeMake(labelWidth, labelHeight));
        make.left.equalTo(self.imageView.mas_right).with.offset(labelLeft);
        make.centerY.mas_equalTo(self.imageView.centerY);
    }];
    
    self.label.font = FontSize(CONTENT_FONT);
//    self.label.backgroundColor = [UIColor grayColor];
    if ([string isEqualToString:@"tf"]) {
        CGFloat tfHeight = self.height;
        CGFloat tfWidht = self.frame.size.width - labelLeft -labelWidth -imageViewWidthAndHeight -imageViewLeft;
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.imageView.centerY);
            make.size.mas_equalTo(CGSizeMake(tfWidht, tfHeight));
            make.left.equalTo(self.label.mas_right).with.offset(0);
        }];
        
        [self.infoLabel removeFromSuperview];

    }
    else
    {
        CGFloat lbHeight = self.height;
        CGFloat lbWidht = self.frame.size.width - labelLeft -labelWidth -imageViewWidthAndHeight -imageViewLeft;
        
        [self.textField removeFromSuperview];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.imageView.centerY);
            make.size.mas_equalTo(CGSizeMake(lbWidht, lbHeight));
            make.left.equalTo(self.label.mas_right).with.offset(0);
        }];

        CGFloat fontSizeWidth = [self.infoLabel.text sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT] maxSize:CGSizeMake(4000, 4000)].width;
        if (fontSizeWidth > lbWidht) {
            self.height *=2;
            [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.height);
            }];
            [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(topOffSet + self.height/4);
            }];
            self.infoLabel.numberOfLines = 0;
        }
        
        

    }
    
    self.clipsToBounds = NO;

}

- (void)setImageName:(NSString *)imageName Label:(NSString *)title TextField:(NSString *)text
{
    
    self.imageView.image = [UIImage imageNamed:imageName];
    
    self.label.text = title;
    self.label.width = GetContentWidth(title, CONTENT_FONT);
    
    self.textField.text = text;
    
    [self updateFrame:@"tf"];

}

- (void)setImageName:(NSString *)imageName Label:(NSString *)title infoTitle:(NSString *)infotitle
{
    self.imageView.image = [UIImage imageNamed:imageName];
    
    self.label.width = GetContentWidth(title, CONTENT_FONT);

    
    self.label.text = title;
    
    self.infoLabel.text = infotitle;
    
    self.infoLabel.font = FontSize(CONTENT_FONT);
    
    self.infoLabel.textColor = CellUnderLineColor;

    [self updateFrame:@"lb"];

}

- (void)setNoEnable
{
    [self.textField setUserInteractionEnabled:NO];
    self.textField.rightView = nil;
}

- (void)clickClear
{
    self.textField.text = @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
