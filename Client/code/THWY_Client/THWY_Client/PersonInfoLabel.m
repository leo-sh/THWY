//
//  PersonInfoLabel.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/29.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PersonInfoLabel.h"
#import "Masonry/Masonry.h"
#import "HouseVO.h"
@interface PersonInfoLabel()
@property UIImageView *imageView;
@property UILabel *label;
@property UILabel *infoLabel;
@property NSArray *labelInfos;
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
    
    CGFloat topOffSet = 10;
    CGFloat imageViewWidthAndHeight = 20;
    CGFloat imageViewLeft = self.frame.size.height * 0.2;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height/2 - imageViewWidthAndHeight/2);
        make.size.mas_equalTo(CGSizeMake(imageViewWidthAndHeight, imageViewWidthAndHeight));
        make.left.mas_equalTo(imageViewLeft);
        
    }];
    
    CGFloat labelLeft = imageViewLeft;
    CGFloat labelWidth = CONTENT_FONT * 5;
    CGFloat labelHeight = 20;
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(labelWidth, labelHeight));
        make.left.equalTo(self.imageView.mas_right).with.offset(labelLeft);
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
    else if([string isEqualToString:@"lb"])
    {
        CGFloat lbHeight = self.height;
        CGFloat lbWidht = self.frame.size.width - labelLeft -labelWidth -imageViewWidthAndHeight -imageViewLeft;
        
        [self.textField removeFromSuperview];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.imageView.centerY);
            make.size.mas_equalTo(CGSizeMake(lbWidht, lbHeight));
            make.left.equalTo(self.label.mas_right).with.offset(0);
        }];
        
        self.infoLabel.numberOfLines = 1;
    }
    else
    {
        [self.textField removeFromSuperview];
        
        CGFloat lbHeight = CONTENT_FONT;
        CGFloat lbLeft = 50;
        CGFloat lbTop = 0;
        CGFloat lbWidth = self.width - labelLeft -labelWidth -imageViewWidthAndHeight -imageViewLeft;
        for (int i = 0; i < self.labelInfos.count; i ++) {
            
            lbTop = self.height - 5 + (lbHeight + 5) * i ;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(lbLeft, lbTop, lbWidth, lbHeight)];
            
            [self addSubview:label];
            
            if (i == 0) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.label.mas_top);
                    make.width.mas_equalTo(lbWidth);
                    make.height.mas_equalTo(self.label.mas_height);
                    make.left.equalTo(self.label.mas_right).with.offset(0);
                }];
            }else
            {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.label.mas_top).offset(i*(lbHeight + 10/375.0*My_ScreenW));
                    make.width.mas_equalTo(lbWidth);
                    make.height.mas_equalTo(self.label.mas_height);
                    make.left.equalTo(self.label.mas_right).with.offset(0);
                }];
            }
            
            HouseVO *house = self.labelInfos[i];
            
             NSString *addressString = [NSString stringWithFormat:@"%@·%@栋%@单元%@室",house.estate,house.block,house.unit,house.mph];
            
            label.text = addressString;
            label.font = FontSize(CONTENT_FONT);
            label.textColor = CellUnderLineColor;
            if (i == self.labelInfos.count - 1) {
                self.height = self.height/2 - imageViewWidthAndHeight/2 + i*(lbHeight + 10/375.0*My_ScreenW) + 20/375.0*My_ScreenW + lbHeight - 0.5;
            }
        }
    }
    
    self.clipsToBounds = NO;

}

- (void)setImageName:(NSString *)imageName Label:(NSString *)title TextField:(NSString *)text
{
    
    self.imageView.image = [UIImage imageNamed:imageName];
    
    self.label.text = title;
    
    self.textField.text = text;
    
    [self updateFrame:@"tf"];

}

- (void)setImageName:(NSString *)imageName Label:(NSString *)title infoTitle:(NSString *)infotitle
{
    self.imageView.image = [UIImage imageNamed:imageName];
    
    self.label.text = title;
    
    self.infoLabel.text = infotitle;
    
    self.infoLabel.font = FontSize(CONTENT_FONT);
    
    self.infoLabel.textColor = CellUnderLineColor;

    [self updateFrame:@"lb"];

}

- (void)setImageName:(NSString *)imageName Label:(NSString *)title Array:(NSArray *)array
{
    self.imageView.image = [UIImage imageNamed:imageName];
    
    self.label.text = title;
    
    self.infoLabel.font = FontSize(CONTENT_FONT);
    
    self.infoLabel.textColor = CellUnderLineColor;
    
    self.labelInfos = array;
    
    [self updateFrame:@"lbs"];
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
