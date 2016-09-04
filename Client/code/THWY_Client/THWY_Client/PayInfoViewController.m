//
//  PayInfoViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PayInfoViewController.h"
#import "Masonry.h"
#import "ServicesManager.h"
#import "OrderVC.h"

@interface PayInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property NSMutableArray *data;
@property NSMutableArray *sectionHead;

@property UIButton* payBtn;

@property FeeVO* fee;
@end

@implementation PayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"缴费详情";
    UIImage *image = [UIImage imageNamed:@"背景2"];
    self.view.layer.contents = (id)image.CGImage;
}

- (void)getData
{
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    
    [[ServicesManager getAPI]getAFee:self.feeId onComplete:^(NSString *errorMsg, FeeVO *ad) {
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        
        self.fee = ad;
        NSArray *sectionOneHead = @[@"业主姓名",@"所在楼盘",@"房源信息",@"面积",@"缴费科目",@"收费标准",@"缴费起止期",@"应缴金额",@"实收金额",@"欠费金额"];
        
        self.sectionHead = [[NSMutableArray alloc]initWithObjects:sectionOneHead, nil];
        for (int i = 0;  i< ad.fee_history.count; i++) {
            NSArray *sectionTwoHead = @[@"票据号",@"收费人",@"缴纳时间",@"金额",@"操作人",@"备注"];
            [self.sectionHead addObject:sectionTwoHead];
        }
        
        NSString *sourceInfo = [NSString stringWithFormat:@"%@栋%@单元%@室",ad.block,ad.unit,ad.mph];
        NSString *feeScale = [NSString stringConvertFloatString:ad.cls_fee addEndString:ad.cls_unit];
        NSString *totalPrice = [NSString stringConvertFloatString:ad.how_much addEndString:@"元"];
        NSString *actualString = [NSString stringConvertFloatString:ad.actual addEndString:@"元"];
        NSString *qianfeiString = [NSString stringWithFormat:@"%@元",ad.qian_fei];
        NSString *houseSizeString = [NSString stringConvertFloatString:ad.house_size addEndString:@"平方米"];
        
        NSString *beginT = [NSString stringDateFromTimeInterval:[ad.begin_time intValue] withFormat:@"YYYY/MM/dd"];
        NSString *endT = [NSString stringDateFromTimeInterval:[ad.end_time intValue] withFormat:@"YYYY/MM/dd"];
        
        NSString *payCycle = [NSString stringWithFormat:@"%@~%@",beginT,endT];
        
        NSArray *sectionOneData = @[ad.real_name,ad.estate_name,sourceInfo,houseSizeString,ad.cls_name,feeScale,payCycle,totalPrice,actualString,qianfeiString];
        
        self.data = [[NSMutableArray alloc]initWithObjects:sectionOneData, nil];
        for (FeeHistoryVO* item in ad.fee_history) {
            actualString = [NSString stringConvertFloatString:item.fee addEndString:@"元"];
            NSString *time = [NSString stringDateFromTimeInterval:[item.fee_time intValue] withFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSArray *sectionTwoData = @[item.invoice_no,item.cashier_name,time,actualString,item.real_name,item.remark];
            
            [self.data addObject:sectionTwoData];
        }
        
        [self createUI];
        [self.tableView reloadData];
        
        if (ad.st == NonPayment || ad.st == Part ) {
            self.payBtn.enabled = YES;
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = CellUnderLineColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-10/375.0*My_ScreenW);
    }];
    
    self.payBtn = [[UIButton alloc]init];
    [self.payBtn setBackgroundImage:[UIImage createImageWithColor:My_NAV_BG_Color] forState:UIControlStateNormal];
    [self.payBtn setTitle:@"我要缴费" forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = FontSize(CONTENT_FONT + 4);
    self.payBtn.enabled = NO;
    self.payBtn.clipsToBounds = YES;
    self.payBtn.layer.cornerRadius = 5/375.0*My_ScreenW;
    [self.payBtn addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40/375.0*My_ScreenW);
        make.width.mas_equalTo(My_ScreenW/3*2);
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.bottom.mas_equalTo(-10/375.0*My_ScreenW);
    }];
}

-(void)showOrder
{
    OrderVC* orderVC = [[OrderVC alloc]init];
    orderVC.fee = self.fee;
    
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionHead[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionHead.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",self.sectionHead[indexPath.section][indexPath.row],self.data[indexPath.section][indexPath.row]];
    
   NSString *cellText = [NSString stringWithFormat:@"%@：%@",self.sectionHead[indexPath.section][indexPath.row],self.data[indexPath.section][indexPath.row]];
    
    NSMutableAttributedString *cellAttrText = [[NSMutableAttributedString alloc]initWithString:cellText];
    
    NSRange headSR = [cellText rangeOfString:@"："];
    if (headSR.location != NSNotFound) {
    
        [cellAttrText addAttribute:NSForegroundColorAttributeName value:My_Color(202, 202, 207) range:NSMakeRange(headSR.location + headSR.length, cellAttrText.length - headSR.location - headSR.length)];
        
        cell.textLabel.attributedText = cellAttrText;
    }
    
    cell.textLabel.font = FontSize(CONTENT_FONT);
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section != 0) {
        cell.backgroundColor = My_Color(254, 253, 236);
    }
    else
    {
        cell.backgroundColor = WhiteAlphaColor;

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 2)];
    imageView.image = [UIImage imageNamed:@"彩条"];
    
    return imageView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.tableView.numberOfSections - 1) {
        return 50/375.0*My_ScreenW;
    }
    return 0.01;
}

@end
