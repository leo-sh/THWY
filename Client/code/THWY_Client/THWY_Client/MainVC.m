//
//  MainVC.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MainVC.h"
#import "Masonry/Masonry.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserVO.h"
#import "UDManager.h"
#import "PersonInfoViewController.h"
#import "DropMenuTableView.h"

#define topMargin  8.0/375*My_ScreenW

@interface MainVC ()<DropTableMenuDelegate>

@property (strong, nonatomic) UIButton *userInfoView;
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *username;
@property (strong, nonatomic) UILabel *addr;

@property (strong, nonatomic) DropMenuTableView *dropView;

@property (strong, nonatomic) UIButton *leftButton;

@property (assign, nonatomic) NSInteger flag;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNVBar];
    [self initUserInfoView];
    [self initModuleViews];
    [My_NoteCenter addObserver:self selector:@selector(refreshUserInfo) name:Login_Success object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refreshUserInfo];
}

- (void)refreshUserInfo{
    
    [My_ServicesManager getUserInfoOnComplete:^(NSString *errorMsg, UserVO *user) {
        if (user) {
            [self.headImage sd_setImageWithURL:[NSURL URLWithString: user.avatar] placeholderImage:[UIImage imageNamed:@"头像1"]];
            self.username.text = user.real_name;
            self.addr.text = user.estate;
        }
    }];
}

- (void)initNVBar{

    self.flag = -1;
    self.title = @"业主客服系统";
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.leftButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftItemOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem  = left;
    
    self.dropView = [[DropMenuTableView alloc] initWithWidth:130.f itemHeight:40.f itemNames:@[@"我要报修", @"我要投诉", @"业务公告", @"推送设置", @"技术支持"] ItemImages:@[@"main_1", @"main_2", @"main_3", @"main_4", @"main_5"]];
    self.dropView.fontSize = 15.0;
    self.dropView.backColor = My_NAV_BG_Color;
    self.dropView.textColor = [UIColor whiteColor];
    
    self.dropView.dropDelegate = self;
}

- (void)leftItemOnclicked:(UIButton *)button{
    
    if (self.flag == -1) {
        [button setBackgroundImage:[UIImage imageNamed:@"anxia"] forState:UIControlStateNormal];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        
        [window addSubview:self.dropView];
        self.flag = 1;
    }else{
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [self.dropView removeFromSuperview];
        self.flag = -1;
    }
    
}

- (void)itemSelected:(NSInteger)index{
    UIButton *button = [[UIButton alloc] init];
    button.tag = 0;
    switch (index) {
        case 0:{
            button.tag = 101;
            [self showVC:button];
            break;
        }
        case 1:{
            button.tag = 105;
            [self showVC:button];
            break;
        }
        case 2:{
            button.tag = 108;
            [self showVC:button];
            break;
        }
        case 3:{
            button.tag = 109;
            [self showVC:button];
            break;
        }
        case 4:{
            button.tag = 110;
            [self showVC:button];
            break;
        }
        default:
            break;
    }
    [self.dropView removeFromSuperview];
    [self.leftButton setBackgroundImage:nil forState:UIControlStateNormal];

}

