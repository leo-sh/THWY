//
//  BussnessCircleVC.m
//  THWY_Client
//
//  Created by wei on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BussnessCircleVC.h"
#import "YFLBBannerView.h"
#import "Masonry.h"
#import "MerchantVO.h"
#import "AdVO.h"
#import "UIImageView+WebCache.h"
#import "BussnessDetailVC.h"
#import "BussnessListVC.h"
#import "RecommandBussnessListVC.h"
#import "RecommandBussnessADVC.h"
#import "ProclamationInfoViewController.h"

#define HEIGHT self.view.height*1/8.0

@interface BussnessCircleVC ()<ZYBannerViewDataSource, ZYBannerViewDelegate>

@property (strong, nonatomic) NSMutableArray *adDataArray;
@property (strong, nonatomic) NSMutableArray *adLabels;

@property (strong, nonatomic) YFLBBannerView *scrollView;
@property (strong, nonatomic) UIView *userInfoView;

@property (strong, nonatomic) UIButton *ADView;
@property (strong, nonatomic) UILabel *ADLabel;
@property (assign, nonatomic) NSInteger scrollIndex;
@property (strong, nonatomic) UIScrollView *adLabelScrollView;
@property (strong, nonatomic) UIImageView *laba;

@property (strong, nonatomic) NSTimer *adLabelTimer;

@end

@implementation BussnessCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"社区商圈";
    self.scrollIndex = -1;
    self.adLabels = [NSMutableArray array];
//    self.adDataArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];
    [self getData];
    
}

#pragma mark - 轮播图
- (void)getData{
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    self.adDataArray = [[NSMutableArray alloc] init];
    [[ServicesManager getAPI] getRecommendMerchants:1 onComplete:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
    
        for (MerchantVO * model in list) {
            if (model) {
                [self.adDataArray addObject:model];
            }
        }
        
        [SVProgressHUD dismiss];
            
        [self initADScrollView];
        [self getADLabels];
        
    }];
    
}

- (void)initADScrollView{
    
    self.scrollView = [[YFLBBannerView alloc] init];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bannerload"]];
    self.scrollView.showFooter = NO;
    self.scrollView.autoScroll = YES;
    self.scrollView.shouldLoop = YES;
    self.scrollView.scrollInterval = 2.0;
    self.scrollView.delegate = self;
    self.scrollView.dataSource = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.25);
    }];
    [self initUserInfo];
    [self initAdViews];
    
}

#pragma mark - ZYBannerViewDataSource
// 返回Banner需要显示Item(View)的个数
- (NSInteger)numberOfItemsInBanner:(YFLBBannerView *)banner{
    return self.adDataArray.count;
}

// 返回Banner在不同的index所要显示的View (可以是完全自定义的view, 且无需设置frame)
- (UIView *)banner:(YFLBBannerView *)banner viewForItemAtIndex:(NSInteger)index {

    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.adDataArray[index] pic]] placeholderImage:[UIImage imageNamed:@"bannerload"]];
    
    return imageView;
}

