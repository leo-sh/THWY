//
//  BussnessDetailVC.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BussnessDetailVC.h"
#import "GoodsVC.h"
#import "MerchantDetailVC.h"

@interface BussnessDetailVC ()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *descLabel;

@property (strong, nonatomic) UIButton *btnContact;
@property (strong, nonatomic) UIButton *btnShowDetail;

@property (strong, nonatomic) MerchantVO *selectedMerchant;

@end

@implementation BussnessDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家详情";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景"]];
    [self initViews];
    [self getMerchantInfo];
}

- (void)initViews{
    
    NSInteger topMargin = 10.0/375*My_ScreenW;
    self.bgView = [[UIView alloc] init];
    [self.bgView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(self.view.height/3.6);

    }];
    NSInteger iconHeight = (self.view.height*1/4.0-3*topMargin)*2/3.0;
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
    self.nameLabel.font = FontSize(CONTENT_FONT + 2);
    [self.nameLabel sizeToFit];
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(topMargin);
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(10);
        make.height.mas_equalTo(iconHeight*0.2);
    }];
    
    self.descLabel = [[UILabel alloc] init];
    
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.merchant.intro dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.descLabel.text = attrStr.string;
    self.descLabel.textColor = [UIColor lightGrayColor];
    self.descLabel.font = FontSize(CONTENT_FONT);
    self.descLabel.numberOfLines = 0;
    self.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.descLabel sizeToFit];
    [self.bgView addSubview:self.descLabel];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:My_RegularFontName size:15.0],NSFontAttributeName, nil];
    CGRect rect = [self.descLabel.text boundingRectWithSize:CGSizeMake(self.view.width-2*topMargin-iconHeight, iconHeight*0.8) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];

    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.width.mas_equalTo(rect.size.width);
        make.height.mas_equalTo(iconHeight*0.8);
    }];

    
    self.btnContact = [[UIButton alloc] init];
    [self.btnContact setTitle:@"联系商家" forState:UIControlStateNormal];
    [self.btnContact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnContact setBackgroundColor:My_NAV_BG_Color];
    self.btnContact.titleLabel.font = FontSize(CONTENT_FONT);
    [self.btnContact addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
    self.btnContact.layer.cornerRadius = 2;
    self.btnContact.clipsToBounds = YES;
    [self.bgView addSubview:self.btnContact];
    [self.btnContact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX).multipliedBy(0.5);
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(topMargin*1.5);
        make.width.mas_equalTo((self.view.width-4*topMargin)*0.5);
        make.height.mas_equalTo(iconHeight*1.5/3.0);
    }];
    
    self.btnShowDetail = [[UIButton alloc] init];
    [self.btnShowDetail setTitle:@"进入商家" forState:UIControlStateNormal];
    [self.btnShowDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnShowDetail.titleLabel.font = FontSize(CONTENT_FONT);
    [self.btnShowDetail setBackgroundColor:My_NAV_BG_Color];
    self.btnShowDetail.layer.cornerRadius = 2;
    self.btnShowDetail.clipsToBounds = YES;
    [self.btnShowDetail addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.btnShowDetail];
    [self.btnShowDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX).multipliedBy(1.5);
        make.top.mas_equalTo(self.btnContact.mas_top);
        make.width.mas_equalTo(self.btnContact.mas_width);
        make.height.mas_equalTo(self.btnContact.mas_height);
    }];
    
}

- (void)getMerchantInfo{
    [SVProgressHUD showWithStatus:@"正在加载数据，请稍等......"];
    [My_ServicesManager getAMerchant:self.merchant.Id onComplete:^(NSString *errorMsg, MerchantVO *merchant) {
        
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            
//            if (merchant.products.count == 0){
//                self.btnShowDetail.hidden = YES;
////                [SVProgressHUD showErrorWithStatus:@"没有商品"];
//            }else{
//            }
//            
//            if ([merchant.telephone isEqualToString:@""]) {
//                self.btnContact.hidden = YES;
//            }
            
            self.selectedMerchant = merchant;
        }
        
    }];

}

- (void)contact:(UIButton *)btn{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.merchant.telephone message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phoneNum = self.merchant.telephone;// 电话号码
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
        [[UIApplication sharedApplication] openURL:phoneURL];

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

- (void)showDetail:(UIButton *)btn{
    
    MerchantDetailVC *detail = [[MerchantDetailVC alloc] init];
    detail.merchant = self.selectedMerchant;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
