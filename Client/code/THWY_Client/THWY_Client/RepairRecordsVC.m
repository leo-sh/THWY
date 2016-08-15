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
#import "MySegmentedControl.h"
#import "RepairDetailController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface RepairRecordsVC ()<UITableViewDelegate, UITableViewDataSource, SegmentDelegate>

@property (strong, nonatomic) MySegmentedControl *switchButton;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *bgView2;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *tableView2;

@property (strong, nonatomic) NSArray *labelNames;

@property (strong, nonatomic) NSMutableArray *repairDataArray;
@property (strong, nonatomic) NSMutableArray *repairStatusArray;

@property (assign, nonatomic) NSInteger switchFlag;
@property (assign, nonatomic) int selectIndex;
@property (assign, nonatomic) int page;

@end

@implementation RepairRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"报修记录";
    self.repairDataArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景2"]]];
    self.selectIndex = 0;
    self.page = 1;
    self.labelNames = @[@"未处理", @"处理中", @"处理完成", @"回访完毕"];//1, 2, 3, 4
    [self initViews];
    [self getDataType:self.switchFlag statusID:@"0" page:self.page more:NO];
    
}

- (void)getDataType:(NSInteger)type statusID:(NSString *)statusID page:(int)page more:(BOOL)more{
    
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [My_ServicesManager getRepairs:type page:page repairStatu:statusID onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            
            [SVProgressHUD showErrorWithStatus:errorMsg];
            
        }else {
            if (!more) {
                //非加载更多
                [self.repairDataArray removeAllObjects];
            }else{
                self.page++;
            }

            for (RepairVO *model in list) {
                [self.repairDataArray addObject:model];
            }
            
            if (self.switchFlag == 1) {
                [self.tableView reloadData];
            }else if (self.switchFlag == 2){
                [self.tableView2 reloadData];
            }
            
            if (list && list.count == 0) {

                [SVProgressHUD showErrorWithStatus:@"没有更多数据..."];
                
            }else{
                [SVProgressHUD dismiss];
            }
            
        }
      
        if (self.switchFlag == 1) {
            [self.tableView.mj_header endRefreshing];

        }else{
            [self.tableView2.mj_header endRefreshing];
        }
        
    }];

}

- (void)initViews{
    
    //转换按钮
    self.switchFlag = 1;
    
    self.switchButton = [[MySegmentedControl alloc] initWithItems:@[@"业主报修", @"公共报修"]];
    self.switchButton.delegate = self;
    self.switchButton.selectedSegmentIndex = 0;
    [self.view addSubview:self.switchButton];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.75);
        make.height.mas_equalTo(self.switchButton.mas_width).multipliedBy(70/491.0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view).offset(10);
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
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/8.0, 0, btn.width*3/4.0, btn.height*3/4.0)];
        btnImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"records_%@",self.labelNames[i]]];
//        btnImage.centerY = btn.centerY * 0.5;
        [btn addSubview:btnImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btnImage.height, 0, 0)];
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
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/8.0, 0, btn.width*3/4.0, btn.height*3/4.0)];
        btnImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"records_%@",self.labelNames[i]]];
        [btn addSubview:btnImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btnImage.height, 0, 0)];
        label.text = self.labelNames[i];
        [label sizeToFit];
        label.centerX = btnImage.centerX;
        label.font = [UIFont fontWithName:My_RegularFontName size:16.0];
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];

    }
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bgView.height+20, My_ScreenW-20, My_ScreenH-114-45-self.bgView.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 300.0/667*My_ScreenH;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.bounces = YES;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.showsVerticalScrollIndicator = NO;
//    [self.tableView setTableFooterView:btn_more];
    
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(My_ScreenW-20, self.bgView2.height+20, My_ScreenW-20, self.tableView.height)  style:UITableViewStylePlain];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.rowHeight = 300.0/667*My_ScreenH;
    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView2.separatorColor = [UIColor grayColor];
    self.tableView2.bounces = YES;
    [self.tableView2 setBackgroundColor:[UIColor clearColor]];
    self.tableView2.showsVerticalScrollIndicator = NO;
