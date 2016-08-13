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
@interface PayInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@property NSArray *data;
@property NSArray *sectionHead;
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
    [SVProgressHUD showWithStatus:@"正在加载数据，请稍等······"];

    NSArray *sectionOneHead = @[@"业主姓名",@"所在楼层",@"房源信息",@"面积",@"缴费科目",@"收费标准",@"应缴金额",@"月数",@"实收金额",@"欠费金额"];
    NSArray *sectionTwoHead = @[@"缴纳时间",@"金额",@"操作人",@"备注"];
    self.sectionHead = @[sectionOneHead,sectionTwoHead];
    
    [[ServicesManager getAPI]getAFee:self.feeId onComplete:^(NSString *errorMsg, FeeVO *ad) {
        
        NSLog(@"213213")
        
        NSString *sourceInfo = [NSString stringWithFormat:@"%@栋%@单元%@室",ad.block,ad.unit,ad.mph];
        NSString *feeScale = [NSString stringConvertFloatString:ad.cls_fee addEndString:ad.cls_unit];
        NSString *totalPrice = [NSString stringConvertFloatString:ad.how_much addEndString:@"元"];
        NSString *actualString = [NSString stringConvertFloatString:ad.actual addEndString:@"元"];
        NSString *qianfeiString = [NSString stringWithFormat:@"%@元",ad.qian_fei];
        NSString *houseSizeString = [NSString stringConvertFloatString:ad.house_size addEndString:@"平方米"];
        
        NSArray *sectionOneData = @[ad.real_name,ad.estate_name,sourceInfo,houseSizeString,ad.cls_name,feeScale,totalPrice,@"",actualString,qianfeiString];
        
        FeeHistoryVO *item = [ad.fee_history firstObject];
        NSString *time = [NSString stringDateFromTimeInterval:[item.fee_time intValue] withFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSString *fee = [NSString stringConvertFloatString:item.fee addEndString:@"元"];
        
        NSArray *sectionTwoData = @[time,fee,item.real_name,item.remark];
        self.data = @[sectionOneData,sectionTwoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    }];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    TableViewFram
    
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",self.sectionHead[indexPath.section][indexPath.row],self.data[indexPath.section][indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        cell.backgroundColor = My_Color(254, 253, 236);
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];

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
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
