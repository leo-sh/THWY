//
//  BussnessListVC.m
//  YTWY_Client
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
@property (strong, nonatomic) MerchantTypeTableView *merchantTypeView;
@property (strong, nonatomic) NSMutableArray<MerchantTypeVO *> *merchantTypeArray;

@property (assign, nonatomic) int page;
@property NSString* searchName;
@property NSString* searchTypeId;

@end

@implementation BussnessListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"社区商家";
    self.searchName = @"";
    self.searchTypeId = @"";
    self.bussnessModels = [NSMutableArray array];
    self.merchantTypeArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];
    [self initViews];
    self.page = 0;
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    [self getBussnessData];
    [self.merchantNametextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.merchantNametextField resignFirstResponder];
    [self.merchantTypeView removeFromSuperview];
}

- (void)getBussnessData{
    
    [[ServicesManager getAPI] getMerchants:self.page typeId:self.searchTypeId name:self.searchName onComplete:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
            if (self.page != 0) {
                self.page --;
            }
        }else
        {
            if (self.page == 0) {
                [self.bussnessModels removeAllObjects];
            }else if (list && list.count == 0) {
                self.page--;
            }
            for (MerchantVO *model in list) {
                [self.bussnessModels addObject:model];
            }
            
            if (self.tableView.numberOfSections > 0) {
                
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                
                [self.tableView reloadData];
            }
            [SVProgressHUD dismiss];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    
}

- (void)getBussnessTypeView{
    [self.merchantTypeArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
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
            self.merchantTypeView = [[MerchantTypeTableView alloc] initWithWidth:100.f itemHeight:30.f itemNames:self.merchantTypeArray];
            
            self.merchantTypeView.fontSize = 14.0;
            self.merchantTypeView.backColor = [UIColor whiteColor];
            self.merchantTypeView.textColor = [UIColor blackColor];
            self.merchantTypeView.dropDelegate = self;
            [SVProgressHUD dismiss];
            
            [My_KeyWindow addSubview:self.merchantTypeView];

        }
    }];

}

- (void)initViews{
    //创建搜索视图
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,40)];
    
    self.chooseTypeBtn = [[BussnessSelectButton alloc]initWithFrame:CGRectMake(5, 5, self.view.width * 0.35 , 30)];
    self.chooseTypeBtn.titleLabel.font = FontSize(CONTENT_FONT);
    [self.chooseTypeBtn setTitle:@"选择类型" forState:UIControlStateNormal];
    [self.chooseTypeBtn addTarget:self action:@selector(chooseTypeBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [searchView addSubview:self.chooseTypeBtn];
    
    self.merchantNametextField = [[UITextField alloc]initWithFrame:CGRectMake(self.chooseTypeBtn.right + 5, 5, self.view.width * 0.35, 30)];
    self.merchantNametextField.borderStyle = UITextBorderStyleNone;
    self.merchantNametextField.layer.borderWidth = 1;
    self.merchantNametextField.layer.borderColor = My_Color(236, 236, 236).CGColor;
    self.merchantNametextField.placeholder = @"请输入商家名称";
    self.merchantNametextField.leftViewMode = UITextFieldViewModeAlways;
    self.merchantNametextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.merchantNametextField.font = FontSize(CONTENT_FONT);
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
    self.page ++ ;
    [self getBussnessData];
}

- (void)chooseTypeBtnOnclicked:(UIButton *)button{
    if (self.merchantTypeArray.count > 0) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self.merchantTypeView];
    }else
    {
        [self getBussnessTypeView];
    }
}

- (void)clickSearchBtn{
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    [self.merchantNametextField endEditing:YES];
    self.searchName = self.merchantNametextField.text;
    
    self.page = 0;
    [self getBussnessData];
    
    [self.tableView reloadData];
    
}

#pragma mark - UITextFieldDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.merchantNametextField resignFirstResponder];
}

#pragma mark - MerchantTypeTableViewDelegate
- (void)itemSelected:(NSInteger)index{
    self.searchTypeId = [self.merchantTypeArray[index] Id];
    [self.chooseTypeBtn setTitle:[self.merchantTypeArray[index] business_type_name]forState:UIControlStateNormal];
    [self.merchantTypeView removeFromSuperview];
}

- (void)dropMenuHidden{
    [self.merchantTypeView removeFromSuperview];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bussnessModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MerchargeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MerchargeListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [(MerchargeListCell *)cell loadDataFromMercharge:self.bussnessModels[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BussnessDetailVC *detail = [[BussnessDetailVC alloc] init];
    detail.merchant = self.bussnessModels[indexPath.row];
    [self .navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.merchantNametextField resignFirstResponder];
}


@end
