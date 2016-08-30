//
//  IntegralVC.m
//  THWY_Client
//
//  Created by Mr.S on 16/8/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "IntegralVC.h"
#import "IntegralTitleCell.h"
#import "IntegralDetailCell.h"

#define TOPVIEW_HEIGHT My_ScreenH/4.5

@interface IntegralVC ()<UITableViewDelegate,UITableViewDataSource>

@property UIView* topView;
@property UIImageView* integralBG;
@property UILabel* titleLabel;
@property UILabel* integralLabel;

@property NSArray* datas;
@property NSString* total;
@property NSString* used;
@property NSString* unUsed;

@property UITableView* tableView;

@end

@implementation IntegralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的积分";
    
    self.used = @"0";
    self.unUsed = @"0";
    self.total = @"0";
    [self createUI];
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    [self loadPage];
}

-(void)loadPage
{
    [My_ServicesManager getMyPoints:^(NSString *errorMsg, NSArray *list, NSString *total) {
        if (errorMsg == nil) {
            [SVProgressHUD dismiss];
            self.datas = list;
            self.unUsed = [NSString stringWithFormat:@"%ld",[total integerValue]];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
    }];
}

-(void)createUI
{
    UIImageView* imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Integral_背景"]];
    imv.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    imv.userInteractionEnabled = YES;
    [self.view addSubview:imv];
    
    self.tableView = [[UITableView alloc]initWithFrame:imv.frame];
    self.tableView.backgroundColor = My_clearColor;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, My_ScreenW, TOPVIEW_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[IntegralTitleCell class] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerClass:[IntegralDetailCell class] forCellReuseIdentifier:@"detailCell"];
    [imv addSubview:self.tableView];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, My_ScreenW, TOPVIEW_HEIGHT)];
    [self.view addSubview:self.topView];
    
    self.integralBG = [UIImageView new];
    self.integralBG.image = [UIImage imageNamed:@"我的积分-背景框"];
    [self.topView addSubview:self.integralBG];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, My_ScreenW, My_ScreenH)];
    self.titleLabel.font = FontSize(CONTENT_FONT+6);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"总积分";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    [self.integralBG addSubview:self.titleLabel];
    
    self.integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, My_ScreenW, My_ScreenH)];
    self.integralLabel.font = FontSize(CONTENT_FONT+8);
    self.integralLabel.textColor = [UIColor whiteColor];
    self.integralLabel.text = self.total;
    self.integralLabel.adjustsFontSizeToFitWidth = YES;
    self.integralLabel.textAlignment = NSTextAlignmentCenter;
    [self.integralLabel sizeToFit];
    [self.integralBG addSubview:self.integralLabel];
    
    [self updateTopSubViewsFrame];
}

-(void)updateTopSubViewsFrame
{
    self.integralBG.frame = CGRectMake(0, 20/375.0*My_ScreenW, 0, self.topView.height - 40/375.0*My_ScreenW);
    self.integralBG.width = self.integralBG.height;
    self.integralBG.center = CGPointMake(My_ScreenW/2, self.integralBG.center.y);
    
    if (self.topView.height - 40/375.0*My_ScreenW <= 0.0) {
        
        self.integralBG.hidden = YES;
    }else
    {
        self.integralBG.hidden = NO;
    }
    
    self.titleLabel.y = self.integralBG.height/2 - self.titleLabel.height + 5/375.0*My_ScreenW;
    self.titleLabel.width = self.integralBG.width - 20/375.0*My_ScreenW;
    self.titleLabel.center = CGPointMake(self.integralBG.width/2, self.titleLabel.center.y);
    
    self.integralLabel.width = self.integralBG.width - 20/375.0*My_ScreenW;
    self.integralLabel.y = self.titleLabel.bottom - 5/375.0*My_ScreenW;
    self.integralLabel.center = CGPointMake(self.integralBG.width/2, self.integralLabel.center.y);
}

#pragma mark -TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        IntegralTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        [cell fillCellWith:self.used andUnUsed:self.unUsed];
        return cell;
    }else
    {
        IntegralDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        
        BOOL isBottom = NO;
        if (indexPath.row == self.datas.count) {
            isBottom = YES;
        }
        
        [cell fillCell:isBottom andPoint:self.datas[indexPath.row - 1]];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90/375.0*My_ScreenW;
    }else
    {
        return 50/375.0*My_ScreenW;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10/375.0*My_ScreenW;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (TOPVIEW_HEIGHT - scrollView.contentOffset.y >= 0) {
        if (scrollView.contentOffset.y >= 0) {
            self.topView.y = -scrollView.contentOffset.y;
        }else
        {
            self.topView.height = TOPVIEW_HEIGHT - scrollView.contentOffset.y;
            [self updateTopSubViewsFrame];
            
        }
//        self.topView.height = TOPVIEW_HEIGHT - scrollView.contentOffset.y;
//        [self updateTopSubViewsFrame];
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
