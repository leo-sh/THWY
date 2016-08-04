//
//  RepairRecordsVC.m
//  THWY_Client
//
//  Created by wei on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairRecordsVC.h"
#import "RecordeRepairingCell.h"
#import "RepairStatuVO.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface RepairRecordsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (assign, nonatomic) NSInteger switchFlag;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *bgView2;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *tableView2;

@property (strong, nonatomic) NSArray *labelNames;

@property (strong, nonatomic) NSMutableArray *repairingArray;

@property (assign, nonatomic) NSInteger selectIndex;
@end

@implementation RepairRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"报修记录";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景2"]]];
    self.selectIndex = 0;
    self.labelNames = @[@"未处理", @"处理中", @"处理完成", @"回访完毕"];
    [self initViews];
    [self getData:0];
    
}

- (void)getData:(NSInteger)type{
    self.repairingArray = [NSMutableArray array];
    [My_ServicesManager getRepairStatus:2 onComplete:^(NSString *errorMsg, NSArray *list) {
        for (RepairStatuVO *repaireStatus in list) {
            
        }
    }];
    
    [My_ServicesManager getRepairs:1 page:1 repairStatu:@"" :^(NSString *errorMsg, NSArray *list) {
        for (RepairVO *model in list) {
            [self.repairingArray addObject:model];
        }
        if (self.switchFlag == 1) {
            [self.tableView reloadData];
        }else if (self.switchFlag == 2){
            [self.tableView2 reloadData];
        }
    }];
}

- (void)initViews{
    
    //转换按钮
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
    //scrollView
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake((My_ScreenW-20)*2.0, My_ScreenH-94);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchButton.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    
    //buttons
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-20, 0.25*(My_ScreenW-20))];
    [self.scrollView addSubview:self.bgView];
    
    for(int i = 0; i < 4; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.width/4.0*i, 0, self.bgView.width/4.0, self.bgView.height)];
        btn.tag = 300 + i;
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"records_按下"] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/4.0, 0, btn.width/2.0, btn.height/2.0)];
        btnImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"records_%@",self.labelNames[i]]];
        btnImage.centerY = btn.centerY * 0.5;
        [btn addSubview:btnImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btnImage.height+6, 0, 0)];
        label.text = self.labelNames[i];
        [label sizeToFit];
        label.centerX = btnImage.centerX;
        label.font = [UIFont fontWithName:My_RegularFontName size:16.0];
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];
        
    }
    
    self.bgView2 = [[UIView alloc] initWithFrame:CGRectMake(My_ScreenW-20, 0, My_ScreenW-20, self.bgView.height)];
    [self.scrollView addSubview: self.bgView2];
    
    for(int i = 0; i<3; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView2.width*(1.5/4.0)*i, 0, self.bgView2.width/4.0, self.bgView2.height)];
        
        btn.tag = 310 + i;
        [btn addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"records_按下"] forState:UIControlStateNormal];
        }
        [self.bgView2 addSubview:btn];
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/4.0, 0, btn.width/2.0, btn.height/2.0)];
        btnImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"records_%@",self.labelNames[i]]];
        btnImage.centerY = btn.centerY * 0.5;
        [btn addSubview:btnImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btnImage.height+6, 0, 0)];
        label.text = self.labelNames[i];
        [label sizeToFit];
        label.centerX = btnImage.centerX;
        label.font = [UIFont fontWithName:My_RegularFontName size:16.0];
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];

    }
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bgView.height+20, My_ScreenW-20, My_ScreenH-94-40-self.bgView.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 360/667*My_ScreenH;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.bounces = NO;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(My_ScreenW-20, self.bgView2.height+20, My_ScreenW-20, self.tableView.height)];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.rowHeight = 360/667*My_ScreenH;
    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView2.separatorColor = [UIColor grayColor];
    self.tableView2.bounces = NO;
    [self.tableView2 setBackgroundColor:[UIColor clearColor]];
    self.tableView2.showsVerticalScrollIndicator = NO;
    
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.tableView2];
    
    [self.tableView registerClass:[RecordeRepairingCell class] forCellReuseIdentifier:@"RecordeRepeiringCell"];
    [self.tableView2 registerClass:[RecordeRepairingCell class] forCellReuseIdentifier:@"RecordeRepeiringCell"];
}

- (void)switchLeftRight{
    
    if (self.switchFlag == 1) {
        self.leftLabel.textColor = My_NAV_BG_Color;
        self.rightLabel.textColor = [UIColor whiteColor];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签右"] forState:UIControlStateNormal];
        self.scrollView.contentOffset = CGPointMake(self.tableView.frame.size.width, 0);
        self.tableView2.contentOffset = CGPointMake(0, 0);
        
        [self btnOnclicked:[self.bgView viewWithTag:300]];
        self.switchFlag = 2;
        self.selectIndex = 0;
        [self btnOnclicked:[self.bgView2 viewWithTag:310]];
        
        
    }else if (self.switchFlag == 2){
        self.leftLabel.textColor = [UIColor whiteColor];
        self.rightLabel.textColor = My_NAV_BG_Color;
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签左"] forState:UIControlStateNormal];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.tableView.contentOffset = CGPointMake(0, 0);
        self.switchFlag = 1;
        [self btnOnclicked:[self.bgView2 viewWithTag:310]];
        self.selectIndex = 0;
        [self btnOnclicked:[self.bgView viewWithTag:300]];
    }
    
}

- (void)btnOnclicked:(UIButton *)sender{
    UIButton *btn = nil;
    if (self.switchFlag == 1){
        btn = [self.bgView viewWithTag:300+self.selectIndex];
        self.selectIndex = sender.tag - 300;
    }else if (self.switchFlag == 2){
        btn = [self.bgView2 viewWithTag:310+self.selectIndex];
        self.selectIndex = sender.tag - 310;
    }

    [btn setImage:nil forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"records_按下"] forState:UIControlStateNormal];
    
}

#pragma mark - tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.repairingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger row = indexPath.row;
    RecordeRepairingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordeRepeiringCell" forIndexPath:indexPath];
    cell.fd_enforceFrameLayout = YES;
    cell.vc = self;
    [cell loadDataFromModel:self.repairingArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecordeRepairingCell * newcell = (RecordeRepairingCell *)cell;
    newcell.vc = self;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"RecordeRepeiringCell" cacheByIndexPath:indexPath configuration:^(id cell) {
//        // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
        [cell loadDataFromModel:self.repairingArray[indexPath.row]];
////        cell.entity = self.feedEntities[indexPath.row];
    }];
//    return 360;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 360;
}

#pragma  mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
