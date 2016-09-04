//
//  TechSupportVC.m
//  YTWY_Server
//
//  Created by wei on 16/8/11.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "TechSupportVC.h"

@interface TechSupportVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *label;
@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation TechSupportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"技术支持";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景2"]]];
    self.text = @"     华汇软件有限公司成立于2014年，自成立伊始，一直专注于集团型企业、品质地产企业、物业管理领域的企业信息化建设，是鄂尔多斯市本土首家拥有3项以上软件自主知识产权认证企业，公司立足于物业服务ERP系统、智能家居机器人及VR虚拟现实智能管家、智慧社区、智能家居、智能安防、移动支付集成、APP手机客户端应用软件开发、物业服务ERP系统SaaS软件租赁平台建设、微信企业号及应用号开发、集团型企业内部应用软件定制开发、集团型高端网站设计业务，面向客户提供全面的互联网移动互联应用软件定制咨询及软件开发服务，以提升运营效率为服务重点，面向具体运营环境，提供从基础体系规划、建设到后期运维的全方位解决方案。\n      在企业发展过程中，始终秉承“以客户需求为目标，以技术创新为动力”的创业之道，以“与客户共同成长”为企业发展的目标，将技术和行业创新作为企业的核心竞争力，在数字化物业服务ERP系统及SaaS平台开发建设等领域拥有完备的产品及服务体系，将更多创新理念源源不断融入到智慧社区平台开发中，使其日臻完善。\n     目前公司业务主要针对鄂尔多斯市本土市场，今后企业会投入更大精力将业务扩展到以呼、包、鄂为中心的区内外市场，为更多的房地产企业、物业管理企业、集团型企业、政府相关单位提供更加本地化、互联网化的定制型软件开发和平台建设服务。";
    [self initViews];
}

- (void)initViews{
    
    NSInteger topMargin = 8.0/375*My_ScreenW;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:My_RegularFontName size:15.0],NSFontAttributeName, nil];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(My_ScreenW-2*topMargin, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.label.text = self.text;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.numberOfLines = 0;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = [UIFont fontWithName:My_RegularFontName size:15.0];
    self.label.textColor = [UIColor blackColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(topMargin, topMargin, My_ScreenW-2*topMargin , My_ScreenH-2*topMargin-64)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(My_ScreenW-2*topMargin, rect.size.height);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView addSubview:self.label];
    [self.view addSubview:self.scrollView];
}



@end
