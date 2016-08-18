//
//  AlertEstateTableView.m
//  THWY_Server
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertEstateTableView.h"
#import "EstateVO.h"

@interface AlertEstateTableView ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation AlertEstateTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self initTableHeaderView];
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        self.sectionFooterHeight = 0;
        self.selectedIndex = -1;
    }
    return self;
    
}

- (void)initTableHeaderView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 45.0)];
    headerView.backgroundColor = self.backgroundColor;
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, headerView.height-10, headerView.height-10)];
    [confirm setBackgroundImage:[UIImage imageNamed:@"√"] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:confirm];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(self.width-5-confirm.width, 5, headerView.height-10, headerView.height-10)];
    [cancel setBackgroundImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.height-0.2, headerView.width, 0.2)];
    line.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:line];
    self.tableHeaderView = headerView;
    
    self.sectionHeaderHeight = headerView.height;
    
}

- (void)confirm{
    
    if (self.selectedIndex == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择项目"];
        return;
    }
    
    [self.AlertDelegate commit:self.selectedIndex];
    [self hideView];
}

- (void)cancel{
    [self hideView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.data.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == self.selectedIndex) {
         cell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_selected"] toScale:0.7];
    }else{
        cell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_unselected"] toScale:0.7];
    }

    switch (self.type) {
        case AlertEstateType:{
            EstateVO *model = self.data[indexPath.row];
            cell.textLabel.text = model.estate_name;
            break;
        }
        case AlertChooseEstateType:{
            EstateVO *model = self.data[indexPath.row];
            cell.textLabel.text = model.estate_name;
            break;
        }
        default:
            if ([self.data[indexPath.row] isKindOfClass:[NSString class]]) {
                cell.textLabel.text = self.data[indexPath.row];
            }else if ([self.data[indexPath.row] isKindOfClass:[NSNumber class]]){
                cell.textLabel.text = [self.data[indexPath.row] stringValue];
            }
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:My_RegularFontName size:14.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectedIndex != -1) {
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        oldCell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_unselected"] toScale:0.7];        
    }
    
    self.selectedIndex = indexPath.row;
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    newCell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_selected"] toScale:0.7];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.type == AlertChooseEstateType) {
        UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 45.0)];
        [allBtn setTitle:@"全部小区" forState:UIControlStateNormal];
        [allBtn setBackgroundColor:[UIColor clearColor]];
        [allBtn addTarget:self action:@selector(btnOnclicked) forControlEvents:UIControlEventTouchUpInside];
        return allBtn;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type == AlertChooseEstateType) {
        return 45.0;
    }else{
        return 0;
    }
}

- (void)btnOnclicked{
    
    UITableViewCell *oldCell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    oldCell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_unselected"] toScale:0.7];
    
    self.selectedIndex = -1;
}

@end
