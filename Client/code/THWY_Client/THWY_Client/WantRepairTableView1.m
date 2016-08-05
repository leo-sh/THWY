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

@interface WantRepairTableView1 ()<UITableViewDelegate, UITableViewDataSource, AlertTableViewDelegate, DescribeCellDelegate, UploadCellDelegate>

@property (strong, nonatomic) AlertTableView *alertView;

@property (strong, nonatomic) AddRepairVO *repairVO;

@end

@implementation WantRepairTableView1

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        //[self initTableHeaderView];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor grayColor];
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.sectionFooterHeight = 0;
        
        [self registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
        [self registerNib:[UINib nibWithNibName:@"HouseSourceCell" bundle:nil] forCellReuseIdentifier:@"HouseSourceCell"];
        [self registerNib:[UINib nibWithNibName:@"RepaireCategorysCell" bundle:nil] forCellReuseIdentifier:@"RepaireCategorysCell"];
        [self registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellReuseIdentifier:@"UploadCell"];
        [self registerNib:[UINib nibWithNibName:@"DescribeCell" bundle:nil] forCellReuseIdentifier:@"DescribeCell"];

        
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
  
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_姓名"];
            cell.label.text = @"业主名称:";
            cell.textField.text = [[[UDManager getUD] getUser] real_name];
            return cell;
            
            break;
        }
        case 1:{

            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_call"];
            cell.label.text = @"联系电话:";
            cell.textField.text = [[[UDManager getUD] getUser] cellphone];
            return cell;
        
            break;
        }
        case 2:{

            HouseSourceCell *cell = (HouseSourceCell *)[tableView dequeueReusableCellWithIdentifier:@"HouseSourceCell" forIndexPath:indexPath];
            return cell;
            
        }
        case 3:{
            RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_有偿保修"];
            cell.label.text = @"有偿报修类别:";
            return cell;
            
        }
        case 4:{
            RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_保修类别"];
            cell.label.text = @"无偿报修类别:";
            return cell;
        }
        case 5:{
            UploadCell *cell = (UploadCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_图片"];
            cell.label.text = @"上传图片:";
            cell.descLabel.text = @"上传图片不能超过2M, 图片格式为jpg, png";
            cell.delegate = self;
            return cell;
        }
        case 6:{
            UploadCell *cell = (UploadCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_视频"];
            cell.label.text = @"上传视频:";
            cell.descLabel.text = @"上传视频不能超过8M, 视频格式为avi, pge, swf";
            cell.delegate = self;
            return cell;
        }
        case 7:{
            DescribeCell *cell = (DescribeCell *)[tableView dequeueReusableCellWithIdentifier:@"DescribeCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
        default:
            break;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5 || indexPath.row == 6) {
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

    NSMutableString *cls = [NSMutableString string];
    if (flag == 1){
    //有偿
        for (NSIndexPath *indexpath in reslult) {
            [cls appendString:[[self.repaireClassArrayPay[indexpath.section] child][indexpath.row] class_name]];
        }
        UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        RepaireCategorysCell *newcell = (RepaireCategorysCell *)cell;
        newcell.detailLabel.text = cls;
        
    }else if (flag == 2){
    //无偿
        for (NSIndexPath *indexpath in reslult) {
            [cls appendString:[[self.repaireClassArrayFree[indexpath.section] child][indexpath.row] class_name]];
        }
        UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        RepaireCategorysCell *newcell = (RepaireCategorysCell *)cell;
        newcell.detailLabel.text = cls;
    }
    
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

    for (int i = 0; i < 8; i++) {
        
        UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        switch (i) {
            case 0:{
                TextFieldCell *newcell = (TextFieldCell *)cell;
                self.repairVO.call_person = newcell.textField.text;
                break;
            }
            case 1:{
                TextFieldCell *newcell = (TextFieldCell *)cell;
                self.repairVO.call_phone = newcell.textField.text;
                
                break;
            }
            case 2:{
                HouseSourceCell *newcell = (HouseSourceCell *)cell;
                self.repairVO.house_id = newcell.model.Id;
                break;
            }
            case 3:{
                RepaireCategorysCell *newcell = (RepaireCategorysCell *)cell;
                if (![newcell.detailLabel.text isEqualToString:@""] && newcell.detailLabel != nil) {
                    self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, newcell.detailLabel.text];
                }
                break;
            }
            case 4:{
                RepaireCategorysCell *newcell = (RepaireCategorysCell *)cell;
                if (![newcell.detailLabel.text isEqualToString:@""] && newcell.detailLabel != nil) {
                    self.repairVO.cls = [NSString stringWithFormat:@"%@%@", self.repairVO.cls, newcell.detailLabel.text];
                }
                
                break;
            }

            case 7:{
                DescribeCell *newcell = (DescribeCell *)cell;
                self.repairVO.detail = newcell.textView.text;
                break;
            }
            default:
                break;
        }
        
    }
    
    [My_ServicesManager addRepair:self.repairVO onComplete:^(NSString *errorMsg) {
        
        [self.repairDelegate commitComplete:errorMsg];
        
    }];

    
}

@end