#pragma mark - ZYBannerViewDelegate
// 在这里实现点击事件的处理
- (void)banner:(YFLBBannerView *)banner didSelectItemAtIndex:(NSInteger)index{
    MerchantVO *merchantVO = self.adDataArray[index];
    BussnessDetailVC *detail = [[BussnessDetailVC alloc] init];
    [My_ServicesManager getAMerchant:merchantVO.Id onComplete:^(NSString *errorMsg, MerchantVO *merchant) {
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            detail.merchant = merchant;
            [self.navigationController pushViewController:detail animated:YES];
        }
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 用户信息
- (void)initUserInfo{
    
    self.userInfoView = [[UIView alloc]init];
    [self.view addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.scrollView.mas_height).multipliedBy(2.0/3);
    }];
    
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.image = [UIImage imageNamed:@"Avatar"];
    headImage.userInteractionEnabled = YES;
    headImage.layer.cornerRadius = self.view.height*1.0/12*0.85;
//    headImage.layer.borderWidth = 3;
//    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    headImage.clipsToBounds = YES;
    [self.userInfoView addSubview:headImage];
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userInfoView.mas_centerY);
        make.left.mas_equalTo(self.userInfoView).offset(10);
        make.height.mas_equalTo(self.userInfoView.mas_height).multipliedBy(0.85);
        make.width.mas_equalTo(headImage.mas_height);
    }];
    
    UILabel *username = [[UILabel alloc] init];
    username.text = @"";
    username.font = FontSize(CONTENT_FONT+1);
    [username sizeToFit];
    [self.userInfoView addSubview:username];
    
    [username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headImage.mas_centerY).multipliedBy(0.75);
        make.left.mas_equalTo(headImage.mas_right).offset(15);
    }];
    
    UILabel *addr = [[UILabel alloc] init];
    addr.text = @"";
    addr.font = FontSize(CONTENT_FONT+1);
    [addr sizeToFit];
    [self.userInfoView addSubview:addr];
    [addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(username.mas_left);
        make.centerY.mas_equalTo(headImage.mas_centerY).multipliedBy(1.25);
    }];
    
    UserVO *user = [[UDManager getUD] getUser];
    if (user) {
        [headImage sd_setImageWithURL:[NSURL URLWithString: user.avatar] placeholderImage:[UIImage imageNamed:@"Avatar"]];
        username.text = user.real_name;
        addr.text = [NSString stringWithFormat:@"%@·%@栋%@单元%@室",[user.houses[0] estate],[user.houses[0] block],[user.houses[0] unit],[user.houses[0] mph]];
    }
    
}

#pragma mark - ADViews
- (void)getADLabels{

    [[ServicesManager getAPI] getAds:1 onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
//            return ;
        }else{
            if(list.count == 0){
                self.ADLabel.text = @"暂无公告信息";
            }else{
                for (int i = 0; i < list.count;i++) {
                    AdVO *model = list[i];
                    self.adLabelScrollView.contentSize = CGSizeMake(self.view.width*6/7.0, HEIGHT*list.count);
                    if (model) {
                        [self.adLabels addObject:model];
                        UIButton *adbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT*i, self.view.width*6/7.0, HEIGHT)];
                        adbtn.tag = 500+i;
                        [adbtn addTarget:self action:@selector(showAdDetail:) forControlEvents:UIControlEventTouchUpInside];
                        adbtn.titleLabel.font = FontSize(CONTENT_FONT+1);
                        [adbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        adbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        adbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, (70-18)*0.5, 0);
                        //                    adbtn.titleLabel.centerY = self.laba.centerY;
                        [self.adLabelScrollView addSubview:adbtn];
                        [adbtn setTitle:model.title forState:UIControlStateNormal];
                        if (i == list.count-1){
                            [self.adLabels addObject:list[0]];
                            UIButton *adbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT*(i+1), self.view.width*6/7.0, HEIGHT)];
                            adbtn.tag = 500+i+1;
                            [adbtn addTarget:self action:@selector(showAdDetail:) forControlEvents:UIControlEventTouchUpInside];
                            adbtn.titleLabel.font = FontSize(CONTENT_FONT+1);
                            [adbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            adbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            adbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, (70-18)*0.5, 0);
                            //                    adbtn.titleLabel.centerY = self.laba.centerY;
                            [self.adLabelScrollView addSubview:adbtn];
                            [adbtn setTitle:[list[0] title] forState:UIControlStateNormal];
                        }
                    }
                    self.ADLabel.hidden = YES;
                }

            }
            
            if (self.adLabels.count>0) {
                self.scrollIndex = 0;
                self.adLabelTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(runloopAdLabel) userInfo:nil repeats:YES];
                
            }        
        }
        [SVProgressHUD dismiss];
        
    }];
}

