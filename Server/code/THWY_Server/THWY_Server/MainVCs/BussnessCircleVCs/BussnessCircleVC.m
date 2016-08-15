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
#import "ADDetailVC.h"

@interface BussnessCircleVC ()<ZYBannerViewDataSource, ZYBannerViewDelegate>

@property (strong, nonatomic) NSMutableArray *adDataArray;
@property (strong, nonatomic) NSMutableArray *adLabels;

@property (strong, nonatomic) YFLBBannerView *scrollView;
@property (strong, nonatomic) UIView *userInfoView;
@property (strong, nonatomic) UIButton *ADView;
@property (strong, nonatomic) UILabel *ADLabel;

@property (strong, nonatomic) NSTimer *adLabelTimer;

@end

@implementation BussnessCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"社区商圈";
    self.adLabels = [NSMutableArray array];
//    self.adDataArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]]];
    [self getData];
    [self getADLabels];
}

#pragma mark - 轮播图
- (void)getData{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.adDataArray = [[NSMutableArray alloc] init];
    [[ServicesManager getAPI] getRecommendMerchants:1 onComplete:^(NSString *errorMsg, NSArray *list) {
        for (MerchantVO * model in list) {
            if (model) {
                [self.adDataArray addObject:model];
            }
        }
        [SVProgressHUD dismiss];
        [self initADScrollView];
    }];
    
}

- (void)initADScrollView{
    
    self.scrollView = [[YFLBBannerView alloc] init];
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
            [SVProgressHUD setMinimumDismissTimeInterval:1.3];
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            detail.merchant = merchant;
            [SVProgressHUD dismiss];
            [self.navigationController pushViewController:detail animated:YES];
        }
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
    headImage.layer.borderWidth = 3;
    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    headImage.clipsToBounds = YES;
    [self.userInfoView addSubview:headImage];
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userInfoView.mas_centerY);
        make.left.mas_equalTo(self.userInfoView).offset(30);
        make.height.mas_equalTo(self.userInfoView.mas_height).multipliedBy(0.85);
        make.width.mas_equalTo(headImage.mas_height);
    }];
    
    UILabel *username = [[UILabel alloc] init];
    username.text = @"name";
    username.font = [UIFont fontWithName:My_RegularFontName size:16];
    [username sizeToFit];
    [self.userInfoView addSubview:username];
    
    [username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headImage.mas_centerY).multipliedBy(0.75);
        make.left.mas_equalTo(headImage.mas_right).offset(15);
    }];
    
    UILabel *addr = [[UILabel alloc] init];
    addr.text = @"地址";
    addr.font = [UIFont fontWithName:My_RegularFontName size:16];
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
        addr.text = user.estate;
    }
    
}

#pragma mark - ADViews
- (void)getADLabels{

    [[ServicesManager getAPI] getAds:1 onComplete:^(NSString *errorMsg, NSArray *list) {
        for (AdVO *model in list) {
            if (model) {
                [self.adLabels addObject:model];
            }
        }
        if (self.adLabels) {
            self.adLabelTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(runloopAdLabel) userInfo:nil repeats:YES];
        }
    }];
}
static int flag = 0;
- (void)runloopAdLabel{
    if (!self.adLabels){
        return;
    }
    if (flag<self.adLabels.count) {
        AdVO *model = self.adLabels[flag];
        [UIView animateWithDuration:2.0 animations:^{
            self.ADLabel.text = model.title;
        }];
        flag++;
    }else{
        flag = 0;
    }
}

- (void)initAdViews{
    self.ADView = [[UIButton alloc] init];
    [self.ADView setImage:[UIImage imageNamed:@"bussness_锯齿"] forState:UIControlStateNormal];
    [self.ADView setImage:[UIImage imageNamed:@"bussness_锯齿"] forState:UIControlStateHighlighted];
    [self.ADView addTarget:self action:@selector(showAdDetail) forControlEvents:UIControlEventTouchUpInside];
//    [self.ADView ;
    [self.view addSubview:self.ADView];
    [self.ADView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userInfoView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.userInfoView.mas_height).multipliedBy(0.75);
    }];
    
    UIImageView *laba = [[UIImageView alloc] initWithImage:[UIImage scaleImage:[UIImage imageNamed:@"bussness_喇叭"] toScale:0.6]];
    [self.ADView addSubview:laba];
    [laba mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ADView.centerY).offset(-2);
        make.left.mas_equalTo(self.ADView.mas_left).offset(30);
    }];
    
    self.ADLabel = [[UILabel alloc] init];
    [self.ADLabel sizeToFit];
    self.ADLabel.font = [UIFont fontWithName:My_RegularFontName size:16];
    self.ADLabel.textColor = [UIColor whiteColor];
    self.ADLabel.text = @"加载中...";
    [self.ADView addSubview:self.ADLabel];
    [self.ADLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(laba.mas_centerY);
        make.left.mas_equalTo(laba.mas_right).offset(10);
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
        btnLabel.font = [UIFont fontWithName:My_RegularFontName size:16.0];
        [self.view addSubview:btnLabel];
        [btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(button.mas_centerX);
            make.top.mas_equalTo(button.mas_bottom).offset(15);
        }];
    }
    
}

- (void)showAdDetail{
    
    ADDetailVC *detail = [[ADDetailVC alloc] init];
    if (self.adLabels[flag]) {
        detail.advo = self.adLabels[flag];
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
