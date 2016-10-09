//
//  RepairAcceptOrderVC.m
//  YTWY_Server
//
//  Created by wei on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairAcceptOrderVC.h"
#import "RunSliderLabel.h"
#import "RepairAcceptOrderCell.h"
#import "RepairDetailController.h"
#import "TaskVO.h"

@interface RepairAcceptOrderVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *labelNames;

@property (assign, nonatomic) TaskType switchFlag;
@property (assign, nonatomic) int selectIndex;
@property (assign, nonatomic) int page;

@end

@implementation RepairAcceptOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"报修接单";
    self.switchFlag = 1;
    self.page = 0;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]];
    self.dataArray = [NSMutableArray array];
    [self initViews];
    
}

- (void)initViews{
    
    self.labelNames = @[@"所有任务", @"待处理", @"处理中", @"处理完毕"];
    CGFloat topMargin = 8.0;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(topMargin, topMargin, My_ScreenW-2*topMargin, 0.25*(My_ScreenW-2*topMargin))];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];

    
    for(int i = 0; i < 4; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.width/4.0*i, 0, self.bgView.width/4.0, self.bgView.height)];
        btn.tag = 300 + i;
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"records_按下"] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/5.0, 0, btn.width*0.6, btn.height*0.6)];
        btnImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"order_%@",self.labelNames[i]]];
        //        btnImage.centerY = btn.centerY * 0.5;
        [btn addSubview:btnImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.width*0.75, 0, 0)];
        label.text = self.labelNames[i];
        [label sizeToFit];
        label.centerX = btnImage.centerX;
        label.font = FontSize(CONTENT_FONT);
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];
        
    }
    
    UIButton *btn_more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-20, 30)];
    [btn_more setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn_more setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_more.titleLabel.font = [UIFont fontWithName:My_RegularFontName size:15.0];
    [btn_more addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"records_彩条"]];
    headerImage.frame = CGRectMake(0, 0, self.bgView.width, 2);
    
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(topMargin, self.bgView.height+20, self.bgView.width, My_ScreenH-64- 3* topMargin-self.bgView.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 300.0/667*My_ScreenH;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.bounces = YES;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = btn_more;
    self.tableView.tableHeaderView = headerImage;
    
    [self.tableView registerClass:[RepairAcceptOrderCell class] forCellReuseIdentifier:@"RepairAcceptOrderCell"];
    [self.view addSubview:self.tableView];
    
    [self initRefreshView];
    
}

- (void)getDataListPage:(int)page{
   
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    [My_ServicesManager getTaskList:self.switchFlag page:self.page onComplete:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg) {
            
            [SVProgressHUD showErrorWithStatus:errorMsg];
            if (self.page != 0) {
                self.page--;
            }
            
            
        }else {
            
            if (list && list.count == 0 && self.page != 0) {
                self.page--;
            }else{
                
            }
            
            for (TaskVO *model in list) {
                [self.dataArray addObject:model];
            }
            
            [SVProgressHUD dismiss];
            //            [SVProgressHUD hudHideWithSuccess:@"加载完毕"];
        }
        
        [self.tableView reloadData];
        if (self.page == 0) {
            self.tableView.contentOffset = CGPointMake(0, 0);
        }
        
        [self.tableView.mj_header endRefreshing];

    }];
    
    
}

//设置上拉下拉刷新
- (void)initRefreshView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
}

- (void)refreshData{
    [self.dataArray removeAllObjects];
    self.page = 0;
    [self getDataListPage:self.page];
    
}

//更换状态
- (void)btnOnclicked:(UIButton *)sender{
    
    UIButton *btn = [self.bgView viewWithTag:299+self.switchFlag];
    self.switchFlag = sender.tag - 299;
    [btn setImage:nil forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"records_按下"] forState:UIControlStateNormal];
    
    [self refreshData];

}

//查看更多
- (void)loadMoreData:(UIButton *)button{
    
    [self getDataListPage:++self.page];
    
}

#pragma mark - tabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row<self.dataArray.count) {
        RepairAcceptOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairAcceptOrderCell" forIndexPath:indexPath];
        [cell loadDataFromTaskVO:self.dataArray[row]];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count-1) {
        UIButton *btn_more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-20, 30)];
        [btn_more setTitle:@"查看更多" forState:UIControlStateNormal];
        [btn_more setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_more.titleLabel.font = [UIFont fontWithName:My_RegularFontName size:15.0];
        [btn_more addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventTouchUpInside];
        tableView.tableFooterView = btn_more;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskVO *task = self.dataArray[indexPath.row];
    CGFloat topMargin = 10/667.0*My_ScreenH;
    CGFloat leftMargin = topMargin*0.5;
    CGFloat imageWidth = 50/667.0*My_ScreenH;
    CGFloat detailWidth = tableView.width-(3*topMargin+leftMargin+imageWidth)-70;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(CONTENT_FONT-1),NSFontAttributeName, nil];
    CGRect rect = [[self.dataArray[indexPath.row] classes_str] boundingRectWithSize:CGSizeMake(detailWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    if ([[task kb] intValue] == 3 && [[task st] intValue] == 0) {
        return rect.size.height+80+45+20;
    }else{
        return rect.size.height+80;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskVO *task = self.dataArray[indexPath.row];
    RepairDetailController *detail = [[RepairDetailController alloc] init];
    detail.repairVOId = task.Id;
    detail.displayType = RepairStatisticsDetailType;
    if ([task.owner_public isEqualToString:@"o"]) {
        detail.type = 1;
    }else{
        detail.type = 2;
    }
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.dataArray removeAllObjects];
    self.page = 0;
    [self getDataListPage:self.page];
}

@end
