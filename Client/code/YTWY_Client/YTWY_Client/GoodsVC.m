//
//  GoodsVC.m
//  YTWY_Client
//
//  Created by wei on 16/8/8.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "GoodsVC.h"

@interface GoodsVC ()

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *desc;
@property (strong, nonatomic) UILabel *location;

@end

@implementation GoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]];
    [self getBussnessData];
    
}

- (void)getBussnessData{
    
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    [My_ServicesManager getAGood:self.good.Id onComplete:^(NSString *errorMsg, GoodVO *merchant) {

        if (errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            [self initView:merchant];
        }
        
        [SVProgressHUD dismiss];
    }];
    
}

- (void)initView:(GoodVO *)merchant{
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    
    NSArray *strings = [merchant.goods_intro componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n<>\t\r"]];
    NSString *addrString = [NSString string];
    for (NSString *string in strings) {
        for(int i=0; i< [string length];i++){
            int a = [string characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff){
                addrString = string;
            }
            
        }
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(14.0),NSFontAttributeName, nil];
    CGRect rect1 = [addrString boundingRectWithSize:CGSizeMake(My_ScreenW-110, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(rect1.size.height+100);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
    }];
    
    bgView.backgroundColor = WhiteAlphaColor;
    self.icon = [UIImageView new];
    self.icon.layer.cornerRadius = 40;
    self.icon.clipsToBounds = YES;
    [bgView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(5);
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.width.and.height.mas_equalTo(80);
    }];
    
    self.name = [UILabel new];
    self.name.textColor = [UIColor blackColor];
    self.name.font = FontBoldSize(16.0);
    [self.name sizeToFit];
    [bgView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        make.top.mas_equalTo(bgView.mas_top).offset(10);
    }];
    
    self.desc = [UILabel new];
    self.desc.textColor = [UIColor darkGrayColor];
    self.desc.font = FontSize(15.0);
    self.desc.numberOfLines = 0;
    [bgView addSubview:self.desc];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_left);
        make.top.mas_equalTo(self.name.mas_bottom);
        make.width.mas_equalTo(My_ScreenW-120);
    }];
    
    self.location = [UILabel new];
    self.location.textColor = [UIColor darkGrayColor];
    self.location.font = FontSize(15.0);
    [self.location sizeToFit];
    [bgView addSubview:self.location];
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_left);
        make.bottom.mas_equalTo(bgView.mas_bottom).offset(-10);
    }];

    [self.icon sd_setImageWithURL:[NSURL URLWithString:merchant.pic] placeholderImage:[UIImage imageNamed:@"头像1"]];
    self.name.text = merchant.goods_name;
    self.desc.text = addrString;
    
    [[ServicesManager getAPI] getAMerchant:merchant.business_id onComplete:^(NSString *errorMsg, MerchantVO *merchant) {
        self.location.text = merchant.addr;
    }];
    
}


@end
