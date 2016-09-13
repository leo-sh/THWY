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

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AlertTableView

- (void)initViews{
    
    NSInteger height = 50.0;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    confirm.contentEdgeInsets = UIEdgeInsetsMake(15, 14.5,  15 , 14.5);
    [confirm setImage:[UIImage imageNamed:@"√"] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:confirm];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(self.width-confirm.width, 0, height, height)];
    cancel.contentEdgeInsets = UIEdgeInsetsMake(15, 14.5,  15 , 14.5);
    [cancel setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.height-0.2, headerView.width, 0.2)];
    line.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:line];
    [self addSubview:headerView];
    
    for (int i = 0; i<self.data.count; i++) {
        [self.folded addObject:@(NO)];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.height, self.frame.size.width, self.frame.size.height-headerView.height) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.bounces = NO;
    self.tableView.sectionFooterHeight = 0.01;
    self.tableView.sectionHeaderHeight = height;
    [self addSubview:self.tableView];
}

- (void)confirm{
    [self.AlertDelegate confirm:self.flags flag:self.flag];
    [self hideView];
}

- (void)cancel{
    [self hideView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.flag == 3) {
        return 1;
    }else{
        return self.data.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.flag == 3) {
        return self.data.count;
    }else{
        if ([self.folded[section] boolValue]) {
            return 0;
        }else{
            return [[self.data[section] child] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if([self.flags containsObject:indexPath]){
        cell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_代勾"] toScale:0.7];
    }else{
        cell.imageView.image = [UIImage scaleImage:[UIImage imageNamed:@"repaire_不代勾"] toScale:0.7];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RepairClassVO *model = nil;
    if (self.flag == 3) {
        model = self.data[indexPath.row];
    }else{
        model = [self.data[indexPath.section] child][indexPath.row];
    }
    if(self.flag == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (￥%@)",model.class_name, model.class_price];
    }else{
        cell.textLabel.text = model.class_name;
    }
    cell.textLabel.font = FontSize(CONTENT_FONT-1);
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

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 40.0/667*My_ScreenH)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = FontSize(CONTENT_FONT-1);;
    [button setTitle:[NSString stringWithFormat:@"  %@",[self.data[section] class_name]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.tag = section+20;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.2;
    [button addTarget:self action:@selector(sectionFolded:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, button.height-0.4, button.width, 0.4)];
    line.backgroundColor = [UIColor lightGrayColor];
    [button addSubview:line];

    return button;
                      
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.flag == 3) {
        return 0;
    }else{
        return 40/667.0*My_ScreenH;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)showInWindow
{
    [self.tableView reloadData];
    [self showInWindowWithBackgoundTapDismissEnable:NO];
}

- (void)sectionFolded:(UIButton *)btn{
    NSInteger index = btn.tag-20;
    self.folded[index] = @(![self.folded[index] boolValue]);
    [self.tableView reloadData];
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
