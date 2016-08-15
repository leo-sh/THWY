//
//  WantRepairTableView1.m
//  THWY_Client
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WantRepairTableView1.h"

#import "TextFieldCell.h"
#import "HouseSourceCell.h"
#import "RepaireCategorysCell.h"
#import "UploadCell.h"
#import "DescribeCell.h"
#import "PaigongCatogerysCell.h"
#import "ProjectCell.h"

#import "AlertTableView.h"

@interface WantRepairTableView1 ()<UITableViewDelegate, UITableViewDataSource, AlertTableViewDelegate, DescribeCellDelegate, UploadCellDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) AlertTableView *alertView;

@property (strong, nonatomic) AddRepairVO *repairVO;

@property (strong, nonatomic) NSMutableArray *housesArray;

@property (strong, nonatomic) NSMutableArray *cells;

@end

@implementation WantRepairTableView1

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.repairVO = [[AddRepairVO alloc] init];
        self.repairVO.cls = @"";
        self.cells = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@""]];
        
        [self getHouses];
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        //[self initTableHeaderView];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor grayColor];
//        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.sectionFooterHeight = 0;
        
        [self registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
        [self registerClass:[HouseSourceCell class] forCellReuseIdentifier:@"HouseSourceCell"];
        [self registerNib:[UINib nibWithNibName:@"RepaireCategorysCell" bundle:nil] forCellReuseIdentifier:@"RepaireCategorysCell"];
        [self registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellReuseIdentifier:@"UploadCell"];
        [self registerNib:[UINib nibWithNibName:@"DescribeCell" bundle:nil] forCellReuseIdentifier:@"DescribeCell"];

        
    }
    return self;
    
}

- (void)getHouses{
    self.housesArray = [NSMutableArray arrayWithArray:[[[UDManager getUD] getUser] houses]];
}

#pragma mark - tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:{
  
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_姓名"];
            cell.label.text = @"业主名称:";
            cell.textField.text = [[[UDManager getUD] getUser] real_name];
            self.cells[row] = cell;
            return cell;
            
            break;
        }
        case 1:{

            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_call"];
            cell.label.text = @"联系电话:";
            cell.textField.text = [[[UDManager getUD] getUser] cellphone];
            self.cells[row] = cell;
            return cell;
        
            break;
        }
        case 2:{

            HouseSourceCell *cell = (HouseSourceCell *)[tableView dequeueReusableCellWithIdentifier:@"HouseSourceCell" forIndexPath:indexPath];
            cell.housesArray = self.housesArray;
            [cell updateFrame];
            self.cells[row] = cell;
            return cell;
            
        }
        case 3:{
            RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_有偿保修"];
            cell.label.text = @"有偿报修类别:";
            self.cells[row] = cell;
            return cell;
            
        }
        case 4:{
            RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_保修类别"];
            cell.label.text = @"无偿报修类别:";
            self.cells[row] = cell;
            return cell;
        }
        case 5:{
            UploadCell *cell = (UploadCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_图片"];
            cell.label.text = @"上传图片:";
            cell.descLabel.text = @"上传图片不能超过2M, 图片格式为jpg, png";
            cell.delegate = self;
            cell.selectType = ImageType;
            self.cells[row] = cell;
            return cell;
        }
        case 6:{
            UploadCell *cell = (UploadCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_视频"];
            cell.label.text = @"上传视频:";
            cell.descLabel.text = @"上传视频不能超过8M, 视频格式为avi, pge, swf";
            cell.delegate = self;
            cell.selectType = VideoType;
            self.cells[row] = cell;
            return cell;
        }
        case 7:{
            DescribeCell *cell = (DescribeCell *)[tableView dequeueReusableCellWithIdentifier:@"DescribeCell" forIndexPath:indexPath];
            cell.delegate = self;
//            cell.textView.delegate = self;
            self.cells[row] = cell;
            return cell;
        }
        default:
            break;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        return (60.0+self.housesArray.count*30)/713*My_ScreenH;
    }else if (indexPath.row == 5 || indexPath.row == 6) {
        return 90.0/713*My_ScreenH;
    }else if (indexPath.row == 7){
        return 300.0/713*My_ScreenH;
    }
    return 60.0/713*My_ScreenH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 3:{
            //有偿弹框
            [self initAlertView];
            self.alertView.data = self.repaireClassArrayPay;
            self.alertView.flag = 1;
            [self.alertView showInWindow];
            break;
        }
        case 4:{
            //无偿弹框
            [self initAlertView];
            self.alertView.data = self.repaireClassArrayFree;
            self.alertView.flag = 2;
            [self.alertView showInWindow];
            break;
        }
        default:
            [[(UIViewController *)self.repairDelegate view] endEditing:YES];
            break;
    }
    
}

//弹出框
- (void)initAlertView{
    
    self.alertView = [[AlertTableView alloc] initWithFrame:CGRectMake(30/375.0*My_ScreenW, 30/375.0*My_ScreenW, 317/375.0*My_ScreenW, My_ScreenH*2/3.0) style:UITableViewStyleGrouped];
    self.alertView.AlertDelegate = self;

}

