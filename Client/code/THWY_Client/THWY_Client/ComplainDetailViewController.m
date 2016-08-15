//
//  ComplainDetailViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ComplainDetailViewController.h"
#import "ServicesManager.h"
#import "Masonry.h"
@interface ComplainDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSArray *data;
@property UITableView *tableView;
@property NSArray *cellOneData;
@property NSArray *cellThreeData;
@end

@implementation ComplainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"投诉详情";
    UIImage *image = [UIImage imageNamed:@"背景2"];
    self.view.layer.contents = (id)image.CGImage;
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.cellOneData = @[@"投诉类型",@"所在项目",@"投诉人",@"联系电话"];
    self.cellThreeData = @[@"投诉状态",@"投诉日期"];
    
}

- (void)getData
{    [SVProgressHUD showWithStatus:@"正在加载数据，请稍等······"];

    [[ServicesManager getAPI] getAComplaint:self.complianId onComplete:^(NSString *errorMsg, ComplaintVO *complaint) {
        if (errorMsg) {
            NSLog(@"%@",errorMsg);
        }
        NSLog(@"%@",complaint);
        NSLog(@"%@",self.complianId);
        NSArray *sectionOneData = @[complaint.complaint_type_name,complaint.estate,complaint.complaint_person,complaint.complaint_phone];
        NSArray *sectionTwoData = @[complaint.complaint_content];
        NSArray *sectionThreeData;
        if ([complaint.st integerValue]) {
            sectionThreeData = @[@"成功",complaint.ctime];
        }
        else
        {
            sectionThreeData = @[@"失败",complaint.ctime];
            
        }
        self.data = @[sectionOneData,sectionTwoData,sectionThreeData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [SVProgressHUD dismiss];

        });
        
        
    }];
    NSLog(@"%@",self.data);

}

- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = NO;
    [self.tableView setSeparatorColor:My_Color(241, 244, 244)];
//    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    [self.view addSubview: self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *resultCell;
    
    if (indexPath.section != 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",self.cellOneData[indexPath.row],self.data[indexPath.section][indexPath.row]];
        }

        else
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",self.cellThreeData[indexPath.row],self.data[indexPath.section][indexPath.row]];
                    break;
                case 1:
                {
                    NSString *time = [NSString stringDateFromTimeInterval:[self.data[indexPath.section][indexPath.row] intValue] withFormat:@"YYYY-MM-dd HH:mm"];

                    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",self.cellThreeData[indexPath.row],time];
                }
                    
                default:
                    break;
            }
            
        }
        resultCell = cell;
    }
    else
    {
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
        }
        cell.textLabel.text = @"投诉内容：";
        cell.detailTextLabel.text = self.data[indexPath.section][0];
        cell.detailTextLabel.numberOfLines = 0;
        resultCell = cell;
    }
    if (indexPath.row == [self.data[indexPath.section]count] - 1) {
    }
    resultCell.textLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    resultCell.detailTextLabel.font = resultCell.textLabel.font;
    resultCell.selectionStyle = UITableViewCellSelectionStyleNone;
    resultCell.preservesSuperviewLayoutMargins = NO;
    resultCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    resultCell.layoutMargins = UIEdgeInsetsZero;
    return resultCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *ResultView;
    if (section == 0) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"彩条"]];
        ResultView = imageView;
    }
    else
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 1)];
        imageView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"虚线"]];
//        imageView.backgroundColor = [UIColor whiteColor];
        [view addSubview:imageView];
        ResultView = view;
    }
    return ResultView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CGFloat contenHeight = [self.data[1][0] sizeWithFont:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(tableView.width, 4000)].height;
        //添加上面固定内容的高度 + 下面内容的高度 + 与下边界的距离
        return contenHeight + 20;
    }
    else
    {
    return 40;
    }
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
