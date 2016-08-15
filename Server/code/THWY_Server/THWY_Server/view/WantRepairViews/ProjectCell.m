//
//  ProjectCell.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ProjectCell.h"
#import "AlertEstateTableView.h"
#import "EstateVO.h"

@interface ProjectCell()<AlertEstateTableViewDelegate>

@property (strong, nonatomic) AlertEstateTableView *alertTableView;

@property (strong, nonatomic) NSMutableArray *estateArray;
@property (strong, nonatomic) NSMutableArray *blockArray;
@property (strong, nonatomic) NSMutableArray *unitArray;
@property (strong, nonatomic) NSMutableArray *layerArray;

@property (assign, nonatomic) NSInteger estateIndex;
@property (assign, nonatomic) NSInteger blockIndex;
@property (assign, nonatomic) NSInteger unitIndex;
@property (assign, nonatomic) NSInteger layerIndex;

@end

@implementation ProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.estateIndex = -1;
    self.blockIndex = -1;
    self.unitIndex = -1;
    self.layerIndex = -1;
}


- (IBAction)projectSelect:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [My_ServicesManager getEstates:^(NSString *errorMsg, NSArray *list) {
        if (errorMsg) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.2];
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else{
            [self.estateArray removeAllObjects];
            for (int i = 0; i<list.count; i++) {
                EstateVO *estate = list[i];
                if ([self.btn_project.titleLabel.text isEqualToString:estate.estate_name]) {
                    self.estateIndex = i;
                }
                [self.estateArray addObject:estate];
            }
            [SVProgressHUD dismiss];
            self.alertTableView = [[AlertEstateTableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-40, (44.0*self.estateArray.count + 40.0/667*My_ScreenH)<(My_ScreenH-84)?(44.0*self.estateArray.count + 40.0/667*My_ScreenH):(My_ScreenH-84)) style:UITableViewStylePlain];
            self.alertTableView.type = AlertEstateType;
            self.alertTableView.data = self.estateArray;
            self.alertTableView.selectedIndex = self.estateIndex;
            self.alertTableView.AlertDelegate = self;
            [self.alertTableView showInWindow];
        }
    }];
}

- (IBAction)blockSelect:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    if (self.estateIndex == -1 || ![self.estateArray[self.estateIndex] estate_id] || [[self.estateArray[self.estateIndex] estate_id] isEqualToString:@""]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.2];
        [SVProgressHUD showErrorWithStatus:@"请选择项目"];
        return;
    }
    
    self.selectEstate_id = [self.estateArray[self.estateIndex] estate_id];
    
    [My_ServicesManager getBlock:[self.estateArray[self.estateIndex] estate_id] onComplete:^(NSString *errorMsg, NSArray *list) {
        [self.blockArray removeAllObjects];
        for (int i=0; i<list.count; i++) {
            NSString *block = list[i];
            if ([block isEqualToString:self.btn_block.titleLabel.text]) {
                self.blockIndex = i;
            }
            [self.blockArray addObject:block];
        }
        [SVProgressHUD dismiss];
        self.alertTableView = [[AlertEstateTableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-40, (44.0*self.blockArray.count + 40.0/667*My_ScreenH)<(My_ScreenH-84)?(44.0*self.blockArray.count + 40.0/667*My_ScreenH):(My_ScreenH-84)) style:UITableViewStylePlain];
        self.alertTableView.type = AlertBlockType;
        self.alertTableView.data = self.blockArray;
        self.alertTableView.selectedIndex = self.blockIndex;
        self.alertTableView.AlertDelegate = self;
        [self.alertTableView showInWindow];
    }];
}

