//
//  ProclamationInfoViewController.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/14.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ProclamationInfoViewController.h"
#import "ServicesManager.h"
@interface ProclamationInfoViewController ()
@end

@implementation ProclamationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    
    UIImage *backGround = [UIImage imageNamed:@"背景2"];
    self.view.layer.contents = (id)backGround.CGImage;
}

- (void)getData
{
    if ([ServicesManager getAPI].status == NotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络访问错误"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"正在加载数据，请稍等······"];
        
        [[ServicesManager getAPI]getANote:self.proclamationId onComplete:^(NSString *errorMsg, NoteVO *complaint) {
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
                
            }
            else
            {
                self.title = complaint.title;
                [self createUI:complaint];
                [SVProgressHUD dismiss];
            }

            
        }];
    }

}

- (void)createUI:(NoteVO *)noteVO
{
    
    UIImageView *head = [[UIImageView alloc]init];
    UIImageView *right = [[UIImageView alloc]init];
    UILabel *titleLabel = [[UILabel alloc]init];
    UILabel *time = [[UILabel alloc]init];
    UILabel *content = [[UILabel alloc]init];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10 , self.view.width - 20, 0)];

    head.frame = CGRectMake(0, 0, backView.width, 3);
    right.frame = CGRectMake(0, 0, 20, 20);
    right.center = CGPointMake(backView.width -9, 0);
    titleLabel.frame = CGRectMake(0, CGRectGetMaxY(head.frame) + 5, backView.width, 30);
    
    time.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), backView.width, 14);
    
    CGSize size = [noteVO.content sizeWithFont:FontSize(CONTENT_FONT) maxSize:CGSizeMake(4000, 4000)];
    
    
    content.frame = CGRectMake(10, time.bottom + 10, size.width, size.height);
    
    backView.height = content.bottom + 10;
    
    backView.backgroundColor = [UIColor whiteColor];
    
    head.image = [UIImage imageNamed:@"彩条"];
    
    UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    left.center = CGPointMake(19, 10);
    left.image = [UIImage imageNamed:@"左"];
    
    right.image = [UIImage imageNamed:@"右"];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    time.font = [UIFont systemFontOfSize:11];
    
    time.textAlignment = NSTextAlignmentCenter;
    
    time.textColor = [UIColor lightGrayColor];
    
    content.font = FontSize(CONTENT_FONT);
    [backView addSubview:titleLabel];
    [backView addSubview:time];
    [backView addSubview:head];
    [backView addSubview:content];
    [self.view addSubview:left];
    [backView addSubview:right];
    
    
    backView.backgroundColor = WhiteAlphaColor;
    
    [self.view addSubview:backView];
    
    titleLabel.text = noteVO.title;
    NSString *showtime = [NSString stringDateFromTimeInterval:[noteVO.ctime longLongValue] withFormat:@"YYYY-MM-dd HH:SS"];
    time.text = showtime;
    content.text = noteVO.content;
    
    
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
