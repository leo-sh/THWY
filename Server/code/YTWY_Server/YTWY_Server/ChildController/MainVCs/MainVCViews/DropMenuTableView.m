//
//  DropMenuTableView.m
//  YTWY_Server
//
//  Created by wei on 16/8/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "DropMenuTableView.h"

@interface DropMenuTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *itemNames;

@property (strong, nonatomic) NSArray *itemImages;

@end

@implementation DropMenuTableView

- (instancetype)initWithWidth:(CGFloat)width itemHeight:(CGFloat)itemHeight itemNames:(NSArray *)items ItemImages:(NSArray *)images{
    
    if (self = [super init]) {
        self.itemNames = items;
        self.itemImages = images;
        self.frame = CGRectMake(0, 64, My_ScreenW, My_ScreenH);
        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.01];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(7, 0, width, items.count*itemHeight) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = itemHeight;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.itemImages[indexPath.row]];
    cell.textLabel.text = self.itemNames[indexPath.row];
    cell.textLabel.backgroundColor = My_clearColor;
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.font = [UIFont fontWithName:My_RegularFontName size:self.fontSize];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = self.backColor;
    
    if (indexPath.row < self.itemNames.count - 1) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = My_Color(229.f, 229.f, 229.f);
        [cell.contentView addSubview:line];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.dropDelegate itemSelected:indexPath.row];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
    [self.dropDelegate dropMenuHidden];
}

- (void)refreshUpdateIcon:(BOOL)haveUpdate{
    if (haveUpdate) {
        self.itemNames = @[@"我要报修", @"我要投诉", @"账号信息",@"我的积分", @"推送设置", @"技术支持", @"版本更新"];
        self.itemImages = @[@"main_1", @"main_2", @"main_6",@"main_3", @"main_4", @"main_5", @"main_versionrefresh"];
        [self.tableView reloadData];
    }else{
        self.itemNames = @[@"我要报修", @"我要投诉", @"账号信息",@"我的积分", @"推送设置", @"技术支持"];
        self.itemImages = @[@"main_1", @"main_2", @"main_6",@"main_3", @"main_4", @"main_5"];
        [self.tableView reloadData];
    }
}

@end
