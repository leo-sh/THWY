//
//  RepairStatistisVC.m
//  THWY_Server
//
//  Created by wei on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairStatistisVC.h"

@interface RepairStatistisVC ()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIButton *

@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation RepairStatistisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    [self getData];
    [self initViews];
}

- (void)getData{

}

- (void)initViews{
    
    
}

@end
