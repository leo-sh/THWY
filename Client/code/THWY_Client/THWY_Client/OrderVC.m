//
//  OrderVC.m
//  THWY_Client
//
//  Created by Mr.S on 16/9/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "OrderVC.h"

typedef enum : NSInteger {
    None = -1,
    AliPay,
    WXPay,
    JFPay,
} PayType;

@interface OrderVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property UITableView* tableView;
@property PayType type;

@property UIButton* payBtn;
@property UITextField* payNumTf;

@property NSArray* titleArr;
@property NSArray* dataArr;
@property NSArray* payIcon;
@property NSArray* payTitle;

@property NSArray<UIImageView *>* selectArr;

@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self creatUI];
}

-(void)initData
{
    self.type = AliPay;
    self.titleArr = @[@"业主姓名：",@"所在楼盘：",@"房源信息：",@"核算面积：",@"缴费科目：",@"收费标准：",@"应缴金额：",@"实收金额：",@"欠费金额：",@"本次缴费："];
    
    NSString *sourceInfo = [NSString stringWithFormat:@"%@栋%@单元%@室",self.fee.block,self.fee.unit,self.fee.mph];
    NSString *houseSizeString = [NSString stringConvertFloatString:self.fee.house_size addEndString:@"平方米"];
    NSString *feeScale = [NSString stringConvertFloatString:self.fee.cls_fee addEndString:self.fee.cls_unit];
    NSString *totalPrice = [NSString stringConvertFloatString:self.fee.how_much addEndString:@"元"];
    NSString *actualString = [NSString stringConvertFloatString:self.fee.actual addEndString:@"元"];
    NSString *qianfeiString = [NSString stringWithFormat:@"%@元",self.fee.qian_fei];
    
    self.dataArr = @[self.fee.real_name,self.fee.estate_name,sourceInfo,houseSizeString,self.fee.cls_name,feeScale,totalPrice,actualString,qianfeiString];
    
    self.payIcon = @[@"zhifubao",@"weixin",@"jifen"];
    self.payTitle = @[@"支付宝",@"微信支付",@"积分支付"];
}

-(void)creatUI
{
    self.title = @"我要缴费";
    UIImage *image = [UIImage imageNamed:@"背景2"];
    self.view.layer.contents = (id)image.CGImage;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = My_clearColor;
    self.tableView.separatorColor = CellUnderLineColor;
    [self.tableView addTarget:self action:@selector(tapOnTableView)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-10/375.0*My_ScreenW);
    }];
    
    self.payBtn = [[UIButton alloc]init];
    [self.payBtn setBackgroundImage:[UIImage createImageWithColor:My_NAV_BG_Color] forState:UIControlStateNormal];
    [self.payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = FontSize(CONTENT_FONT + 4);
    self.payBtn.clipsToBounds = YES;
    self.payBtn.layer.cornerRadius = 20/375.0*My_ScreenW;
    [self.payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40/375.0*My_ScreenW);
        make.width.mas_equalTo(self.tableView.mas_width).offset(-15/375.0*My_ScreenW);
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.bottom.mas_equalTo(self.tableView.mas_bottom);
    }];
}