- (void)runloopAdLabel{
    if (!self.adLabels){
        return;
    }
    if (self.scrollIndex<self.adLabels.count-2) {
        self.scrollIndex++;
        [UIView animateWithDuration:0.5 animations:^{
            self.adLabelScrollView.contentOffset = CGPointMake(0, self.scrollIndex*HEIGHT);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollIndex++;
            self.adLabelScrollView.contentOffset = CGPointMake(0, self.scrollIndex*HEIGHT);
        }];
        self.scrollIndex = 0;
        self.adLabelScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)initAdViews{
    self.ADView = [[UIButton alloc] init];
    [self.ADView setImage:[UIImage imageNamed:@"bussness_锯齿"] forState:UIControlStateNormal];
    [self.ADView setImage:[UIImage imageNamed:@"bussness_锯齿"] forState:UIControlStateHighlighted];
//    [self.ADView addTarget:self action:@selector(showAdDetail) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.ADView];
    [self.ADView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userInfoView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.userInfoView.mas_height).multipliedBy(0.65);
    }];
    
    self.laba = [[UIImageView alloc] initWithImage:[UIImage scaleImage:[UIImage imageNamed:@"bussness_喇叭"] toScale:0.6]];
    [self.ADView addSubview:self.laba];
    [self.laba mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ADView.centerY).offset(-2);
        make.left.mas_equalTo(self.ADView.mas_left).offset(20);
    }];
    
    self.adLabelScrollView = [[UIScrollView alloc] init];
    self.adLabelScrollView.backgroundColor = [UIColor clearColor];
    self.adLabelScrollView.showsVerticalScrollIndicator = NO;
    self.adLabelScrollView.showsHorizontalScrollIndicator = NO;
    self.adLabelScrollView.bounces = NO;
    self.adLabelScrollView.scrollEnabled = NO;
    [self.ADView addSubview:self.adLabelScrollView];
    
    [self.adLabelScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.laba.mas_centerY);
        make.left.mas_equalTo(self.laba.mas_right).offset(10);
        make.right.mas_equalTo(self.ADView.mas_right);
        make.height.mas_equalTo(self.ADView.mas_height).multipliedBy(0.7);
    }];
    
    self.ADLabel = [[UILabel alloc] init];
    self.ADLabel.text = @"加载数据中，请稍等...";
//    self.ADLabel.textColor = [UIColor whiteColor];
    [self.adLabelScrollView addSubview:self.ADLabel];
    [self.ADLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.laba.mas_right).offset(10);
        make.centerY.mas_equalTo(self.laba.mas_centerY);
    }];
    
    NSArray *labelNames = @[@"社区商家", @"推介商品&服务", @"商圈广告"];
    NSArray *iconNames = @[@"bussness_社区商家", @"bussness_推荐商品", @"bussness_商圈广告"];
    
    for(int i = 0; i<labelNames.count; i++){
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:iconNames[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@按下",iconNames[i]]] forState:UIControlStateHighlighted];
        button.tag = i+200;
        [button addTarget:self action:@selector(btnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ADView.mas_bottom).offset(50);
            make.left.mas_equalTo(self.view.mas_left).offset(self.view.width/4.5*i*1.5+self.view.width/4.5*0.25);
            make.width.and.height.mas_equalTo(self.view.mas_width).multipliedBy(1/4.5);
        }];
        UILabel *btnLabel = [[UILabel alloc] init];
        btnLabel.text = labelNames[i];
        btnLabel.textColor = [UIColor darkGrayColor];
        [btnLabel sizeToFit];
        btnLabel.font = FontSize(CONTENT_FONT);
        [self.view addSubview:btnLabel];
        [btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(button.mas_centerX);
            make.top.mas_equalTo(button.mas_bottom).offset(15);
        }];
    }
    
}

- (void)showAdDetail:(UIButton *)btn{
    
    if (self.adLabels.count-1<btn.tag-501) {
        return;
    }
    
    ProclamationInfoViewController *detail = [[ProclamationInfoViewController alloc] init];
    if (self.adLabels[btn.tag-501]) {
        detail.proclamationId = [self.adLabels[self.scrollIndex] Id];
        detail.type = 1;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

- (void)btnOnclicked:(UIButton *)button{
    switch (button.tag-200) {
        case 0:{//社区商家
            BussnessListVC *list = [[BussnessListVC alloc] init];
            [self.navigationController pushViewController:list animated:YES];
            break;
        }
        case 1:{//推荐商品
            RecommandBussnessListVC *list = [[RecommandBussnessListVC alloc] init];
            [self.navigationController pushViewController:list animated:YES];
            break;
        }
        case 2:{//商区广告
            RecommandBussnessADVC *list = [[RecommandBussnessADVC alloc] init];
            [self.navigationController pushViewController:list animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
