//
//  MerchantTypeTableView.m
//  YTWY_Client
//
//  Created by wei on 16/8/15.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MerchantTypeTableView.h"

@interface MerchantTypeTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray<MerchantTypeVO *> *itemNames;

@end

@implementation MerchantTypeTableView

- (instancetype)initWithWidth:(CGFloat)width itemHeight:(CGFloat)itemHeight itemNames:(NSArray<MerchantTypeVO *> *)items{
    
    if (self = [super init]) {
        self.itemNames = items;
        self.frame = CGRectMake(0, 0, My_ScreenW, My_ScreenH);
//        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.2];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 90, width, items.count*itemHeight) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = itemHeight;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
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
    cell.textLabel.text = [self.itemNames[indexPath.row] business_type_name];
    cell.textLabel.backgroundColor = self.backColor;
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.font = [UIFont fontWithName:My_RegularFontName size:self.fontSize];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = self.backColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    label.backgroundColor = My_Color(229.f, 229.f, 229.f);
    [cell.contentView addSubview:label];
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


@end