- (void)dropMenuHidden{
    [self.leftButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark - UserInfo
//用户信息
- (void)initUserInfoView{
    
    self.userInfoView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, My_ScreenW, 1/4.0 * (My_ScreenH-64) - topMargin*2)];
    [self.userInfoView setBackgroundImage:[UIImage imageNamed:@"beijing"] forState:UIControlStateNormal];
    [self.userInfoView addTarget:self action:@selector(showUserInfoVC) forControlEvents:UIControlEventTouchUpInside];
    self.headImage = [[UIImageView alloc] init];
    self.headImage.image = [UIImage imageNamed:@"头像1"];
    self.headImage.userInteractionEnabled = YES;
    self.headImage.layer.cornerRadius = self.userInfoView.bounds.size.height/4;
    self.headImage.layer.borderWidth = 3;
    self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImage.clipsToBounds = YES;
    [self.userInfoView addSubview:self.headImage];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userInfoView.mas_centerY);
        make.left.mas_equalTo(self.userInfoView).offset(30);
        make.height.mas_equalTo(self.userInfoView.mas_height).multipliedBy(0.5);
        make.width.mas_equalTo(self.headImage.mas_height);
    }];
    
    
    self.username = [[UILabel alloc] init];
    self.username.text = @"name";
    self.username.font = [UIFont fontWithName:My_RegularFontName size:16];
    [self.username sizeToFit];
    [self.userInfoView addSubview:self.username];
    
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImage.mas_centerY).multipliedBy(0.75);
        make.left.mas_equalTo(self.headImage.mas_right).offset(15);
    }];
    
    UIImageView *locationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dizhi"]];
    [self.userInfoView addSubview:locationImage];
    [locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.username.mas_left);
        make.top.mas_equalTo(self.username.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
    
    self.addr = [[UILabel alloc] init];
    self.addr.text = @"地址";
    self.addr.font = [UIFont fontWithName:My_RegularFontName size:16];
    [self.addr sizeToFit];
    [self.userInfoView addSubview:self.addr];
    [self.addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(locationImage.mas_right).offset(4);
        make.centerY.mas_equalTo(locationImage.mas_centerY);
    }];
    
    UIImageView *more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头"]];
    [self.userInfoView addSubview:more];
    [more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userInfoView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 20));
        make.right.mas_equalTo(self.userInfoView.mas_right).offset(-30);
    }];
    
    [self.view addSubview:self.userInfoView];

}

