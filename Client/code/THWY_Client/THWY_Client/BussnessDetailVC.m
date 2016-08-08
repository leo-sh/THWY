//
//  BussnessDetailVC.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BussnessDetailVC.h"

@interface BussnessDetailVC ()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *descLabel;

@property (strong, nonatomic) UIButton *btnContact;
@property (strong, nonatomic) UIButton *btnShowDetail;

@end

@implementation BussnessDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家详情";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]];
    [self initViews];
    
}

- (void)initViews{
    
    NSInteger topMargin = 10.0/375*My_ScreenW;
    self.bgView = [[UIView alloc] init];
    [self.bgView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(self.view.height*1/3.0);
    }];
    NSInteger iconHeight = (self.view.height*1/3.0-4*topMargin)*2/3.0;
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像1"]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.merchant.pic] placeholderImage:nil];
    self.iconImageView.layer.cornerRadius = iconHeight*0.5;
    self.iconImageView.clipsToBounds = YES;
    [self.bgView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(topMargin);
        make.top.mas_equalTo(self.bgView.mas_top).offset(topMargin);
        make.height.mas_equalTo(iconHeight);
        make.width.mas_equalTo(self.iconImageView.mas_height);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = self.merchant.business_name;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont fontWithName:My_RegularFontName size:16.0];
    [self.nameLabel sizeToFit];
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(topMargin);
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.height.mas_equalTo(iconHeight*0.25);
    }];
    
    self.descLabel = [[UILabel alloc] init];
    
    NSArray *strings = [self.merchant.intro componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n<>\t\r&nbsp"]];
    for (NSString *string in strings) {
        for(int i=0; i< [string length];i++){
            int a = [string characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff){
//                self.desc.text = string;
                self.descLabel.text = string;
            }
            
        }
    }
    
    self.descLabel.textColor = [UIColor lightGrayColor];
    self.descLabel.font = [UIFont fontWithName:My_RegularFontName size:15.0];
    self.descLabel.numberOfLines = 0;
    self.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.descLabel sizeToFit];
    [self.bgView addSubview:self.descLabel];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:My_RegularFontName size:15.0],NSFontAttributeName, nil];
    CGRect rect = [self.descLabel.text boundingRectWithSize:CGSizeMake(self.view.width-2*topMargin-iconHeight, iconHeight*0.75) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];

    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.width.mas_equalTo(rect.size.width);
        make.height.mas_equalTo(iconHeight*0.75);
    }];

    
    self.btnContact = [[UIButton alloc] init];
    [self.btnContact setTitle:@"联系商家" forState:UIControlStateNormal];
    [self.btnContact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnContact setBackgroundColor:My_NAV_BG_Color];
    [self.btnContact addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.btnContact];
    [self.btnContact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX).multipliedBy(0.5);
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(topMargin*1.5);
        make.width.mas_equalTo((self.view.width-4*topMargin)*0.5);
        make.height.mas_equalTo(iconHeight*1/3.0);
    }];
    
    self.btnShowDetail = [[UIButton alloc] init];
    [self.btnShowDetail setTitle:@"进入商家" forState:UIControlStateNormal];
    [self.btnShowDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnShowDetail setBackgroundColor:My_NAV_BG_Color];
    [self.btnContact addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.btnShowDetail];
    [self.btnShowDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX).multipliedBy(1.5);
        make.top.mas_equalTo(self.btnContact.mas_top);
        make.width.mas_equalTo(self.btnContact.mas_width);
        make.height.mas_equalTo(self.btnContact.mas_height);
    }];
    
}

- (void)contact:(UIButton *)btn{
    NSString *phoneNum = self.merchant.telephone;// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
    //    if ( !self.phoneCallWebView ) {
    //        self.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    //    }
    //    [self.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [[UIApplication sharedApplication] openURL:phoneURL];

}

- (void)showDetail:(UIButton *)btn{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
