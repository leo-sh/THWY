//
//  PersonInfoViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "Masonry/Masonry.h"
#import "ServicesManager.h"
#import "UIImageView+WebCache.h"
#import "PersonInfoLabel.h"
#import "ReviseBtn.h"
@interface PersonInfoViewController ()<UITextFieldDelegate>
@property UIView *topView;
@property UIView *bottomView;
@property UserVO *userInfo;
@property NSMutableArray *canUpdateInfo;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createIconAndBriefInfo];
    [self createDetailedInfoAndUpdateBtn];
    
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景2"]];
    
    self.canUpdateInfo = [NSMutableArray array];
    
    self.title = @"账号信息";
    
}

- (void)getData
{
    self.userInfo = [[UDManager getUD]getUser];
}

#pragma mark --创建头像和简要信息
- (void)createIconAndBriefInfo
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height * 0.18)];
//    self.topView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.topView];
    
    UIButton *icon = [[UIButton alloc]init];
    
    [self.topView addSubview:icon];
    
    CGFloat iconTop = self.topView.height * 0.1;
    CGFloat iconWidth = self.topView.height * 0.8;
    CGFloat iconHeight = iconWidth;
    CGFloat iconLeft = iconTop;
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconTop);
        make.width.mas_equalTo(iconWidth);
        make.height.mas_equalTo(iconHeight);
        make.left.mas_equalTo(iconLeft);
    }];
    
    icon.layer.cornerRadius = iconWidth/2;
    icon.layer.borderWidth = 3;
    icon.layer.borderColor = [UIColor whiteColor].CGColor;
    icon.clipsToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userInfo.avatar]]];
    
    [icon setImage:imageView.image forState:UIControlStateNormal];
    
    NSLog(@"%@",self.userInfo.avatar);
    
    NSLog(@"%@",self.userInfo.houses[0]);
    
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    
    [self.topView addSubview:nameLabel];
    
    CGFloat nameLabelTop = iconTop * 3;
    CGFloat nameLabelLeft = iconLeft * 1.2;
    CGFloat nameLabelRight = 0;
    CGFloat namelabelHeight = self.topView.height/5.f;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabelTop);
        make.left.equalTo(icon.mas_right).with.offset(nameLabelLeft);
        make.right.mas_equalTo(nameLabelRight);
        make.height.mas_equalTo(namelabelHeight);
    }];
    
    NSLog(@"%@",self.userInfo);
    nameLabel.text = self.userInfo.real_name;
    
    CGFloat font = namelabelHeight * 0.65;
    
    nameLabel.font = [UIFont systemFontOfSize: font];
    
    
    UILabel *addressLabel = [[UILabel alloc]init];
    
    [self.topView addSubview:addressLabel];
    
    CGFloat addressLabelTop = 0;
    CGFloat addressLabelLeft = iconLeft * 1.2;
    CGFloat addressLabelRight = 0;
    CGFloat addressLabelHeight = namelabelHeight;
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).with.offset(addressLabelTop);
        make.left.equalTo(icon.mas_right).with.offset(addressLabelLeft);
        make.right.mas_equalTo(addressLabelRight);
        make.height.mas_equalTo(addressLabelHeight);
    }];
    
    NSString *addressString = [NSString stringWithFormat:@"%@",self.userInfo.estate];
    
    addressLabel.text = addressString;
    addressLabel.font = [UIFont systemFontOfSize:font];

}

#pragma mark --创建详细信息和提交按钮
- (void)createDetailedInfoAndUpdateBtn
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height * 0.18, self.view.width, self.view.height * 0.82)];
    
//    self.bottomView.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.bottomView];
    
    NSArray *imageNameArray = @[@"姓名",@"电话",@"项目",@"部门",@"车牌号",@"登录账号",@"密码"];
    NSArray *labelTitleArry = @[@"业主姓名",@"联系电话",@"所在项目",@"房源信息",@"车牌号",@"登录账号",@"账号密码"];
    HouseVO *house = [self.userInfo.houses firstObject];
    NSString *houseAddress = [NSString stringWithFormat:@"%@",house.estate];
    NSArray *tfTextArray = @[self.userInfo.real_name,self.userInfo.cellphone,self.userInfo.estate,houseAddress,self.userInfo.car_number,self.userInfo.oname,[[UDManager getUD]getPassWord]];
    CGFloat labelHeight = self.bottomView.height/(imageNameArray.count + 3);
    CGFloat labelLeft = self.view.width * 0.02;
    CGFloat labelWidth = self.view.width - 2 *labelLeft;
    CGFloat labelY = 0;
    
    for (int i = 0; i < imageNameArray.count ; i ++) {
        
        PersonInfoLabel *label = [[PersonInfoLabel alloc]initWithFrame:CGRectMake(labelLeft, labelY , labelWidth , labelHeight)];
        
        [label setImageName:imageNameArray[i] Label:[NSString stringWithFormat:@"%@：",labelTitleArry[i]] TextField:tfTextArray[i] isEnable:YES];
        label.textField.delegate = self;
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self.bottomView addSubview: label];
        //将边框减掉
        labelY +=labelHeight - 1;
        
        switch (i) {
                
            case 1:
            case 4:
            case 5:
            case 6:
                [self.canUpdateInfo addObject:label];
                break;
            default:
                break;
        }
        
    }
    
    UIView *view = [self.canUpdateInfo lastObject];

    CGFloat revieseBtnY = CGRectGetMaxY(view.frame) + labelHeight*0.3;
    CGFloat reviseBtnX = self.view.width * 0.15;
    CGFloat reviseBtnW = self.view.width - reviseBtnX * 2;
    CGFloat reviseBtnH = labelHeight;
    
    ReviseBtn *reviseBtn = [[ReviseBtn alloc]initWithFrame:CGRectMake(reviseBtnX, revieseBtnY, reviseBtnW, reviseBtnH)];
    [reviseBtn setLeftImageView:@"修改" andTitle:@"修改"];
    [self.bottomView addSubview:reviseBtn];
    
    [reviseBtn addTarget:self action:@selector(clickReviseBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --点击修改按钮
- (void)clickReviseBtn
{
    [[ServicesManager getAPI]editUserInfo:[[self.canUpdateInfo[0] textField] text] carNumber:[[self.canUpdateInfo[1] textField] text] newUserName:[[self.canUpdateInfo[2] textField] text] newPassWord:[[self.canUpdateInfo[3] textField] text] onComplete:^(NSString *errorMsg) {
        if (errorMsg) {
            NSLog(@"%@",errorMsg);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
