//
//  MainVC.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MainVC.h"
#import "DTKDropdownMenuView.h"
#import "Masonry/Masonry.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserVO.h"
#import "UDManager.h"
#import "DTKDropdownMenuView.h"

#import "PersonInfoViewController.h"
#import "DTKDropdownMenuView.h"

@interface MainVC ()

@property UIButton *userInfoView;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNVBar];
    [self initUserInfoView];
    [self initModuleViews];
    [self initDownMenu];
    
}

- (void)initNVBar{

    self.title = @"业主客服系统";
    
}

#pragma mark - drownMenu
- (void)initDownMenu{
    UIButton *button = [[UIButton alloc] init];
    button.tag = 0;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我要报修" callBack:^(NSUInteger index, id info) {
        button.tag = 101;
        [self showVC:button];
    }];
    item0.iconName = @"main_1";
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"我要投诉" callBack:^(NSUInteger index, id info) {
        button.tag = 105;
        [self showVC:button];
    }];
    item1.iconName = @"main_2";
    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"业务公告" callBack:^(NSUInteger index, id info) {
        button.tag = 108;
        [self showVC:button];
    }];
    item2.iconName = @"main_3";
    DTKDropdownItem *item3 = [DTKDropdownItem itemWithTitle:@"推送设置" callBack:^(NSUInteger index, id info) {
        button.tag = 109;
        [self showVC:button];
    }];
    item3.iconName = @"main_4";
    DTKDropdownItem *item4 = [DTKDropdownItem itemWithTitle:@"技术支持" callBack:^(NSUInteger index, id info) {
        button.tag = 110;
        [self showVC:button];
    }];
    item4.iconName = @"main_5";
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeLeftItem frame:CGRectMake(0, 0, 44.f, 44.f) dropdownItems:@[item0,item1,item2,item3,item4] icon:@"menu"];
    
    menuView.dropWidth = 130.f;
//    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor whiteColor];
    menuView.textFont = [UIFont systemFontOfSize:13.f];
    menuView.cellSeparatorColor = My_Color(229.f, 229.f, 229.f);
    menuView.animationDuration = 0.3f;
    menuView.cellColor = My_NAV_BG_Color;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];

}

#pragma mark - UserInfo
//用户信息
- (void)initUserInfoView{
    
    self.userInfoView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, My_ScreenW, 1/4.0 * (My_ScreenH-64) - 20)];
    [self.userInfoView setBackgroundImage:[UIImage imageNamed:@"beijing"] forState:UIControlStateNormal];
    [self.userInfoView addTarget:self action:@selector(showUserInfoVC) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.image = [UIImage imageNamed:@"头像1"];
    headImage.userInteractionEnabled = YES;
    headImage.layer.cornerRadius = self.userInfoView.bounds.size.height/4;
    headImage.layer.borderWidth = 3;
    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    headImage.clipsToBounds = YES;
    [self.userInfoView addSubview:headImage];
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userInfoView.mas_centerY);
        make.left.mas_equalTo(self.userInfoView).offset(30);
        make.height.mas_equalTo(self.userInfoView.mas_height).multipliedBy(0.5);
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
    
    UIImageView *locationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dizhi"]];
    [self.userInfoView addSubview:locationImage];
    [locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(username.mas_left);
        make.top.mas_equalTo(username.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
    
    UILabel *addr = [[UILabel alloc] init];
    addr.text = @"地址";
    addr.font = [UIFont fontWithName:My_RegularFontName size:16];
    [addr sizeToFit];
    [self.userInfoView addSubview:addr];
    [addr mas_makeConstraints:^(MASConstraintMaker *make) {
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
    UserVO *user = [[UDManager getUD] getUser];
    if (user) {
        [headImage sd_setImageWithURL:[NSURL URLWithString: user.avatar] placeholderImage:[UIImage imageNamed:@"头像1"]];
        username.text = user.real_name;
        addr.text = user.estate;
    }
}

#pragma mark - 各模块控件
- (void)initModuleViews{
    UIButton *woyaobaoxiu = [[UIButton alloc] init];
    woyaobaoxiu.tag = 101;
    [woyaobaoxiu setBackgroundImage:[UIImage imageNamed:@"我要保修"] forState:UIControlStateNormal];
    [self.view addSubview:woyaobaoxiu];
    [woyaobaoxiu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(self.userInfoView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((My_ScreenW-30)*0.5, (((My_ScreenH-64)*3.0/4.0-10)*0.5-10)*0.5));
    }];
    
    UIButton *baoxiujilu = [[UIButton alloc] init];
    baoxiujilu.tag = 102;
    [baoxiujilu setBackgroundImage:[UIImage imageNamed:@"保修记录"] forState:UIControlStateNormal];
    [self.view addSubview:baoxiujilu];
    [baoxiujilu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaobaoxiu.mas_left);
        make.top.mas_equalTo(woyaobaoxiu.mas_bottom).offset(10);
        make.width.and.height.mas_equalTo(woyaobaoxiu);
    }];
    
    UIButton *shequshangquan = [[UIButton alloc] init];
    shequshangquan.tag = 103;
    [shequshangquan setBackgroundImage:[UIImage imageNamed:@"社区商圈"] forState:UIControlStateNormal];
    [self.view addSubview:shequshangquan];
    [shequshangquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(baoxiujilu.mas_left);
        make.top.mas_equalTo(baoxiujilu.mas_bottom).offset(10);
        make.width.mas_equalTo(woyaobaoxiu.mas_width);
        make.height.mas_equalTo(baoxiujilu.mas_height).multipliedBy(2.0).offset(10);
    }];
    
    UIButton *jiaofeitaizhang = [[UIButton alloc] init];
    jiaofeitaizhang.tag = 104;
    [jiaofeitaizhang setBackgroundImage:[UIImage imageNamed:@"缴费台账"] forState:UIControlStateNormal];
    [self.view addSubview:jiaofeitaizhang];
    [jiaofeitaizhang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaobaoxiu.mas_right).offset(10);
        make.top.mas_equalTo(woyaobaoxiu.mas_top);
        make.width.and.height.mas_equalTo(woyaobaoxiu);
    }];
    
    UIButton *woyaotousu = [[UIButton alloc] init];
    woyaotousu.tag = 105;
    [woyaotousu setBackgroundImage:[UIImage imageNamed:@"我要投诉"] forState:UIControlStateNormal];
    [self.view addSubview:woyaotousu];
    [woyaotousu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(baoxiujilu.mas_right).offset(10);
        make.top.mas_equalTo(baoxiujilu.mas_top);
        make.height.mas_equalTo(baoxiujilu);
        make.width.mas_equalTo(baoxiujilu.mas_width).multipliedBy(0.5).offset(-5);
    }];
    
    UIButton *zhanghaoxinxi = [[UIButton alloc] init];
    zhanghaoxinxi.tag = 106;
    [zhanghaoxinxi setBackgroundImage:[UIImage imageNamed:@"账号信息"] forState:UIControlStateNormal];
    [self.view addSubview:zhanghaoxinxi];
    [zhanghaoxinxi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaotousu.mas_right).offset(10);
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
        make.top.mas_equalTo(jianyiyijian.mas_bottom).offset(10);
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

#pragma  mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
