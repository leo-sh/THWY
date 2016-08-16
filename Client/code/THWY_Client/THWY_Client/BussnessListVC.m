//
//  BussnessListVC.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BussnessListVC.h"
#import "MerchantVO.h"
#import "MerchargeListCell.h"
#import "BussnessDetailVC.h"
#import "MerchantTypeTableView.h"
#import "BussnessSelectButton.h"

@interface BussnessListVC ()<UITableViewDelegate, UITableViewDataSource, MerchantTypeTableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *bussnessModels;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) BussnessSelectButton *chooseTypeBtn;
@property (strong, nonatomic) UITextField *merchantNametextField;
@property (strong, nonatomic) NSMutableArray *searchResultModels;
@property (strong, nonatomic) MerchantTypeTableView *merchantTypeView;
@property (strong, nonatomic) NSMutableArray<MerchantTypeVO *> *merchantTypeArray;

@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) BOOL isSearch;

@property (assign, nonatomic) int page;

@end

@implementation BussnessListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"社区商家";
    self.bussnessModels = [NSMutableArray array];
    self.searchResultModels = [NSMutableArray array];
    self.merchantTypeArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];
    self.selectedIndex = 0;
    self.isSearch = NO;
    [self initViews];
//    [self getBussnessData];
    [self.tableView.mj_header beginRefreshing];
    [self.merchantNametextField becomeFirstResponder];
}

- (void)getBussnessData{
    [self.bussnessModels removeAllObjects];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    [[ServicesManager getAPI] getMerchants:0 name:nil onComplete:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        
        for (MerchantVO *model in list) {
            [self.bussnessModels addObject:model];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        
    }];
    
}

- (void)getBussnessTypeView{
    [self.merchantTypeArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [My_ServicesManager getMerchantTypes:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            MerchantTypeVO *mytype = [[MerchantTypeVO alloc] init];
            mytype.business_type_name = @"选择类型";
            [self.merchantTypeArray addObject:mytype];
            for (MerchantTypeVO *type in list) {
                [self.merchantTypeArray addObject:type];
                
            }
            self.merchantTypeView = [[MerchantTypeTableView alloc] initWithWidth:120.f itemHeight:30.f itemNames:self.merchantTypeArray];
            self.merchantTypeView.fontSize = 14.0;
            self.merchantTypeView.backColor = [UIColor whiteColor];
            self.merchantTypeView.textColor = [UIColor blackColor];
            self.merchantTypeView.dropDelegate = self;
            [SVProgressHUD dismiss];
            
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            [window addSubview:self.merchantTypeView];

        }
    }];

}

- (void)initViews{
    
    //创建搜索视图
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,40)];
    
    self.chooseTypeBtn = [[BussnessSelectButton alloc]initWithFrame:CGRectMake(5, 5, self.view.width * 0.35 , 30)];
    self.chooseTypeBtn.titleLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    [self.chooseTypeBtn setTitle:@"选择类型" forState:UIControlStateNormal];
    [self.chooseTypeBtn addTarget:self action:@selector(chooseTypeBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [searchView addSubview:self.chooseTypeBtn];
    
    self.merchantNametextField = [[UITextField alloc]initWithFrame:CGRectMake(self.chooseTypeBtn.right + 5, 5, self.view.width * 0.35, 30)];
    self.merchantNametextField.borderStyle = UITextBorderStyleNone;
    self.merchantNametextField.layer.borderWidth = 1;
    self.merchantNametextField.layer.borderColor = My_Color(236, 236, 236).CGColor;
    self.merchantNametextField.placeholder = @" 请输入商家名称";
    self.merchantNametextField.font = FontSize(CONTENT_FONT-1);
    self.merchantNametextField.backgroundColor = [UIColor whiteColor];
    self.merchantNametextField.delegate = self;
    self.merchantNametextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.merchantNametextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.merchantNametextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    [searchView addSubview:self.merchantNametextField];
    
    UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(self.merchantNametextField.right + 15, 5, self.view.width - self.merchantNametextField.right - 25, 30)];
    
    search.backgroundColor = My_NAV_BG_Color;
    search.layer.cornerRadius = 5;
    search.clipsToBounds = YES;
    search.titleLabel.font = FontSize(CONTENT_FONT);
    [search setTitle:@"查询" forState:UIControlStateNormal];
    [search addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:search];
    
    [self.view addSubview:searchView];
    

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5+searchView.bottom, self.view.width-10, self.view.height-74-searchView.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 100/667.0*My_ScreenH;
//    self.tableView.bounces = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MerchargeListCell" bundle:nil]forCellReuseIdentifier:@"MerchargeListCell"];
    [self initRefreshView];
    [self.view addSubview:self.tableView];
    
    
}

//设置上拉下拉刷新
- (void)initRefreshView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getBussnessData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
}

- (void)loadMoreData{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    [[ServicesManager getAPI] getMerchants:++self.page name:nil onComplete:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        
        for (MerchantVO *model in list) {
            [self.bussnessModels addObject:model];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
    }];

}


- (void)chooseTypeBtnOnclicked:(UIButton *)button{
    [self getBussnessTypeView];
}

- (void)clickSearchBtn{
    self.isSearch = YES;
    [self.merchantNametextField resignFirstResponder];
    [self.searchResultModels removeAllObjects];
    for (MerchantVO *merchant in self.bussnessModels) {
        if (self.selectedIndex != 0) {
           NSString *typeId = [self.merchantTypeArray[self.selectedIndex] Id];
            if ([merchant.business_type_id isEqualToString:typeId]) {
                if ([self.merchantNametextField.text isEqualToString:@""]) {
                    [self.searchResultModels addObject:merchant];
                }else if([merchant.business_name containsString:self.merchantNametextField.text]){
                    [self.searchResultModels addObject:merchant];
                }
            }
        }else{
            if ([self.merchantNametextField.text isEqualToString:@""]) {
                [self.searchResultModels addObjectsFromArray: self.bussnessModels];
                self.isSearch = NO;
            }else if([merchant.business_name containsString:self.merchantNametextField.text] ){
                [self.searchResultModels addObject:merchant];
            }
        }
    }
    [self.tableView reloadData];
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.merchantNametextField resignFirstResponder];
}

#pragma mark - MerchantTypeTableViewDelegate
- (void)itemSelected:(NSInteger)index{
    self.selectedIndex = index;
    [self.chooseTypeBtn setTitle:[self.merchantTypeArray[index] business_type_name]forState:UIControlStateNormal];
    [self.merchantTypeView removeFromSuperview];
}

- (void)dropMenuHidden{
    [self.merchantTypeView removeFromSuperview];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.isSearch) {
        return self.bussnessModels.count;
    }else{
        return self.searchResultModels.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MerchargeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MerchargeListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isSearch) {
        [(MerchargeListCell *)cell loadDataFromMercharge:self.bussnessModels[indexPath.row]];
    }else{
        [(MerchargeListCell *)cell loadDataFromMercharge:self.searchResultModels[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BussnessDetailVC *detail = [[BussnessDetailVC alloc] init];
    if (!self.isSearch) {
        detail.merchant = self.bussnessModels[indexPath.row];
    }else{
        detail.merchant = self.searchResultModels[indexPath.row];
    }
    [self .navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
