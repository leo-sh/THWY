//
//  AlertTableView.m
//  THWY_Client
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertTableView.h"
#import "RepairClassVO.h"

@interface AlertTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *flags;

@property (strong, nonatomic) NSMutableArray *folded;


@end

@implementation AlertTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self initTableHeaderView];
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        self.sectionFooterHeight = 0;
    }
    return self;
    
}

- (void)initTableHeaderView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40.0/667*My_ScreenH)];
    headerView.backgroundColor = self.backgroundColor;
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, headerView.height-10, headerView.height-10)];
    [confirm setBackgroundImage:[UIImage imageNamed:@"√"] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:confirm];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(self.width-5-confirm.width, 5, headerView.height-10, headerView.height-10)];
    [cancel setBackgroundImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancel];
    
    self.tableHeaderView = headerView;
    
    self.sectionHeaderHeight = headerView.height;
    
}

- (void)confirm{
    [self.AlertDelegate confirm:self.flags flag:self.flag];
}

- (void)cancel{
    [self hideView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    for (int i = 0; i<self.data.count; i++) {
        [self.folded addObject:@(YES)];
    }
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.folded[section] boolValue]) {
        return 0;
    }else{
        return [[self.data[section] child] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_不代勾"] toScale:0.7];
    RepairClassVO *model = [self.data[indexPath.section] child][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (￥%@)",model.class_name, model.class_price];
    cell.textLabel.font = [UIFont fontWithName:My_RegularFontName size:14.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.flags containsObject:indexPath]) {
         cell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_不代勾"] toScale:0.7];
        [self.flags removeObject:indexPath];
    }else{
        [self.flags addObject:indexPath];
        cell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_代勾"] toScale:0.7];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.tableHeaderView.height)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName:My_RegularFontName size:15.0];
    [button setTitle:[self.data[section] class_name] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor lightTextColor]];
    button.tag = section+20;
    button.layer.borderColor = [UIColor lightTextColor].CGColor;
    button.layer.borderWidth = 1;
    [button addTarget:self action:@selector(sectionFolded:) forControlEvents:UIControlEventTouchUpInside];
    return button;
                      
}

- (void)sectionFolded:(UIButton *)btn{
    NSInteger index = btn.tag-20;
    self.folded[index] = @(![self.folded[index] boolValue]);
    [self reloadData];
}

- (NSMutableArray *)flags{
    if (!_flags) {
        _flags = [NSMutableArray array];
    }
    return _flags;
}

- (NSMutableArray *)folded{
    if ((!_folded)) {
        _folded = [NSMutableArray array];
    }
    return _folded;
}

@end