//    [self.tableView2 setTableFooterView:btn_more];
    
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.tableView2];
    
    [self initRefreshView];
    
    [self.tableView registerClass:[RecordeRepairingCell class] forCellReuseIdentifier:@"RecordeRepeiringCell"];
    [self.tableView2 registerClass:[RecordeRepairingCell class] forCellReuseIdentifier:@"RecordeRepeiringCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

//- (void)switchLeftRight{
//    
//    if (self.switchFlag == 1) {
//        self.leftLabel.textColor = My_NAV_BG_Color;
//        self.rightLabel.textColor = [UIColor whiteColor];
////        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签右"] forState:UIControlStateNormal];
//        self.scrollView.contentOffset = CGPointMake(self.tableView.frame.size.width, 0);
//        self.tableView2.contentOffset = CGPointMake(0, 0);
//        
//        [self btnOnclicked:[self.bgView viewWithTag:300]];
//        self.switchFlag = 2;
//        self.selectIndex = 0;
//        [self btnOnclicked:[self.bgView2 viewWithTag:310]];
//        
//        
//    }else if (self.switchFlag == 2){
//        self.leftLabel.textColor = [UIColor whiteColor];
//        self.rightLabel.textColor = My_NAV_BG_Color;
////        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签左"] forState:UIControlStateNormal];
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//        self.tableView.contentOffset = CGPointMake(0, 0);
//        self.switchFlag = 1;
//        [self btnOnclicked:[self.bgView2 viewWithTag:310]];
//        self.selectIndex = 0;
//        [self btnOnclicked:[self.bgView viewWithTag:300]];
//    }
//    
//    
//}

//业主,公共转换
- (void)segmentSelectIndex:(NSInteger)index{
    if (index == 1) {
        
        self.scrollView.contentOffset = CGPointMake(self.tableView.frame.size.width, 0);
        self.tableView2.contentOffset = CGPointMake(0, 0);
        
        [self btnOnclicked:[self.bgView viewWithTag:300]];
        self.switchFlag = 2;
        self.selectIndex = 0;
        [self btnOnclicked:[self.bgView2 viewWithTag:310]];

        
    }else if (index == 0){
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.tableView.contentOffset = CGPointMake(0, 0);
        self.switchFlag = 1;
        [self btnOnclicked:[self.bgView2 viewWithTag:310]];
        self.selectIndex = 0;
        [self btnOnclicked:[self.bgView viewWithTag:300]];

        
    }
    [self getDataType:self.switchFlag statusID:@"0" page:1 more:NO];
}
//设置上拉下拉刷新
- (void)initRefreshView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
 //   self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
// self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
 //   self.tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //自动更改透明度
    self.tableView2.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView2.mj_footer.automaticallyChangeAlpha = YES;
    

}

//下拉刷新
- (void)loadMoreData{
    
    if (self.switchFlag == 1) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self.tableView2.mj_header beginRefreshing];
    }
    
    if (self.selectIndex == 0){
        [self getDataType:self.switchFlag statusID:@"0" page:self.page+1 more:YES];
    }else{
        [self getDataType:self.switchFlag statusID:[NSString stringWithFormat:@"%d", self.selectIndex+1] page:self.page+1 more:YES];
    }
    
    
}

//更换状态
- (void)btnOnclicked:(UIButton *)sender{
    UIButton *btn = nil;
    if (self.switchFlag == 1){
        self.tableView.contentOffset = CGPointMake(0, 0);
        btn = [self.bgView viewWithTag:300+self.selectIndex];
        self.selectIndex = sender.tag - 300;
    }else if (self.switchFlag == 2){
        self.tableView2.contentOffset = CGPointMake(0, 0);
        btn = [self.bgView2 viewWithTag:310+self.selectIndex];
        self.selectIndex = sender.tag - 310;
    }

    [btn setImage:nil forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"records_按下"] forState:UIControlStateNormal];
    
    if (self.selectIndex == 0){
        [self getDataType:self.switchFlag statusID:@"0" page:1 more:NO];
    }else{
        [self getDataType:self.switchFlag statusID:[NSString stringWithFormat:@"%d", self.selectIndex+1] page:1 more:NO];
    }

}

#pragma mark - tabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.repairDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    RecordeRepairingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordeRepeiringCell" forIndexPath:indexPath];
    cell.vc = self;
    [cell loadDataFromModel:self.repairDataArray[row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.repairDataArray.count-1) {
        UIButton *btn_more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-20, 30)];
        [btn_more setTitle:@"查看更多" forState:UIControlStateNormal];
        [btn_more setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_more.titleLabel.font = [UIFont fontWithName:My_RegularFontName size:15.0];
        [btn_more addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventTouchUpInside];
        tableView.tableFooterView = btn_more;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:My_RegularFontName size:16.0],NSFontAttributeName, nil];
    CGRect rect = [[self.repairDataArray[indexPath.row] detail] boundingRectWithSize:CGSizeMake(320/375.0*My_ScreenW, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    CGRect rect2 = [[self.repairDataArray[indexPath.row] classes_str] boundingRectWithSize:CGSizeMake(320/375.0*My_ScreenW, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    if ([[UIDevice platformString] isEqualToString:@"iPhone 4s"]) {
        return 205.0/667*My_ScreenH + rect.size.height +rect2.size.height+20;
    }else if([[UIDevice platformString] isEqualToString:@"iPhone 5s"] || [[UIDevice platformString] isEqualToString:@"iPhone 5"]){
        return 210.0/667*My_ScreenH + rect.size.height +rect2.size.height;
    }else if([[UIDevice platformString] isEqualToString:@"iPhone 6s"] || [[UIDevice platformString] isEqualToString:@"iPhone 6"]){
        return 200.0/667*My_ScreenH + rect.size.height +rect2.size.height;
    }else{
        return 190.0/667*My_ScreenH + rect.size.height +rect2.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RepairVO *model = self.repairDataArray[indexPath.row];
    RepairDetailController *detail = [[RepairDetailController alloc] init];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
    
}

//查看更多
- (void)loadMoreData:(UIButton *)button{
    
    if (self.selectIndex == 0){
        [self getDataType:self.switchFlag statusID:@"0" page:self.page+1 more:YES];
    }else{
        [self getDataType:self.switchFlag statusID:[NSString stringWithFormat:@"%d", self.selectIndex+1] page:self.page+1 more:YES];
    }
    
}

#pragma  mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
