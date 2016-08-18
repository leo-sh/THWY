//
//  WantRepairTableView2.m
//  THWY_Client
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WantRepairTableView2.h"

#import "TextFieldCell.h"
#import "HouseSourceCell.h"
#import "RepaireCategorysCell.h"
#import "UploadCell.h"
#import "DescribeCell.h"
#import "PaigongCatogerysCell.h"
#import "ProjectCell.h"

#import "AlertTableView.h"

@interface WantRepairTableView2 ()<UITableViewDelegate, UITableViewDataSource, AlertTableViewDelegate, DescribeCellDelegate, UploadCellDelegate>

@property (strong, nonatomic) AlertTableView *alertView;

@property (strong, nonatomic) AddPublicRepairVO *repairVO;

@property (strong, nonatomic) NSMutableArray *cells;

@end

@implementation WantRepairTableView2

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.repairVO = [[AddPublicRepairVO alloc] init];
        self.repairVO.videoPath = @"";
        self.repairVO.cls = @"";
        self.repairVO.image = [[UIImage alloc] init];
        self.repairVO.estate_id = @"-1";
        self.cells = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@""]];
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        //[self initTableHeaderView];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor lightGrayColor];
//        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.sectionFooterHeight = 0;
        
        [self registerNib:[UINib nibWithNibName:@"PaigongCatogerysCell" bundle:nil] forCellReuseIdentifier:@"PaigongCatogerysCell"];
        [self registerNib:[UINib nibWithNibName:@"ProjectCell" bundle:nil] forCellReuseIdentifier:@"ProjectCell"];
        [self registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
        [self registerNib:[UINib nibWithNibName:@"HouseSourceCell" bundle:nil] forCellReuseIdentifier:@"HouseSourceCell"];
        [self registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellReuseIdentifier:@"UploadCell"];
        [self registerNib:[UINib nibWithNibName:@"DescribeCell" bundle:nil] forCellReuseIdentifier:@"DescribeCell"];
        [self registerNib:[UINib nibWithNibName:@"RepaireCategorysCell" bundle:nil] forCellReuseIdentifier:@"RepaireCategorysCell"];
        
    }
    return self;
    
}

#pragma mark - tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:{
            
            PaigongCatogerysCell *cell = (PaigongCatogerysCell *)[tableView dequeueReusableCellWithIdentifier:@"PaigongCatogerysCell" forIndexPath:indexPath];
            self.cells[row] = cell;
            return cell;
            break;
        }
        case 1:{
            ProjectCell *cell = (ProjectCell *)[tableView dequeueReusableCellWithIdentifier:@"ProjectCell" forIndexPath:indexPath];
            self.cells[row] = cell;
            return cell;
            break;
        }
        case 2:{
            
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_姓名"];
            cell.label.text = @"报修人姓名:";
            cell.textField.text = [[[UDManager getUD] getUser] real_name];
            self.cells[row] = cell;
            return cell;
            
        }
        case 3:{
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_call"];
            cell.label.text = @"报修人电话:";
            cell.textField.text = [[[UDManager getUD] getUser] cellphone];
            self.cells[row] = cell;
            return cell;
            
        }
        case 4:{
            RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_保修类别"];
            cell.label.text = @"报修类别: ";
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
            self.cells[row] = cell;
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1){
        return 140.0;
    }else if (indexPath.row == 5 || indexPath.row == 6) {
        return 90.0/713*My_ScreenH;
    }else if (indexPath.row == 7){
        return 310.0/713*My_ScreenH;
    }
    return 60.0/713*My_ScreenH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {

        case 4:{
            //弹框
            [self initAlertView];
            self.alertView.data = self.repaireClassArrayPublic;
            self.alertView.flag = 3;
            [self.alertView initViews];
            [self.alertView showInWindow];
            
            break;
        }
        default:
            [[(UIViewController *)self.repairDelegate view] endEditing:YES];
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//弹出框
- (void)initAlertView{
    
    self.alertView = [[AlertTableView alloc] initWithFrame:CGRectMake(20/375.0*My_ScreenW, 20/375.0*My_ScreenW, 337/375.0*My_ScreenW, My_ScreenH-20/375.0*My_ScreenW*2) ];
    self.alertView.AlertDelegate = self;
    
}

//弹出框代理函数
- (void)confirm:(NSMutableArray *)reslult flag:(NSInteger)flag{
    
    NSMutableString *clsName = [NSMutableString string];
    NSMutableString *clsPath = [NSMutableString stringWithString:@""];
    
    for (NSIndexPath *indexpath in reslult) {
        if (![clsName isEqualToString:@""]) {
            [clsName appendString:@","];
            [clsPath appendString:@","];
        }
        [clsName appendString:[self.repaireClassArrayPublic[indexpath.row] class_name]];
        [clsPath appendString:[self.repaireClassArrayPublic[indexpath.row] Id]];
    }
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    RepaireCategorysCell *newcell = (RepaireCategorysCell *)cell;
    newcell.detailLabel.text = clsName;
//    if ([self.repairVO.cls isEqualToString:@""]) {
//        self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, clsPath];
//    }else {
//        self.repairVO.cls = [NSString stringWithFormat:@"%@,%@", self.repairVO.cls, clsPath];
//    }
    self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, clsPath];
    
}

