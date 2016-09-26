//
//  WantRepairesVC.m
//  YTWY_Client
//
//  Created by wei on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WantRepairesVC.h"

#import "WantRepairTableViewDelegate.h"
#import "WantRepairTableView1.h"
#import "WantRepairTableView2.h"
#import "MySegmentedControl.h"

#import "AlertTableView.h"
#import "RepairClassVO.h"
#import "AddRepairVO.h"

@interface WantRepairesVC ()<WantRepairTableViewDelegate, SegmentDelegate>

@property (strong, nonatomic) MySegmentedControl *switchButton;

@property (assign, nonatomic) NSInteger switchFlag;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) WantRepairTableView1 *tableView;
@property (strong, nonatomic) WantRepairTableView2 *tableView2;
@property (strong, nonatomic) AlertTableView *alertView;

@property (strong, nonatomic) NSArray *iconCellNames;
@property (strong, nonatomic) NSArray *identityStrings;

@property (strong, nonatomic) NSMutableArray *repaireClassArrayPay;
@property (strong, nonatomic) NSMutableArray *repaireClassArrayFree;

@property (strong, nonatomic) NSMutableArray *repaireClassArrayPublic;
@end

@implementation WantRepairesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.switchFlag = 1;
    [self getData];
    [self initNVBar];
    [self initViews];
 }

-(void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

- (void)initNVBar{
    
    self.title = @"我要报修";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景2"]]];
}

- (void)initViews{
    
    self.switchButton = [[MySegmentedControl alloc] initWithItems:@[@"业主报修", @"公共报修"]];
    self.switchButton.delegate = self;
    self.switchButton.selectedSegmentIndex = 0;
    self.switchButton.layer.cornerRadius = 10;
    self.switchButton.clipsToBounds = YES;
    self.switchButton.layer.borderWidth = 1;
    self.switchButton.layer.borderColor = My_NAV_BG_Color.CGColor;
    self.switchButton.tintColor = My_NAV_BG_Color;
    [self.view addSubview:self.switchButton];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.75);
        make.height.mas_equalTo(self.switchButton.mas_width).multipliedBy(70/491.0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view).offset(10);
    }];
    
    self.tableView = [[WantRepairTableView1 alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-20, My_ScreenH-94-40) style:UITableViewStylePlain];
    self.tableView.repairDelegate = self;
    
    
    self.tableView2 = [[WantRepairTableView2 alloc] initWithFrame:CGRectMake(My_ScreenW-20, 0, My_ScreenW-20, My_ScreenH-94-40) style:UITableViewStylePlain];
    self.tableView2.repairDelegate = self;

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake((My_ScreenW-20)*2.0, My_ScreenH-74);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.tableView2];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchButton.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    
}

//业主,公共转换
- (void)segmentSelectIndex:(NSInteger)index{
    if (index == 1) {
        self.scrollView.contentOffset = CGPointMake(self.tableView.frame.size.width, 0);
        self.tableView2.contentOffset = CGPointMake(0, 0);
        self.switchFlag = 2;

    }else if (index == 0){

        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.tableView.contentOffset = CGPointMake(0, 0);
        self.switchFlag = 1;

    }
}

//获取维修类型
- (void)getData{
    [My_ServicesManager getRepairClasses:1 onComplete:^(NSString *errorMsg, NSDictionary *list) {
        
        if (errorMsg) {
            
            [SVProgressHUD showErrorWithStatus:errorMsg];
            return ;
        }
        
        self.repaireClassArrayPay = list[@"for_pay"];
        self.repaireClassArrayFree = list[@"for_free"];
        
//        for (RepairClassVO *model in pay.child) {
//            [self.repaireClassArrayPay addObject:model];
//        }
//        
//        NSArray *freeArray = [free.child.lastObject child];
//        for (RepairClassVO *model in freeArray) {
//            [self.repaireClassArrayFree addObject:model];
//        }
        self.tableView.repaireClassArrayPay = self.repaireClassArrayPay;
        self.tableView.repaireClassArrayFree = self.repaireClassArrayFree;
//        [self.tableView reloadData];
    }];
    
    [My_ServicesManager getRepairClasses:2 onComplete:^(NSString *errorMsg, NSDictionary *list) {
        if (errorMsg) {
            
            [SVProgressHUD showErrorWithStatus:errorMsg];
            return ;
        }
        
        RepairClassVO *public = list[@"public"];
        for (RepairClassVO *publicVO in public.child) {
            [self.repaireClassArrayPublic addObject:publicVO];
        }
        self.tableView2.repaireClassArrayPublic = self.repaireClassArrayPublic;
//        [self.tableView2 reloadData];
    }];
}

#pragma mark - getters
- (NSMutableArray *)repaireClassArrayFree{
    
    if (!_repaireClassArrayFree) {
        _repaireClassArrayFree = [NSMutableArray array];
    }
    return _repaireClassArrayFree;
}

- (NSMutableArray *)repaireClassArrayPay{
    
    if (!_repaireClassArrayPay) {
        _repaireClassArrayPay = [NSMutableArray array];
    }
    return _repaireClassArrayPay;
}

- (NSMutableArray *)repaireClassArrayPublic{
    if (!_repaireClassArrayPublic) {
        _repaireClassArrayPublic = [NSMutableArray array];
    }
    return _repaireClassArrayPublic;
}

#pragma mark - 键盘隐藏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - WantRepairDelegate
- (void)commitComplete:(NSString *)errorMsg{
    
    if (errorMsg) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"报修提交失败\n%@",errorMsg]];
    }else{
        [SVProgressHUD hudHideWithSuccess:@"报修提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)tableViewDidScroll{
    
    if (self.keyboardUtil.keyBoardType == keyBoardAppearType) {
        [self.view endEditing:YES];
    }
    
}


@end