#pragma mark - 各模块控件
- (void)initModuleViews{
    UIButton *woyaobaoxiu = [[UIButton alloc] init];
    woyaobaoxiu.tag = 101;
    [woyaobaoxiu setBackgroundImage:[UIImage imageNamed:@"我要保修"] forState:UIControlStateNormal];
    [self.view addSubview:woyaobaoxiu];
    [woyaobaoxiu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(topMargin);
        make.top.mas_equalTo(self.userInfoView.mas_bottom).offset(topMargin);
        make.size.mas_equalTo(CGSizeMake((My_ScreenW-3*topMargin)*0.5, (((My_ScreenH-64)*3.0/4.0-topMargin)*0.5-topMargin)*0.5));
    }];
    
    UIButton *baoxiujilu = [[UIButton alloc] init];
    baoxiujilu.tag = 102;
    [baoxiujilu setBackgroundImage:[UIImage imageNamed:@"保修记录"] forState:UIControlStateNormal];
    [self.view addSubview:baoxiujilu];
    [baoxiujilu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaobaoxiu.mas_left);
        make.top.mas_equalTo(woyaobaoxiu.mas_bottom).offset(topMargin);
        make.width.and.height.mas_equalTo(woyaobaoxiu);
    }];
    
    UIButton *shequshangquan = [[UIButton alloc] init];
    shequshangquan.tag = 103;
    [shequshangquan setBackgroundImage:[UIImage imageNamed:@"社区商圈"] forState:UIControlStateNormal];
    [self.view addSubview:shequshangquan];
    [shequshangquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(baoxiujilu.mas_left);
        make.top.mas_equalTo(baoxiujilu.mas_bottom).offset(topMargin);
        make.width.mas_equalTo(woyaobaoxiu.mas_width);
        make.height.mas_equalTo(baoxiujilu.mas_height).multipliedBy(2.0).offset(topMargin);
    }];
    
    UIButton *jiaofeitaizhang = [[UIButton alloc] init];
    jiaofeitaizhang.tag = 104;
    [jiaofeitaizhang setBackgroundImage:[UIImage imageNamed:@"缴费台账"] forState:UIControlStateNormal];
    [self.view addSubview:jiaofeitaizhang];
    [jiaofeitaizhang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaobaoxiu.mas_right).offset(topMargin);
        make.top.mas_equalTo(woyaobaoxiu.mas_top);
        make.width.and.height.mas_equalTo(woyaobaoxiu);
    }];
    
    UIButton *woyaotousu = [[UIButton alloc] init];
    woyaotousu.tag = 105;
    [woyaotousu setBackgroundImage:[UIImage imageNamed:@"我要投诉"] forState:UIControlStateNormal];
    [self.view addSubview:woyaotousu];
    [woyaotousu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(baoxiujilu.mas_right).offset(topMargin);
        make.top.mas_equalTo(baoxiujilu.mas_top);
        make.height.mas_equalTo(baoxiujilu);
        make.width.mas_equalTo(baoxiujilu.mas_width).multipliedBy(0.5).offset(-topMargin*0.5);
    }];
    
    UIButton *zhanghaoxinxi = [[UIButton alloc] init];
    zhanghaoxinxi.tag = 106;
    [zhanghaoxinxi setBackgroundImage:[UIImage imageNamed:@"账号信息"] forState:UIControlStateNormal];
    [self.view addSubview:zhanghaoxinxi];
    [zhanghaoxinxi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaotousu.mas_right).offset(topMargin);
        make.top.mas_equalTo(woyaotousu.mas_top);
        make.width.and.height.mas_equalTo(woyaotousu);
    }];
    
    [zhanghaoxinxi addTarget:self action:@selector(showVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *jianyiyijian = [[UIButton alloc] init];
    jianyiyijian.tag = 107;
    [jianyiyijian setBackgroundImage:[UIImage imageNamed:@"建议意见"] forState:UIControlStateNormal];
    [self.view addSubview:jianyiyijian];
    [jianyiyijian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(jiaofeitaizhang.mas_left);
        make.top.mas_equalTo(shequshangquan.mas_top);
        make.width.and.height.mas_equalTo(jiaofeitaizhang);
    }];
    
    UIButton *yezhugonggao = [[UIButton alloc] init];
    yezhugonggao.tag = 108;
    [yezhugonggao setBackgroundImage:[UIImage imageNamed:@"业主公告"] forState:UIControlStateNormal];
    [self.view addSubview:yezhugonggao];
    [yezhugonggao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(jianyiyijian.mas_left);
        make.top.mas_equalTo(jianyiyijian.mas_bottom).offset(topMargin);
        make.width.and.height.mas_equalTo(jiaofeitaizhang);
    }];
    
    NSArray *buttons = @[woyaobaoxiu, baoxiujilu, shequshangquan, jiaofeitaizhang, woyaotousu, zhanghaoxinxi, jianyiyijian, yezhugonggao];
    for (UIButton *button in buttons) {
        [button addTarget:self action:@selector(showVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
//pushVC
- (void)showVC:(UIButton *)button{

    NSArray *VCNames = @[@"WantRepairesVC",//我要报修
                         @"RepairRecordsVC",//报修记录
                         @"BussnessCircleVC",//社区商圈
                         @"PayViewController",//缴费台账
                         @"ComplainViewController",//我要投诉
                         @"PersonInfoViewController",//账号信息
                         @"SuggestViewController",//建议意见
                         @"ProclamationViewController",//业主和公告
                         @"PushSettingVC",//推送设置
                         @"TechSupportVC"];//技术支持
    id vc = [[NSClassFromString(VCNames[button.tag-101]) alloc]init];
    if (vc) {
        [self.navigationController pushViewController:(UIViewController *)vc animated:YES];
    }else{
        NSLog(@"vc  is  nill");
    }
}

- (void)showUserInfoVC{
    UIButton *button = [[UIButton alloc] init];
    button.tag = 106;
    [self showVC:button];
}

- (void)dealloc{
    [My_NoteCenter removeObserver:self name:Login_Success object:nil];
}

#pragma  mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
