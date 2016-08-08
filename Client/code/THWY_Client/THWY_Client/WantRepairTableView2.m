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
        self.repairVO.cls = @"";
        self.cells = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@""]];
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        //[self initTableHeaderView];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor grayColor];
        self.bounces = NO;
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
//            [cell addObserver:self forKeyPath:@"flag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"0"];
            self.cells[row] = cell;
            return cell;
            break;
        }
        case 1:{
            ProjectCell *cell = (ProjectCell *)[tableView dequeueReusableCellWithIdentifier:@"ProjectCell" forIndexPath:indexPath];
//            [cell addObserver:self forKeyPath:@"selectEstate_id" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"1"];
//            [cell addObserver:self forKeyPath:@"btn_unit.titleLabel.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"1"];
//            [cell addObserver:self forKeyPath:@"btn_block.titleLabel.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"1"];
//            [cell addObserver:self forKeyPath:@"btn_layer.titleLabel.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"1"];
            self.cells[row] = cell;
            return cell;
            break;
        }
        case 2:{
            
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_姓名"];
            cell.label.text = @"报修人姓名:";
            cell.textField.text = [[[UDManager getUD] getUser] real_name];
//            [cell addObserver:self forKeyPath:@"textField.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"2"];
            self.cells[row] = cell;
            return cell;
            
        }
        case 3:{
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_call"];
            cell.label.text = @"报修人电话:";
            cell.textField.text = [[[UDManager getUD] getUser] cellphone];
//            [cell addObserver:self forKeyPath:@"textField.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"3"];
            self.cells[row] = cell;
            return cell;
            
        }
        case 4:{
            RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_保修类别"];
            cell.label.text = @"报修类别:";
//            [cell addObserver:self forKeyPath:@"detailLabel.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"4"];
            self.cells[row] = cell;
            return cell;
        }
        case 5:{
            UploadCell *cell = (UploadCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_图片"];
            cell.label.text = @"上传图片:";
            cell.descLabel.text = @"上传图片不能超过2M, 图片格式为jpg, png";
            cell.delegate = self;
            self.cells[row] = cell;
            return cell;
        }
        case 6:{
            UploadCell *cell = (UploadCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_视频"];
            cell.label.text = @"上传视频:";
            cell.descLabel.text = @"上传视频不能超过8M, 视频格式为avi, pge, swf";
            cell.delegate = self;
            self.cells[row] = cell;
            return cell;
        }
        case 7:{
            DescribeCell *cell = (DescribeCell *)[tableView dequeueReusableCellWithIdentifier:@"DescribeCell" forIndexPath:indexPath];
            cell.delegate = self;
//            [cell addObserver:self forKeyPath:@"textView.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"7"];
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
        return 300.0/713*My_ScreenH;
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
            [self.alertView showInWindow];
            
            break;
        }
        default:
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
//            case 4:{
//                if (![[[(RepaireCategorysCell *)cell detailLabel] text] isEqualToString:@""] && [[(RepaireCategorysCell *)cell detailLabel] text] != nil) {
//                    self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, [[(RepaireCategorysCell *)cell detailLabel] text]];
//                }
//                break;
//            }
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
    }else if ([self.repairVO.estate_id isEqualToString:@""] || [self.repairVO.block isEqualToString:@""] || [self.repairVO.unit isEqualToString:@""] || [self.repairVO.layer isEqualToString:@""]){
        errorMsg = @"请选择房源";
    }else if ([self.repairVO.cls isEqualToString:@""]){
        errorMsg = @"请选择报修类型";
    }else if ([self.repairVO.image isEqual:nil]){
        errorMsg = @"请选择图片";
    }else if ([self.repairVO.videoPath isEqualToString:@""]){
        errorMsg = @"请选择视频";
    }
    
    if (![errorMsg isEqualToString:@""]){
        [SVProgressHUD setMinimumDismissTimeInterval:1.4];
        [SVProgressHUD showErrorWithStatus:errorMsg];
        return;
    }

    [SVProgressHUD showWithStatus:@"数据上传中..."];
    
    [My_ServicesManager addPublicRepair:self.repairVO onComplete:^(NSString *errorMsg) {
        
        [self.repairDelegate commitComplete:errorMsg];
        
    }];
    
    
}


@end
