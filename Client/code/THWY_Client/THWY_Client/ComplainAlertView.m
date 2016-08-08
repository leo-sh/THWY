//
//  ComplainAlertView.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ComplainAlertView.h"
#import "BlueRedioButton.h"
#import "AlertButton.h"
@interface ComplainAlertView()
@property UILabel *person;
@property UILabel *phone;
@end
@implementation ComplainAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    
    self.title.text = @"我要投诉";
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat left = 10;
    
    UIView *houseSource = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 30)];
    [self addSubOhterview:houseSource];
    
    UILabel * houseLabel = [UILabel labelWithTitle:@"房源：" frameX:left Height:houseSource.height];
    houseLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    [houseSource addSubview:houseLabel];
    
    self.houseSourceBtn = [[BlueRedioButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(houseLabel.frame), 0, self.width - CGRectGetMaxX(houseLabel.frame), 30)];
    [self.houseSourceBtn initDefaultImageName:@"repaire_unselected"  choosedImageName:@"repaire_selected"];
    [houseSource addSubview:self.houseSourceBtn];
    
    self.person = [[UILabel alloc]initWithFrame:CGRectMake(10,houseSource.bottom, self.width, 30)];
    self.person.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    [self addSubOhterview:self.person];
    
    self.phone = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.person.frame), self.width - 10, 30)];
    self.phone.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    [self addSubOhterview:self.phone];
    
    UIView *complainTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.phone.bottom, self.width - 10, 30)];
    
    [self addSubOhterview:complainTypeView];
    
    UILabel *complainLabel = [UILabel labelWithTitle:@"投诉类型：" frameX:10 Height:30];
    complainLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    [complainTypeView addSubview:complainLabel];
    
    CGFloat boderspace = 2;
    
    AlertButton *typeBtn = [[AlertButton alloc]initWithFrame:CGRectMake(complainLabel.right + boderspace , boderspace, 150, 26)];
    [typeBtn setTitle:@"请选择投诉类型" forState:UIControlStateNormal];
    
    [complainTypeView addSubview:typeBtn];
    
//    self.textView = [[UITextView alloc]initWithFrame:
    self.textView.frame = CGRectMake(10, complainTypeView.bottom, self.width - 20, 100);
    
    self.textView.delegate = self;
//    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubOhterview:self.textView];
    
    CGRect rect = self.frame;
    
    rect.size.height = self.textView.bottom;
    
    self.frame = rect;
    
//    NSLog(@"self y %f",self.y);

}

- (void)updateCenter:(CGPoint)point
{
    self.center = point;
}

- (void)updateWithComplainVo:(UserVO *)UserVO
{
    self.person.text = [NSString stringWithFormat:@"投诉姓名：%@",UserVO.real_name];
    self.phone.text = [NSString stringWithFormat:@"投诉人电话：%@",UserVO.cellphone];
    HouseVO * house = [UserVO.houses firstObject];
    NSString *addressString = [NSString stringWithFormat:@"%@%@栋%@单元%@室",house.estate,house.block,house.unit,house.mph];
    self.houseSourceBtn.house = house;
    [self.houseSourceBtn setTitle:addressString forState:UIControlStateNormal];
}

@end
