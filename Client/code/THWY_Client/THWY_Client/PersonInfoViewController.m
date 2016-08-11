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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
}

- (void)getData
{
    [SVProgressHUD showWithStatus:@"正在加载数据，请稍等······"];
    [[ServicesManager getAPI]getUserInfoOnComplete:^(NSString *errorMsg, UserVO *user) {
        self.userInfo = user;
        
        [self createIconAndBriefInfo];
        [self createDetailedInfoAndUpdateBtn];
        
    }];
    [SVProgressHUD dismiss];

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
    [icon addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    
    [icon addSubview:self.iconImageView];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userInfo.avatar]]];

    
//    NSLog(@"%@",self.userInfo.avatar);
//    
//    NSLog(@"%@",self.userInfo.houses[0]);
    
    
    
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
    
//    CGFloat font = namelabelHeight * 0.65;
    
    nameLabel.font = [UIFont systemFontOfSize: CONTENT_FONT];
    
    
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
    NSString *addressString = [NSString stringWithFormat:@"%@%@栋%@单元%@室",house.estate,house.block,house.unit,house.mph];
    addressLabel.text = addressString;
    addressLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];

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
    NSString *addressString = [NSString stringWithFormat:@"%@%@栋%@单元%@室",house.estate,house.block,house.unit,house.mph];
    NSArray *tfTextArray = @[self.userInfo.real_name,self.userInfo.cellphone,self.userInfo.estate,addressString,self.userInfo.car_number,self.userInfo.oname,[[UDManager getUD]getPassWord]];
    CGFloat labelHeight = self.bottomView.height/(imageNameArray.count + 3);
    CGFloat labelLeft = self.view.width * 0.02;
    CGFloat labelWidth = self.view.width - 2 *labelLeft;
    CGFloat labelY = 0;
    
    for (int i = 0; i < imageNameArray.count ; i ++) {
        
        PersonInfoLabel *label = [[PersonInfoLabel alloc]initWithFrame:CGRectMake(labelLeft, labelY , labelWidth , labelHeight)];
        
        [label setImageName:imageNameArray[i] Label:[NSString stringWithFormat:@"%@：",labelTitleArry[i]] TextField:tfTextArray[i]];
        label.textField.delegate = self;
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self.bottomView addSubview: label];
        //将边框减掉
        labelY +=labelHeight - 1;
        
        switch (i) {
                
            case 0:
            case 2:
            case 3:
                [label setNoEnable];
                label.textField.text = @"";
                label.textField.placeholder = tfTextArray[i];
                break;
            default:
                break;
        }
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
    [[ServicesManager getAPI]editUserInfo:[[self.canUpdateInfo[1] textField] text] carNumber:[[self.canUpdateInfo[4] textField] text] newUserName:[[self.canUpdateInfo[5] textField] text] newPassWord:[[self.canUpdateInfo[6] textField] text] onComplete:^(NSString *errorMsg) {
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
            NSLog(@"%@",errorMsg);
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }
    }];
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
    //设置代理对象
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:NO completion:nil];
}
//实现选取图片结束后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取选取的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [[ServicesManager getAPI]upLoadAvatar:image OnComplete:^(NSString *errorMsg, NSString *avatar) {
        
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            self.iconImageView.image = image;
        }
    }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
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
    [[NSNotificationCenter defaultCenter]postNotificationName:UIKeyboardWillShowNotification object:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardShow:(NSNotification *)notifation
{
    NSDictionary *info = notifation.userInfo;
    
    NSValue *value = [info valueForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGRect rect = [value CGRectValue];
    
    UITextField *textfield = notifation.object;
    
    NSLog(@"selfView bottom = %f keyboardHeight = %f textfield.bottom = %f",self.view.bottom,rect.size.height,textfield.bounds.origin.y);
    
    if (textfield.bottom + rect.size.height > self.view.bottom) {
        CGRect selfViewFrame = self.view.frame;
        
        selfViewFrame.origin.y -= self.view.bottom - rect.size.height;
        
        self.view.frame = selfViewFrame;
    }
    
}

- (void)keyboardHide
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect selfViewFrame = self.view.frame;
        
        selfViewFrame.origin.y = 66;
        
        self.view.frame = selfViewFrame;
    }];
    

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
