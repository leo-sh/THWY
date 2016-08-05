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

@end

@implementation WantRepairTableView2

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
            return cell;
            
            break;
        }
        case 1:{

            ProjectCell *cell = (ProjectCell *)[tableView dequeueReusableCellWithIdentifier:@"ProjectCell" forIndexPath:indexPath];
            return cell;
            break;
        }
        case 2:{
            
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_姓名"];
            cell.label.text = @"报修人姓名:";
            cell.textField.text = [[[UDManager getUD] getUser] real_name];

            return cell;
            
        }
        case 3:{
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_call"];
            cell.label.text = @"报修人电话:";
            cell.textField.text = [[[UDManager getUD] getUser] cellphone];

            return cell;
            
        }
        case 4:{
            RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_保修类别"];
            cell.label.text = @"报修类别:";
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
    
    if (indexPath.row == 1){
        return 130.0/713*My_ScreenH;
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

    
    for (NSIndexPath *indexpath in reslult) {
        [cls appendString:[[self.repaireClassArrayPublic[indexpath.section] child][indexpath.row] class_name]];
    }
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    RepaireCategorysCell *newcell = (RepaireCategorysCell *)cell;
    newcell.detailLabel.text = cls;
    
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
                PaigongCatogerysCell *newcell = (PaigongCatogerysCell *)cell;
                self.repairVO.kb = newcell.flag;
                break;
            }
            case 1:{
                ProjectCell *newcell = (ProjectCell *)cell;
                self.repairVO.estate_id = @"";
                self.repairVO.unit = newcell.btn_unit.titleLabel.text;
                self.repairVO.block = newcell.btn_block.titleLabel.text;
                self.repairVO.layer = newcell.btn_layer.titleLabel.text;
                break;
            }
            case 2:{
                TextFieldCell *newcell = (TextFieldCell *)cell;
                self.repairVO.call_name = newcell.textField.text;
                break;
            }
            case 3:{
                TextFieldCell *newcell = (TextFieldCell *)cell;
                self.repairVO.call_phone = newcell.textField.text;
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
                self.repairVO.repair_detail = newcell.textView.text;
                break;
            }
            default:
                break;
        }
        
    }
    
    [My_ServicesManager addPublicRepair:self.repairVO onComplete:^(NSString *errorMsg) {
        
        [self.repairDelegate commitComplete:errorMsg];
        
    }];
    
    
}

@end