//选择图片和视频
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
                self.repairVO.kb = [(PaigongCatogerysCell *)cell flag];
                break;
            }
            case 1:{
                self.repairVO.estate_id = [(ProjectCell *)cell selectEstate_id];
                self.repairVO.block = [(ProjectCell *)cell btn_block].titleLabel.text;
                self.repairVO.unit = [(ProjectCell *)cell btn_unit].titleLabel.text;
                self.repairVO.layer = [(ProjectCell *)cell btn_layer].titleLabel.text;
                break;
            }
            case 2:{
                self.repairVO.call_name = [(TextFieldCell *)cell textField].text;
                break;
            }
            case 3:{
                self.repairVO.call_phone = [(TextFieldCell *)cell textField].text;
                break;
            }

            case 7:{
                self.repairVO.repair_detail = [(DescribeCell *)cell textView].text;
                break;
            }
            default:
                break;
        }

    }

    
    NSString *errorMsg = @"";
    
    if ([self.repairVO.call_name isEqualToString:@""]) {
        errorMsg = @"请输入业主名字";
    }else if ([self.repairVO.call_phone isEqualToString:@""]){
        errorMsg = @"请输入业主联系方式";
    }else if ([self.repairVO.cls isEqualToString:@""]){
        errorMsg = @"请选择报修类型";
    }
//    else if ([self.repairVO.image isEqual:nil]){
//        errorMsg = @"请选择图片";
//    }else if ([self.repairVO.videoPath isEqualToString:@""]){
//        errorMsg = @"请选择视频";
//    }
    else if ([self.repairVO.repair_detail isEqualToString:@""]){
        errorMsg = @"描述不能为空";
    }else if(!self.repairVO.estate_id || [self.repairVO.estate_id isEqualToString:@""]){
        errorMsg = @"请选择房源";
    }else if (self.repairVO.estate_id && ![self.repairVO.estate_id isEqualToString:@""]){
    
        NSMutableArray *houseID = [NSMutableArray array];
        for (HouseVO *house in [[[UDManager getUD] getUser] houses]) {
            [houseID addObject:house.estate_id];
        }
        if ([houseID containsObject:self.repairVO.estate_id]){
            errorMsg = @"";
        }else{
            errorMsg = @"你好业主,不能为其他楼盘提交公共报修,请重新选择";
        }
    }
    
//    if ([self.repairVO.estate_id isEqualToString:@""] || [self.repairVO.block isEqualToString:@""] || [self.repairVO.unit isEqualToString:@""] || [self.repairVO.layer isEqualToString:@"" ] || !self.repairVO.estate_id || !self.repairVO.block || !self.repairVO.unit || !self.layer ){
//        errorMsg = @"请选择房源";
//    }
    
    if (![errorMsg isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:errorMsg];
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"我要报修" message:@"确定提交报修操作吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![self.repairVO.videoPath isEqualToString:@""]){
            
            switch (My_ServicesManager.status) {
                case NotReachable:
                    [SVProgressHUD showErrorWithStatus:@"网络未连接"];
                    
                    break;
                case ReachableViaWWAN:{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前处于非WiFi状态" message:@"你确定上传视频吗?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [SVProgressHUD showWithStatus:@"数据上传中..."];
                        
                        [My_ServicesManager addPublicRepair:self.repairVO onComplete:^(NSString *errorMsg) {
                                [self.repairDelegate commitComplete:errorMsg];
                            
                        }];

                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        return ;
                    }];
                    
                    [alert addAction:confirm];
                    [alert addAction:cancel];
                    
                    [(UIViewController *)self.repairDelegate presentViewController:alert animated:YES completion:^{
                        
                    }];

                    break;
                }
                case ReachableViaWiFi:{
                    
                    [SVProgressHUD showWithStatus:@"数据上传中..."];
                    
                    [My_ServicesManager addPublicRepair:self.repairVO onComplete:^(NSString *errorMsg) {
                        
                        [self.repairDelegate commitComplete:errorMsg];
                        
                    }];
                    break;
                }
                default:
                    break;
            }
        }else{
            [SVProgressHUD showWithStatus:@"数据上传中..."];
            
            [My_ServicesManager addPublicRepair:self.repairVO onComplete:^(NSString *errorMsg) {
                [self.repairDelegate commitComplete:errorMsg];
            }];

        }

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    
    [alert addAction:confirm];
    [alert addAction:cancel];
    
    [(UIViewController *)self.repairDelegate presentViewController:alert animated:YES completion:^{
        
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.repairDelegate tableViewDidScroll];
    
}


@end
