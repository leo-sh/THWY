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
#import "TYAlertController.h"
#import "TYAlertView.h"
@interface PersonInfoViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property UIView *topView;
@property UIView *bottomView;
@property UserVO *userInfo;
@property NSMutableArray *canUpdateInfo;
@property UIImageView *iconImageView;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];

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
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    
    if ([ServicesManager getAPI].status == NotReachable) {
        self.userInfo = [[UDManager getUD]getUser];
        [self createIconAndBriefInfo];
        [self createDetailedInfoAndUpdateBtn];
        
        [SVProgressHUD dismiss];
    }
    else
    {
        [[ServicesManager getAPI]getUserInfoOnComplete:^(NSString *errorMsg, UserVO *user) {
            
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];

            }
            else
            {
                self.userInfo = user;
                
                [self createIconAndBriefInfo];
                [self createDetailedInfoAndUpdateBtn];
                
                [SVProgressHUD dismiss];
            }
            
        }];
    }
    
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
//    icon.layer.borderWidth = 3;
//    icon.layer.borderColor = [UIColor whiteColor].CGColor;
    icon.clipsToBounds = YES;
    [icon addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    
    [icon addSubview:self.iconImageView];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userInfo.avatar]]];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    
    [self.topView addSubview:nameLabel];
    
    CGFloat nameLabelTop = iconTop * 2;
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
    
//    CGFloat font = namelabelHeight * 0.65;
    
    nameLabel.font = FontSize(CONTENT_FONT);
    
    
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
    HouseVO *house = self.userInfo.houses[0];
    NSString *addressString = [NSString stringWithFormat:@"%@",house.estate];
    addressLabel.text = addressString;
    addressLabel.font = FontSize(CONTENT_FONT);
    
    NSString *detailString = [NSString stringWithFormat:@"%@栋%@单元%@室",house.block,house.unit,house.mph];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    
    [self.topView addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.equalTo(addressLabel.mas_bottom).with.offset(addressLabelTop);
        make.left.equalTo(icon.mas_right).with.offset(addressLabelLeft);
        make.right.mas_equalTo(addressLabelRight);
        make.height.mas_equalTo(addressLabelHeight);
    }];
    
    detailLabel.text = detailString;
    detailLabel.font = FontSize(CONTENT_FONT);
    

}

#pragma mark --创建详细信息和提交按钮
- (void)createDetailedInfoAndUpdateBtn
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height * 0.18, self.view.width, self.view.height * 0.82)];
    
    self.bottomView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.bottomView];
    
    NSArray *imageNameArray = @[@"姓名",@"电话",@"项目",@"部门",@"车牌号",@"登录账号",@"密码"];
    NSArray *labelTitleArry = @[@"业主姓名",@"联系电话",@"所在项目",@"房源信息",@"车牌号",@"登录账号",@"账号密码"];
    HouseVO *house = [self.userInfo.houses firstObject];
    NSString *addressString = [NSString stringWithFormat:@"%@·%@栋%@单元%@室",house.estate,house.block,house.unit,house.mph];
    NSArray *tfTextArray = @[self.userInfo.real_name,self.userInfo.cellphone,self.userInfo.estate,addressString,self.userInfo.car_number,self.userInfo.oname,[[UDManager getUD]getPassWord]];
    CGFloat labelHeight = self.bottomView.height/(imageNameArray.count + 3);
    CGFloat labelLeft = self.view.width * 0.02;
    CGFloat labelWidth = self.view.width - 2 *labelLeft;
    CGFloat labelY = 0;
    
    PersonInfoLabel *lastLabel;
    
    for (int i = 0; i < imageNameArray.count ; i ++) {
        
        if (lastLabel) {
            labelY = lastLabel.bottom - 1;
        }
        
        PersonInfoLabel *label = [[PersonInfoLabel alloc]initWithFrame:CGRectMake(labelLeft, labelY , labelWidth , labelHeight)];
        
        switch (i)
        {
                
            case 0:
            case 2:
            case 3:
            {
                [label setImageName:imageNameArray[i] Label:[NSString stringWithFormat:@"%@：",labelTitleArry[i]] infoTitle:tfTextArray[i]];

            }
                break;
            default:
                [label setImageName:imageNameArray[i] Label:[NSString stringWithFormat:@"%@：",labelTitleArry[i]] TextField:tfTextArray[i]];
                break;
                
        }
        
        label.backgroundColor = WhiteAlphaColor;
        label.textField.delegate = self;
        label.textField.textColor = CellUnderLineColor;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = CellUnderLineColor.CGColor;
        
        [self.bottomView addSubview: label];
        //将边框减掉
//        labelY +=labelHeight - 1;
        
        if (i == imageNameArray.count - 1) {
            label.textField.secureTextEntry = YES;
//            label.textField.text = @"";
//            label.textField.rightViewMode = UITextFieldViewModeNever;
            label.textField.font = [UIFont systemFontOfSize:12];
        }
        
        lastLabel = label;

        [self.canUpdateInfo addObject:label];

        
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
    BOOL isChanged = NO;
    UserVO* user = [[UDManager getUD] getUser];
    if (![user.cellphone isEqualToString:[[self.canUpdateInfo[1] textField] text]]) {
        isChanged = YES;
    }
    
    if (![user.car_number isEqualToString:[[self.canUpdateInfo[4] textField] text]]) {
        isChanged = YES;
    }
    
    if (![[[UDManager getUD] getUserName] isEqualToString:[[self.canUpdateInfo[5] textField] text]]) {
        isChanged = YES;
    }
    
    if (![[[UDManager getUD] getPassWord] isEqualToString:[[self.canUpdateInfo[6] textField] text]]) {
        isChanged = YES;
    }
    
    if (isChanged) {
        
        if ([[[self.canUpdateInfo[5] textField] text] length] == 0) {
            [SVProgressHUD showWithStatus:@"账号不能为空"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        else if([[[self.canUpdateInfo[6] textField] text] length] == 0)
        {
            [SVProgressHUD showWithStatus:@"密码不能为空"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });

        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改个人信息" message:@"是否确定修改？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
                [[ServicesManager getAPI]editUserInfo:[[self.canUpdateInfo[1] textField] text] carNumber:[[self.canUpdateInfo[4] textField] text] newUserName:[[self.canUpdateInfo[5] textField] text] newPassWord:[[self.canUpdateInfo[6] textField] text] onComplete:^(NSString *errorMsg) {
                    if (errorMsg) {
                        [SVProgressHUD showErrorWithStatus:errorMsg];
                        NSLog(@"%@",errorMsg);
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:@"修改成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }];
            
            UIAlertAction *disagreeAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction: agreeAction];
            [alertController addAction: disagreeAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        }
           else{
        return;
    }
    
}

#pragma mark --点击头像
- (void)clickIcon
{
    TYAlertView *alertView = [[TYAlertView alloc]init];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"拍照" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"从相册选择" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self loadImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)loadImageWithType:(UIImagePickerControllerSourceType)type
{
    //创建容器
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    //设置操作类型
    ipc.sourceType = type;
    ipc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    ipc.allowsEditing = YES;
    //设置代理对象
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}
//实现选取图片结束后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取选取的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    [[ServicesManager getAPI]upLoadAvatar:image OnComplete:^(NSString *errorMsg, NSString *avatar) {
        
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"上传成功"];
            self.iconImageView.image = image;
        }
    }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rightViewModeNever" object:nil];
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