//弹出框代理函数
- (void)confirm:(NSMutableArray *)reslult flag:(NSInteger)flag{

    NSMutableString *clsName = [NSMutableString stringWithFormat:@""];
    NSMutableString *clsPath = [NSMutableString stringWithString:@""];
    if (flag == 1){
    //有偿
        for (NSIndexPath *indexpath in reslult) {
            if (![clsPath isEqualToString:@""]) {
                [clsName appendString:@","];
                [clsPath appendString:@","];
            }
            [clsName appendString:[[self.repaireClassArrayPay[indexpath.section] child][indexpath.row] class_name]];
            [clsPath appendString:[[self.repaireClassArrayPay[indexpath.section] child][indexpath.row] Id]];
        }
        UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        RepaireCategorysCell *newcell = (RepaireCategorysCell *)cell;
        newcell.detailLabel.text = clsName;
        if ([self.repairVO.cls isEqualToString:@""]) {
            self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, clsPath];
        }else {
            self.repairVO.cls = [NSString stringWithFormat:@"%@,%@", self.repairVO.cls, clsPath];
        }
//        self.repairVO.cls = clsPath;
        
    }else if (flag == 2){
    //无偿
        for (NSIndexPath *indexpath in reslult) {
            if (![clsPath isEqualToString:@""]) {
                [clsName appendString:@","];
                [clsPath appendString:@","];
            }
            [clsName appendString:[[self.repaireClassArrayFree[indexpath.section] child][indexpath.row] class_name]];
            [clsPath appendString:[[self.repaireClassArrayPay[indexpath.section] child][indexpath.row] Id]];
        }
        UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        RepaireCategorysCell *newcell = (RepaireCategorysCell *)cell;
        newcell.detailLabel.text = clsName;
        if ([self.repairVO.cls isEqualToString:@""]) {
            self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, clsPath];
        }else {
            self.repairVO.cls = [NSString stringWithFormat:@"%@,%@", self.repairVO.cls, clsPath];
        }
//        self.repairVO.cls = clsPath;
    }
    
}

//选择图片和视频结果
- (void)select:(id)content type:(SelectType)type{
    if (type == ImageType) {
        self.repairVO.image = (UIImage *)content;
    }else if (type == VideoType){
        self.repairVO.videoPath = content;
    }
}


//提交报修对象
- (void)commit{
    
    [[(UIViewController *)self.repairDelegate view] endEditing:YES];
    
    for (int i = 0; i < self.cells.count; i++) {
        if ([self.cells [i] isKindOfClass:[NSString class]]) {
            continue;
        }

        UITableViewCell *cell = self.cells[i];
        switch (i) {
            case 0:{
                self.repairVO.call_person = [((TextFieldCell *)cell) textField].text;
                break;
            }
            case 1:{
                self.repairVO.call_phone = [((TextFieldCell *)cell) textField].text;
                break;
            }
            case 2:{
                if ([(HouseSourceCell *)cell selectedIndex] == -1) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1.2];
                    [SVProgressHUD showErrorWithStatus:@"请选择房源"];
                    return;
                }
                self.repairVO.house_id = [self.housesArray[[(HouseSourceCell *)cell selectedIndex]] Id];
                break;
            }
//            case 3:{
//                if (![[[(RepaireCategorysCell *)cell detailLabel] text] isEqualToString:@""] && [[(RepaireCategorysCell *)cell detailLabel] text] != nil) {
//                    self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, [[(RepaireCategorysCell *)cell detailLabel] text]];
//                }
//                break;
//            }
//            case 4:{
//                if (![[[(RepaireCategorysCell *)cell detailLabel] text] isEqualToString:@""] && [[(RepaireCategorysCell *)cell detailLabel] text] != nil) {
//                    self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, [[(RepaireCategorysCell *)cell detailLabel] text]];
//                }
//                break;
//            }
            case 7:{
                self.repairVO.detail = [[(DescribeCell *)cell textView] text];
                break;
            }
            default:
                break;
        }
        
    }

    
    NSString *errorMsg = @"";
    
    if ([self.repairVO.call_person isEqualToString:@""]) {
        errorMsg = @"请输入业主名字";
    }else if ([self.repairVO.call_phone isEqualToString:@""]){
        errorMsg = @"请输入业主联系方式";
    }else if ([self.repairVO.house_id isEqualToString:@""]){
        errorMsg = @"请选择房源";
    }else if ([self.repairVO.cls isEqualToString:@""]){
        errorMsg = @"请选择报修类型";
    }else if ([self.repairVO.image isEqual:nil]){
        errorMsg = @"请选择图片";
    }
    
    if (![errorMsg isEqualToString:@""]){
        [SVProgressHUD setMinimumDismissTimeInterval:1.4];
        [SVProgressHUD showErrorWithStatus:errorMsg];
        return;
    }
    
    if (![self.repairVO.videoPath isEqualToString:@""]){
    
        switch (My_ServicesManager.status) {
            case NotReachable:
               
                [SVProgressHUD setMinimumDismissTimeInterval:1.3];
                [SVProgressHUD showErrorWithStatus:@"网络未连接"];
                break;
            case ReachableViaWWAN:{
                NSLog(@"GPRS网络");
                TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"当前处于非WiFi状态" message:@"你确定上传视频吗?"];
                [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
                    
                }]];
                
                [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                    [SVProgressHUD showWithStatus:@"数据上传中..."];
                    
                    [My_ServicesManager addRepair:self.repairVO onComplete:^(NSString *errorMsg) {
                        
                        [self.repairDelegate commitComplete:errorMsg];
                        
                    }];
                    
                }]];
                
                [alertView showInWindowWithOriginY:200 backgoundTapDismissEnable:YES];
                
                break;
            }
            case ReachableViaWiFi:{
                [SVProgressHUD showWithStatus:@"数据上传中..."];
                
                [My_ServicesManager addRepair:self.repairVO onComplete:^(NSString *errorMsg) {
                    
                    [self.repairDelegate commitComplete:errorMsg];
                    
                }];
                NSLog(@"wifi网络");
                break;
            }

        }
    }

    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.repairDelegate tableViewDidScroll];
    
}

@end