- (IBAction)unitSelect:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    if (self.blockIndex == -1 || !self.blockArray[self.blockIndex] || [self.blockArray[self.blockIndex] isEqualToString:@""]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.2];
        [SVProgressHUD showErrorWithStatus:@"请选择项目"];
        return;
    }
    [My_ServicesManager getUnit:[self.estateArray[self.estateIndex] estate_id] block:self.blockArray[self.blockIndex] onComplete:^(NSString *errorMsg, NSArray *list) {
        [self.unitArray removeAllObjects];
        for (int i=0; i<list.count; i++) {
            NSNumber *unit = list[i];
            if ([[unit stringValue] isEqualToString:self.btn_unit.titleLabel.text]) {
                self.unitIndex = i;
            }
            [self.unitArray addObject:unit];
        }
        [SVProgressHUD dismiss];
        self.alertTableView = [[AlertEstateTableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-40, (44.0*self.unitArray.count + 40.0/667*My_ScreenH)<(My_ScreenH-84)?(44.0*self.unitArray.count + 40.0/667*My_ScreenH):(My_ScreenH-84)) style:UITableViewStylePlain];
        self.alertTableView.type = AlertUnitType;
        self.alertTableView.data = self.unitArray;
        self.alertTableView.AlertDelegate = self;
        self.alertTableView.selectedIndex = self.unitIndex;
        [self.alertTableView showInWindow];
    }];
}

- (IBAction)layerSelect:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    if (self.unitIndex == -1 || !self.unitArray[self.unitIndex] || [[self.unitArray[self.unitIndex] stringValue] isEqualToString:@""]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.2];
        [SVProgressHUD showErrorWithStatus:@"请选择项目"];
        return;
    }
    [My_ServicesManager getLayer:[self.estateArray[self.estateIndex] estate_id] block:self.blockArray[self.blockIndex] unit:self.unitArray[self.unitIndex] onComplete:^(NSString *errorMsg, NSArray *list) {
        [self.layerArray removeAllObjects];
        for (int i=0; i<list.count; i++) {
            NSString *layer = list[i];
            if ([layer isEqualToString:self.btn_layer.titleLabel.text]) {
                self.layerIndex = i;
            }
            [self.layerArray addObject:layer];
        }
        [SVProgressHUD dismiss];
        self.alertTableView = [[AlertEstateTableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-40, (44.0*self.layerArray.count + 40.0/667*My_ScreenH)<(My_ScreenH-84)?(44.0*self.layerArray.count + 40.0/667*My_ScreenH):(My_ScreenH-84)) style:UITableViewStylePlain];
        self.alertTableView.type = AlertLayerType;
        self.alertTableView.data = self.layerArray;
        self.alertTableView.AlertDelegate = self;
        self.alertTableView.selectedIndex = self.layerIndex;
        [self.alertTableView showInWindow];
    }];
}

- (void)commit:(NSInteger)index{
    UIButton *btn = [self.contentView viewWithTag:self.alertTableView.type + 30];

    switch (self.alertTableView.type) {
        case 1:{
            self.estateIndex = index;
            [btn setTitle:[self.estateArray[index] estate_name] forState:UIControlStateNormal];
            break;
        }
        case 2:{
            self.blockIndex = index;
            [btn setTitle:self.blockArray[index] forState:UIControlStateNormal];
            break;
        }
        case 3:{
            self.unitIndex = index;
            [btn setTitle:[self.unitArray[index] stringValue] forState:UIControlStateNormal];
            break;
        }
        case 4:{
            self.layerIndex = index;
            [btn setTitle:self.layerArray[index] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

- (NSMutableArray *)estateArray{
    if (!_estateArray) {
        _estateArray = [NSMutableArray array];
    }
    return _estateArray;
}

- (NSMutableArray *)blockArray{
    if (!_blockArray) {
        _blockArray = [NSMutableArray array];
    }
    return _blockArray;
}

- (NSMutableArray *)unitArray{
    if (!_unitArray) {
        _unitArray = [NSMutableArray array];
    }
    return _unitArray;
}

- (NSMutableArray *)layerArray{
    if (!_layerArray) {
        _layerArray = [NSMutableArray array];
    }
    return _layerArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
