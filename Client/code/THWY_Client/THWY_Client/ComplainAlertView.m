//
//  ComplainAlertView.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ComplainAlertView.h"
@interface ComplainAlertView()
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
    
    UILabel * houseLabel = [UILabel labelWithTitle:@"房源：" frameX:left Height:houseSource.height];
    houseLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    [houseSource addSubview:houseLabel];
    
    NSArray *houseArray = [[[UDManager getUD] getUser] houses];
    
    self.houseSourceBtnArray = [NSMutableArray array];
    
    CGFloat houseBtnX = CGRectGetMaxX(houseLabel.frame);
    CGFloat houseBtnY = 0;
    CGFloat houseBtnW = self.width - CGRectGetMaxX(houseLabel.frame);
    CGFloat houseBtnH = 30;
    
    for (int i = 0; i < houseArray.count; i ++) {
        houseSource.height = 30 *houseArray.count;
        BlueRedioButton * btn = [[BlueRedioButton alloc]initWithFrame:CGRectMake(houseBtnX, houseBtnY, houseBtnW, houseBtnH)];
        
        HouseVO *house = houseArray[i];
        
        NSString *addressString = [NSString stringWithFormat:@"%@%@栋%@单元%@室",house.estate,house.block,house.unit,house.mph];
        
        btn.house = house;
        
        [btn initDefaultImageName:@"repaire_unselected"  choosedImageName:@"repaire_selected" title:addressString];
        if (i == 0) {
            [btn setChoosed];
        }
        
        [self.houseSourceBtnArray addObject:btn];
        
        [houseSource addSubview:btn];
        
        houseBtnY +=houseBtnH;
    }
    
    [self addSubOhterview:houseSource];

    //创建personView
    UIView *personView = [[UIView alloc]initWithFrame:CGRectMake(10,houseSource.bottom, self.width, 30)];
    
    [self addSubOhterview:personView];
    
    UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 30)];
    
    personLabel.text = @"投诉姓名：";
    
    personLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];

    [personView addSubview:personLabel];
    
    self.personTf = [[UITextField alloc]initWithFrame:CGRectMake(75,6, 120 , 18)];
    self.personTf.layer.borderWidth = 1;
    self.personTf.layer.borderColor = My_Color(236, 236, 236).CGColor;
    self.personTf.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    self.personTf.text = [[UDManager getUD] getUser].real_name;
    
    [personView addSubview:self.personTf];
    //创建手机号veiw
    
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(10,personView.bottom, self.width, 30)];
    
    [self addSubOhterview:phoneView];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    
    phoneLabel.text = @"投诉人电话：";
    
    phoneLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    [phoneView addSubview:phoneLabel];
    
    self.phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(90,6, 120, 18)];
    self.phoneTf.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    self.phoneTf.text = [[UDManager getUD] getUser].cellphone;
    
    self.phoneTf.layer.borderWidth = 1;
    self.phoneTf.layer.borderColor = My_Color(236, 236, 236).CGColor;
    self.phoneTf.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    [phoneView addSubview:self.phoneTf];
    
//    self.phone = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.person.frame), self.width - 10, 30)];
//    self.phone.text = [[UDManager getUD] getUser].cellphone;
//    self.phone.font = [UIFont systemFontOfSize:CONTENT_FONT];
//    
//    [self addSubOhterview:self.phone];
//    
    UIView *complainTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, phoneView.bottom, self.width - 10, 30)];
    
    [self addSubOhterview:complainTypeView];
    
    UILabel *complainLabel = [UILabel labelWithTitle:@"投诉类型：" frameX:10 Height:30];
    complainLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    
    [complainTypeView addSubview:complainLabel];
    
    CGFloat boderspace = 2;
    
    self.typeBtn = [[AlertButton alloc]initWithFrame:CGRectMake(complainLabel.right + boderspace , boderspace, 150, 26)];
    [self.typeBtn setTitle:@"请选择投诉类型" forState:UIControlStateNormal];
    
    [self.typeBtn setGetDataMethod:GetComplainType OriginY:0 OriginX:0];
    
    [complainTypeView addSubview:self.typeBtn];
    
//    self.textView = [[UITextView alloc]initWithFrame:
    self.textView.frame = CGRectMake(10, complainTypeView.bottom, self.width - 20, 100);
    
    self.textView.delegate = self;
//    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubOhterview:self.textView];
    
    [self setPlaceholder:@"请输入投诉内容："];
    
    CGRect rect = self.frame;
    
    rect.size.height = self.textView.bottom;
    
    self.frame = rect;
    
//    NSLog(@"self y %f",self.y);

}

- (void)updateWithComplainVo:(UserVO *)UserVO
{
//    HouseVO * house = [UserVO.houses firstObject];
//    NSString *addressString = [NSString stringWithFormat:@"%@%@栋%@单元%@室",house.estate,house.block,house.unit,house.mph];
//    self.houseSourceBtn.house = house;
//    [self.houseSourceBtn setTitle:addressString forState:UIControlStateNormal];
}

@end