-(void)pay
{
    [self.payNumTf endEditing:YES];
    if (self.type == None) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
    }else if ([self.payNumTf.text floatValue] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入缴费金额"];
    }else
    {
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        
        if (indexPath.row != self.titleArr.count - 1) {
            if (self.payNumTf.superview == cell.contentView) {
                [self.payNumTf removeFromSuperview];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.titleArr[indexPath.row],self.dataArr[indexPath.row]];
        }else
        {
            cell.textLabel.text = self.titleArr[indexPath.row];
            
            if (!self.payNumTf) {
                self.payNumTf = [[UITextField alloc]initWithFrame:CGRectMake([self.titleArr[indexPath.row] sizeWithFont:cell.textLabel.font maxSize:cell.textLabel.frame.size].width + 20/375.0*My_ScreenW, 10/375.0*My_ScreenW, 100, 30/375.0*My_ScreenW)];
                self.payNumTf.clipsToBounds = YES;
                self.payNumTf.layer.cornerRadius = 5/375.0*My_ScreenW;
                self.payNumTf.layer.borderWidth = 1;
                self.payNumTf.layer.borderColor = CellUnderLineColor.CGColor;
                self.payNumTf.leftViewMode = UITextFieldViewModeAlways;
                self.payNumTf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5/375.0*My_ScreenW, 0)];
                self.payNumTf.width = My_ScreenW - 34/375.0*My_ScreenW - self.payNumTf.x;
                self.payNumTf.placeholder = @"请输入缴费金额";
                self.payNumTf.center = CGPointMake(self.payNumTf.center.x, 45/375.0*My_ScreenW/2);
                self.payNumTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                self.payNumTf.delegate = self;
            }
            [cell.contentView addSubview:self.payNumTf];
        }
        
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payCell"];
            cell.backgroundColor = My_Color(254, 253, 236);
            
            UIImageView* imv = [[UIImageView alloc]initWithFrame:CGRectMake(My_ScreenW - 50/375.0*My_ScreenW, 0, 22/375.0*My_ScreenW, 10/375.0*My_ScreenW)];
            imv.height = imv.width;
            imv.tag = 100;
            imv.highlightedImage = [UIImage imageNamed:@"danxuan_pre"];
            imv.image = [UIImage imageNamed:@"danxuan_nor"];
            imv.center = CGPointMake(imv.center.x, 45/375.0*My_ScreenW / 2);
            [imv addTarget:self action:@selector(changePayType:)];
            [cell addSubview:imv];
        }
        
        UIImageView* imv = [cell viewWithTag:100];
        if (self.type == indexPath.row) {
            imv.highlighted = YES;
        }else
        {
            imv.highlighted = NO;
        }
        
        cell.imageView.image = [UIImage imageNamed:self.payIcon[indexPath.row]];
        cell.textLabel.text = self.payTitle[indexPath.row];
    }
    cell.textLabel.font = FontSize(CONTENT_FONT + 1);
    cell.textLabel.textColor = CellTextColor;
    cell.textLabel.backgroundColor = My_clearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = (indexPath.section+1) * 100 + indexPath.row;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == tableView.numberOfSections - 1) {
        return 60/375.0*My_ScreenW;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableView.width * 6/ 624;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45/375.0*My_ScreenW;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView* imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"彩条"]];
    return imv;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.payNumTf endEditing:YES];
}

-(void)tapOnTableView
{
    if (!self.payNumTf.isExclusiveTouch) {
        [self.payNumTf endEditing:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.payNumTf.isExclusiveTouch) {
        [self.payNumTf endEditing:YES];
    }
}

-(void)changePayType:(UITapGestureRecognizer* )tap
{
    if (tap.view.superview && [tap.view.superview isKindOfClass:[UITableViewCell class]]) {
        self.type = tap.view.superview.tag - 200;
        [self.tableView reloadData];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* resultStr = @"";
    if (string.length == 0) {
        if (textField.text.length > 0) {
            
            resultStr = [textField.text substringToIndex:textField.text.length - 1];
        }else
        {
            resultStr = @"";
        }
        return YES;
    }else{
        resultStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    return [self checkStr:resultStr];
}

-(BOOL)checkStr:(NSString *)resultStr
{
    if ([resultStr componentsSeparatedByString:@"."].count > 2) {
        return NO;
    }
    
    if ([[resultStr substringFromIndex:resultStr.length - 1] isEqualToString:@"."]) {
        return YES;
    }
    
    if ([resultStr rangeOfString:@"."].location == NSNotFound) {
        if (![resultStr isEqualToString:[NSString stringWithFormat:@"%d",[resultStr intValue]]]) {
            return NO;
        }
    }else
    {
        if (resultStr.length > [resultStr rangeOfString:@"."].location + 3) {
            return NO;
        }
        
        if (![resultStr isEqualToString:[[NSString stringWithFormat:@"%.2f",[resultStr floatValue]] substringToIndex:resultStr.length]]) {
            return NO;
        }
    }
    
    if ([resultStr floatValue] == 0) {
        return NO;
    }
    
    if ([resultStr floatValue] > [self.fee.qian_fei floatValue]) {
        [self.payNumTf endEditing:YES];
        self.payNumTf.text = [NSString stringWithFormat:@"%.2f 元",[self.fee.qian_fei floatValue]];
        return YES;
    }

    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text floatValue] != 0) {
        
        if ([textField.text floatValue] > [self.fee.qian_fei floatValue]) {
            textField.text = [NSString stringWithFormat:@"%.2f 元",[self.fee.qian_fei floatValue]];
        }else
        {
            textField.text = [NSString stringWithFormat:@"%.2f 元",[textField.text floatValue]];
        }
    }
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
