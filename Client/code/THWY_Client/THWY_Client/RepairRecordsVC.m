//
//  RepairRecordsVC.m
//  THWY_Client
//
//  Created by wei on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairRecordsVC.h"

@interface RepairRecordsVC ()

@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (assign, nonatomic) NSInteger switchFlag;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *tableView2;

@end

@implementation RepairRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"报修记录";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景2"]]];

    [self initViews];
    
}

- (void)initViews{
    
    self.switchFlag = 1;
    self.switchButton = [[UIButton alloc] init];
    [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签左"] forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(switchLeftRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.75);
        make.height.mas_equalTo(self.switchButton.mas_width).multipliedBy(70/491.0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view).offset(10);
    }];
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.text = @"业主报修";
    self.leftLabel.font = [UIFont fontWithName:My_RegularFontName size:18.0];
    self.leftLabel.textColor = [UIColor whiteColor];
    [self.leftLabel sizeToFit];
    [self.switchButton addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.switchButton.mas_centerX).multipliedBy(0.5);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
    }];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.text = @"公共报修";
    self.rightLabel.textColor = My_NAV_BG_Color;
    self.rightLabel.font = [UIFont fontWithName:My_RegularFontName size:18.0];
    [self.rightLabel sizeToFit];
    [self.switchButton addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.switchButton.mas_centerX).multipliedBy(1.5);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-20, My_ScreenH-94-40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(My_ScreenW-20, 0, My_ScreenW-20, My_ScreenH-94-40)];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView2.separatorColor = [UIColor grayColor];
    self.tableView2.bounces = NO;
    self.tableView2.showsVerticalScrollIndicator = NO;
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake((My_ScreenW-20)*2.0, My_ScreenH-94);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.tableView2];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchButton.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];

    
    [self.tableView2 registerNib:[UINib nibWithNibName:@"PaigongCatogerysCell" bundle:nil] forCellReuseIdentifier:@"PaigongCatogerysCell"];
        
}

- (void)switchLeftRight{
    
    if (self.switchFlag == 1) {
        self.leftLabel.textColor = My_NAV_BG_Color;
        self.rightLabel.textColor = [UIColor whiteColor];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签右"] forState:UIControlStateNormal];
        self.scrollView.contentOffset = CGPointMake(self.tableView.frame.size.width, 0);
        self.tableView2.contentOffset = CGPointMake(0, 0);
        self.switchFlag = 2;
    }else if (self.switchFlag == 2){
        self.leftLabel.textColor = [UIColor whiteColor];
        self.rightLabel.textColor = My_NAV_BG_Color;
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签左"] forState:UIControlStateNormal];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.tableView.contentOffset = CGPointMake(0, 0);
        self.switchFlag = 1;
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
