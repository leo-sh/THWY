//
//  RepaireDetailController.m
//  THWY_Client
//
//  Created by wei on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairDetailController.h"
#import "RecordsDetailCell.h"

#import "RecordVideoCell.h"

@interface RepairDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tableFootView;
//@property (strong, nonatomic) UIButton *footBtn;

@property (strong, nonatomic) RepairVO *repairVO;

@end

@implementation RepairDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.displayType == 1) {
        self.title = @"报修记录详情";
    }else if (self.displayType == 2){
        self.title = @"报修接单详情";
    }
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景2"]]];
    
    [self getRepairVO];
    [self initViews];
}

- (void)getRepairVO{
    
    if (self.displayType == 1){
        if (self.type == 1) {
            [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
            [My_ServicesManager getARepair:self.repairVOId onComplete:^(NSString *errorMsg, RepairVO *repair) {
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }else{
                    self.repairVO = repair;
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
                }
                
            }];
        }else{
            [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
            [My_ServicesManager getAPublicRepair:self.repairVOId onComplete:^(NSString *errorMsg, RepairVO *repair) {
                if (errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }else{
                    self.repairVO = repair;
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
                }
                
            }];
        }
    }else if (self.displayType == 2){
        [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
        [My_ServicesManager getATask:self.repairVOId isPublic:self.type==2?YES:NO onComplete:^(NSString *errorMsg, RepairVO *repair) {
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
            }else{
                self.repairVO = repair;
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }

        }];
    }
    
}

- (void)initViews{
    //tableViewHeaderView
    CGFloat topMargrin = 10.0/375*My_ScreenW;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(topMargrin, topMargrin, My_ScreenW-topMargrin*2.0, 2)];
    imageView.image = [UIImage imageNamed:@"records_彩条"];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(topMargrin, topMargrin+2, My_ScreenW-topMargrin*2.0, My_ScreenH-topMargrin*2.0-74) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = imageView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[RecordsDetailCell class] forCellReuseIdentifier:@"RecordsDetailCell"];
    [self.tableView registerClass:[RecordImageCell class] forCellReuseIdentifier:@"RecordImageCell"];
    [self.tableView registerClass:[RecordVideoCell class] forCellReuseIdentifier:@"RecordVideoCell"];
    
    //tableViewFooterView
    self.tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 60)];
    UIButton *footBtn = [[UIButton alloc] initWithFrame:CGRectMake(topMargrin*3, 7.5, self.tableFootView.width-topMargrin*6, 45)];
    footBtn.center = self.tableFootView.center;
    [footBtn setTitle:@"接 单" forState:UIControlStateNormal];
    footBtn.layer.cornerRadius = 4;
    footBtn.clipsToBounds = YES;
    [footBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footBtn setBackgroundColor:My_NAV_BG_Color];
    [footBtn addTarget:self action:@selector(foorterBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFootView addSubview:footBtn];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.repairVO == nil){
        return 0;
    }else{
        if (self.displayType == 2 && self.repairVO.st != nil && [self.repairVO.st intValue] == 0) {
            
            tableView.tableFooterView = self.tableFootView;
            
        }else{
            
            tableView.tableFooterView = nil;
            
        }
        return 6;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 4;
            break;
        }
        case 1:{
            return 3;
            break;
        }
        case 2:{
            if ([self.repairVO.st intValue]>=1) {
                return 2;
            }else{
                return 0;
            }
            break;
        }
        case 3:{
            if (self.type == 1) {
                if ([self.repairVO.st intValue] == 0) {
                    return 0;
                }else if([self.repairVO.st intValue] == 1 || [self.repairVO.st intValue] == 2){
                    return 1;
                }else if([self.repairVO.st intValue] == 3){
                    return 2;
                }else if([self.repairVO.st intValue] == 4){
                    return 3;
                }
            }else{
                if ([self.repairVO.st intValue] == 0) {
                    return 0;
                }else if([self.repairVO.st intValue] == 1 || [self.repairVO.st intValue] == 2){
                    return 1;
                }else if([self.repairVO.st intValue] == 3){
                    return 2;
                }
            }
            
            break;
        }
        case 4:{
            if (self.repairVO.pic && ![self.repairVO.pic isEqualToString:@""] && ![self.repairVO.pic isEqualToString:@"http://112.126.75.77:6699"] && ![self.repairVO.pic isEqualToString:@"http://112.126.75.77:7976"]) {
                return 1;
            }else{
                return 0;
            }

            break;
        }
        case 5:{
            if (self.repairVO.vdo && ![self.repairVO.vdo isEqualToString:@""]) {
                return 1;
            }else{
                return 0;
            }
            break;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        RecordImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordImageCell" forIndexPath:indexPath];
        cell.tableView = tableView;
        cell.vc = self;
        [cell loadDataWithModel:self.repairVO];
        return cell;
    }else if (indexPath.section == 5){
        RecordVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordVideoCell" forIndexPath:indexPath];
        [cell loadDataWithModel:self.repairVO];
        return cell;
    }else {
        RecordsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordsDetailCell" forIndexPath:indexPath];
        cell.type = self.type;
        [cell loadDataWithModel:self.repairVO indexpath:indexPath];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 4) {
        if (self.repairVO.pic && ![self.repairVO.pic isEqualToString:@""] && ![self.repairVO.pic isEqualToString:@"http://112.126.75.77:6699"] && ![self.repairVO.pic isEqualToString:@"http://112.126.75.77:7976"]) {

            if (self.imageHeight == 0) {
                
                UIImage *image = [UIImage imageNamed:@"bannerload"];
                return image.size.height + 20+ 8.0/375*My_ScreenW*3;
                
            }else{
                return self.imageHeight + 20 + 8.0/375*My_ScreenW*3;
            }
        }else{
            return 0;
        }
    }else if (indexPath.section == 5) {
        if (self.repairVO.vdo && ![self.repairVO.vdo isEqualToString:@""]) {
            return 150/667.0*My_ScreenH;
        }else{
            return 0;
        }

    }else if (indexPath.section == 1 && indexPath.row == 1){
        if (self.repairVO.classes_str && ![self.repairVO.classes_str isEqualToString:@""]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(CONTENT_FONT),NSFontAttributeName, nil];
            CGRect rect = [self.repairVO.classes_str boundingRectWithSize:CGSizeMake(self.tableView.width*3.0/4, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
            return rect.size.height+20;
        }else{
            return 44;
        }
    }else{
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![cell isKindOfClass:[RecordsDetailCell class]]) {
        NSLog(@"%@", cell);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (![cell isKindOfClass:[RecordsDetailCell class]]) {
        NSLog(@"end %@", cell);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 1)];
    head.image = [UIImage imageNamed:@"records_虚线"];
    switch (section) {
        case 2:{
            if ([self.repairVO.st intValue] == 0) {
                return nil;
            }else{
                return head;
            }
            break;
        }
        case 3:{
            if ([self.repairVO.st intValue] == 0) {
                return nil;
            }else{
                return head;
            }
            break;
        }
        case 4:{
            if (self.repairVO.pic && ![self.repairVO.pic isEqualToString:@""] && ![self.repairVO.pic isEqualToString:@"http://112.126.75.77:6699"] && ![self.repairVO.pic isEqualToString:@"http://112.126.75.77:7976"]) {
                return head;
            }else{
                return nil;
            }
            break;
        }
        case 5:{
            if (self.repairVO.vdo && ![self.repairVO.vdo isEqualToString:@""]) {
                return head;
            }else{
                return nil;
            }

            break;
        }
//        default:{
//            return head;
//            break;
//        }
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 2:{
            if ([self.repairVO.st intValue]== 0) {
                return 0;
            }else{
                return 1;
            }
            break;
        }
        case 3:{
            if ([self.repairVO.st intValue]== 0) {
                return 0;
            }else{
                return 1;
            }
            break;
        }
        case 4:{
            if (self.repairVO.pic && ![self.repairVO.pic isEqualToString:@""] && ![self.repairVO.pic isEqualToString:@"http://112.126.75.77:6699"] && ![self.repairVO.pic isEqualToString:@"http://112.126.75.77:7976"]) {
                return 1;
            }else{
                return 0;
            }
            break;
        }
        case 5:{
            if (self.repairVO.vdo && ![self.repairVO.vdo isEqualToString:@""]) {
                return 1;
            }else{
                return 0;
            }
            
            break;
        }
//        default:{
//            return 1;
//            break;
//        }
    }
    return 0;
}

- (void)foorterBtnOnclicked:(UIButton *)btn{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"接单" message:@"确定对该单进行接单操作吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"接单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [My_ServicesManager takeTask:self.repairVOId isPublic:self.type==2?YES:NO onComplete:^(NSString *errorMsg) {
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
            }else{
                [SVProgressHUD hudHideWithSuccess:@"接单成功, 请尽快完成维修任务"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
