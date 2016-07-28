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
}

- (void)initNVBar{

    self.title = @"业主客服系统";
    
}

//用户信息
- (void)initUserInfoView{
    
    self.userInfoView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, My_ScreenW, 1/4.0 * (My_ScreenH-64) - 20)];
    [self.userInfoView setBackgroundImage:[UIImage imageNamed:@"beijing"] forState:UIControlStateNormal];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    headImage.image = [UIImage imageNamed:@"头像1"];
    headImage.userInteractionEnabled = YES;
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
        make.top.mas_equalTo(headImage.mas_top).offset(10);
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
    UserVO *user = [UserVO fromCodingObject];
    if (user) {
        [headImage sd_setImageWithURL:[NSURL URLWithString: user.avatar] placeholderImage:[UIImage imageNamed:@"头像1"]];
        username.text = user.real_name;
        addr.text = @"";
    }
}

//各模块控件
- (void)initModuleViews{
    UIButton *woyaobaoxiu = [[UIButton alloc] init];
    [woyaobaoxiu setBackgroundImage:[UIImage imageNamed:@"我要保修"] forState:UIControlStateNormal];
    [self.view addSubview:woyaobaoxiu];
    [woyaobaoxiu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(self.userInfoView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((My_ScreenW-30)*0.5, (((My_ScreenH-64)*3.0/4.0-10)*0.5-10)*0.5));
    }];
    
    UIButton *baoxiujilu = [[UIButton alloc] init];
    [baoxiujilu setBackgroundImage:[UIImage imageNamed:@"保修记录"] forState:UIControlStateNormal];
    [self.view addSubview:baoxiujilu];
    [baoxiujilu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaobaoxiu.mas_left);
        make.top.mas_equalTo(woyaobaoxiu.mas_bottom).offset(10);
        make.width.and.height.mas_equalTo(woyaobaoxiu);
    }];
    
    UIButton *shequshangquan = [[UIButton alloc] init];
    [shequshangquan setBackgroundImage:[UIImage imageNamed:@"社区商圈"] forState:UIControlStateNormal];
    [self.view addSubview:shequshangquan];
    [shequshangquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(baoxiujilu.mas_left);
        make.top.mas_equalTo(baoxiujilu.mas_bottom).offset(10);
        make.width.mas_equalTo(woyaobaoxiu.mas_width);
        make.height.mas_equalTo(baoxiujilu.mas_height).multipliedBy(2.0).offset(10);
    }];
    
    UIButton *jiaofeitaizhang = [[UIButton alloc] init];
    [jiaofeitaizhang setBackgroundImage:[UIImage imageNamed:@"缴费台账"] forState:UIControlStateNormal];
    [self.view addSubview:jiaofeitaizhang];
    [jiaofeitaizhang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaobaoxiu.mas_right).offset(10);
        make.top.mas_equalTo(woyaobaoxiu.mas_top);
        make.width.and.height.mas_equalTo(woyaobaoxiu);
    }];
    
    UIButton *woyaotousu = [[UIButton alloc] init];
    [woyaotousu setBackgroundImage:[UIImage imageNamed:@"我要投诉"] forState:UIControlStateNormal];
    [self.view addSubview:woyaotousu];
    [woyaotousu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(baoxiujilu.mas_right).offset(10);
        make.top.mas_equalTo(baoxiujilu.mas_top);
        make.height.mas_equalTo(baoxiujilu);
        make.width.mas_equalTo(baoxiujilu.mas_width).multipliedBy(0.5).offset(-5);
    }];
    
    UIButton *zhanghaoxinxi = [[UIButton alloc] init];
    [zhanghaoxinxi setBackgroundImage:[UIImage imageNamed:@"账号信息"] forState:UIControlStateNormal];
    [self.view addSubview:zhanghaoxinxi];
    [zhanghaoxinxi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(woyaotousu.mas_right).offset(10);
        make.top.mas_equalTo(woyaotousu.mas_top);
        make.width.and.height.mas_equalTo(woyaotousu);
    }];
    
    UIButton *jianyiyijian = [[UIButton alloc] init];
    [jianyiyijian setBackgroundImage:[UIImage imageNamed:@"建议意见"] forState:UIControlStateNormal];
    [self.view addSubview:jianyiyijian];
    [jianyiyijian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(jiaofeitaizhang.mas_left);
        make.top.mas_equalTo(shequshangquan.mas_top);
        make.width.and.height.mas_equalTo(jiaofeitaizhang);
    }];
    
    UIButton *yezhugonggao = [[UIButton alloc] init];
    [yezhugonggao setBackgroundImage:[UIImage imageNamed:@"业主公告"] forState:UIControlStateNormal];
    [self.view addSubview:yezhugonggao];
    [yezhugonggao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(jianyiyijian.mas_left);
        make.top.mas_equalTo(jianyiyijian.mas_bottom).offset(10);
        make.width.and.height.mas_equalTo(jiaofeitaizhang);
    }];
    
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
