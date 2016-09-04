//
//  WantRepairesVC.m
//  YTWY_Server
//
//  Created by wei on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WantRepairesVC.h"

#import "WantRepairTableViewDelegate.h"
#import "WantRepairTableView2.h"
#import "MySegmentedControl.h"
#import "AlertTableView.h"
#import "RepairClassVO.h"

@interface WantRepairesVC ()<WantRepairTableViewDelegate>

@property (strong, nonatomic) WantRepairTableView2 *tableView2;
@property (strong, nonatomic) AlertTableView *alertView;

@property (strong, nonatomic) NSArray *iconCellNames;
@property (strong, nonatomic) NSArray *identityStrings;

@property (strong, nonatomic) NSMutableArray *repaireClassArrayPublic;

@end

@implementation WantRepairesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景2"]]];
}

- (void)initViews{
    NSInteger topMargin = 10/667.0*My_ScreenH;
    self.tableView2 = [[WantRepairTableView2 alloc] initWithFrame:CGRectMake(topMargin, topMargin, My_ScreenW-2*topMargin, My_ScreenH-64-2*topMargin) style:UITableViewStylePlain];
    self.tableView2.repairDelegate = self;
    [self.view addSubview:self.tableView2];
}

//获取维修类型
- (void)getData{

    [My_ServicesManager getPublicRepairClasses:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            
            [SVProgressHUD showErrorWithStatus:errorMsg];
            return ;
        }

        for (RepairClassVO *publicVO in list) {
            [self.repaireClassArrayPublic addObject:publicVO];
        }
        self.tableView2.repaireClassArrayPublic = self.repaireClassArrayPublic;
        [self.tableView2 reloadData];
        
    }];
}

#pragma mark - getters
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
        [SVProgressHUD showErrorWithStatus:@"报修提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)tableViewDidScroll{
    
    if (self.keyboardUtil.keyBoardType == keyBoardAppearType) {
        [self.view endEditing:YES];
    }
    
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
