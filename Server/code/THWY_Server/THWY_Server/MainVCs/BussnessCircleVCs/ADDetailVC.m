//
//  ADDetailVC.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ADDetailVC.h"
#import "BussnessADCell.h"

@interface ADDetailVC ()

@end

@implementation ADDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商圈广告详情";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景2"]]];
    [self initView];
}

- (void)initView{
    
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"BussnessADCell" owner:nil options:nil];
    BussnessADCell *cell = (BussnessADCell *)nibView[0];
    [cell loadDataFromMercharge:self.advo];
    [self.view addSubview:cell.contentView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
