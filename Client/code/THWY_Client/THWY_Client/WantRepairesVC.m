//
//  WantRepairesVC.m
//  THWY_Client
//
//  Created by wei on 16/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WantRepairesVC.h"
#import "Masonry.h"
#import "UDManager.h"
#import "TextFieldCell.h"
#import "HouseSourceCell.h"
#import "RepaireCategorysCell.h"
#import "UploadCell.h"
#import "DescribeCell.h"
#import "PaigongCatogerysCell.h"
#import "ProjectCell.h"
#import "RepairClassVO.h"

@interface WantRepairesVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (assign, nonatomic) NSInteger switchFlag;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *tableView2;

@property (strong, nonatomic) NSArray *iconCellNames;
@property (strong, nonatomic) NSArray *identityStrings;

@property (strong, nonatomic) NSMutableArray *repaireClassArray;

@end

@implementation WantRepairesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNVBar];
    [self initViews];
    self.repaireClassArray = [[NSMutableArray alloc] init];
}

- (void)initNVBar{
    
    self.title = @"我要报修";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"repaire_背景2"]]];
}

- (void)initViews{
    
    self.switchFlag = 1;
    self.switchButton = [[UIButton alloc] init];
    [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签左"] forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(switchLeftRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.75);
        make.height.mas_equalTo(self.switchButton.mas_width).multipliedBy(70/491.0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view).offset(10);
    }];
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.text = @"业主报修";
    self.leftLabel.font = [UIFont fontWithName:My_RegularFontName size:18.0];
    self.leftLabel.textColor = [UIColor whiteColor];
    [self.leftLabel sizeToFit];
    [self.switchButton addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.switchButton.mas_centerX).multipliedBy(0.5);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
    }];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.text = @"公共报修";
    self.rightLabel.textColor = My_NAV_BG_Color;
    self.rightLabel.font = [UIFont fontWithName:My_RegularFontName size:18.0];
    [self.rightLabel sizeToFit];
    [self.switchButton addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.switchButton.mas_centerX).multipliedBy(1.5);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, My_ScreenW-20, My_ScreenH-94-40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(My_ScreenW-20, 0, My_ScreenW-20, My_ScreenH-94-40)];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView2.separatorColor = [UIColor grayColor];
    self.tableView2.bounces = NO;
    self.tableView2.showsVerticalScrollIndicator = NO;
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake((My_ScreenW-20)*2.0, My_ScreenH-94);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.tableView2];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchButton.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HouseSourceCell" bundle:nil] forCellReuseIdentifier:@"HouseSourceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RepaireCategorysCell" bundle:nil] forCellReuseIdentifier:@"RepaireCategorysCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellReuseIdentifier:@"UploadCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DescribeCell" bundle:nil] forCellReuseIdentifier:@"DescribeCell"];
    
    [self.tableView2 registerNib:[UINib nibWithNibName:@"PaigongCatogerysCell" bundle:nil] forCellReuseIdentifier:@"PaigongCatogerysCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"ProjectCell" bundle:nil] forCellReuseIdentifier:@"ProjectCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"HouseSourceCell" bundle:nil] forCellReuseIdentifier:@"HouseSourceCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellReuseIdentifier:@"UploadCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"DescribeCell" bundle:nil] forCellReuseIdentifier:@"DescribeCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"RepaireCategorysCell" bundle:nil] forCellReuseIdentifier:@"RepaireCategorysCell"];
    
}

- (void)switchLeftRight{

    if (self.switchFlag == 1) {
        self.leftLabel.textColor = My_NAV_BG_Color;
        self.rightLabel.textColor = [UIColor whiteColor];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签右"] forState:UIControlStateNormal];
        self.scrollView.contentOffset = CGPointMake(self.tableView.frame.size.width, 0);
        self.tableView2.contentOffset = CGPointMake(0, 0);
        self.switchFlag = 2;
    }else if (self.switchFlag == 2){
        self.leftLabel.textColor = [UIColor whiteColor];
        self.rightLabel.textColor = My_NAV_BG_Color;
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"repaire_切换标签左"] forState:UIControlStateNormal];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.tableView.contentOffset = CGPointMake(0, 0);
        self.switchFlag = 1;
    }

}

#pragma mark - tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:{
            if ([tableView isEqual:self.tableView2]) {
                PaigongCatogerysCell *cell = (PaigongCatogerysCell *)[tableView dequeueReusableCellWithIdentifier:@"PaigongCatogerysCell" forIndexPath:indexPath];
                return cell;
            } else {
                TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
                cell.icon.image = [UIImage imageNamed:@"repaire_姓名"];
                cell.label.text = @"业主名称:";
                cell.textField.text = [[[UDManager getUD] getUser] real_name];
                return cell;
            }
            break;
        }
        case 1:{
            if ([tableView isEqual:self.tableView2]) {
                ProjectCell *cell = (ProjectCell *)[tableView dequeueReusableCellWithIdentifier:@"ProjectCell" forIndexPath:indexPath];
                return cell;
            } else {
                TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
                cell.icon.image = [UIImage imageNamed:@"repaire_call"];
                cell.label.text = @"联系电话:";
                cell.textField.text = [[[UDManager getUD] getUser] cellphone];
                return cell;
            }
            break;
        }
        case 2:{
            if ([tableView isEqual:self.tableView2]) {
                TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
                cell.icon.image = [UIImage imageNamed:@"repaire_姓名"];
                cell.label.text = @"报修人姓名:";
                cell.textField.text = [[[UDManager getUD] getUser] real_name];
                return cell;
            } else {
                HouseSourceCell *cell = (HouseSourceCell *)[tableView dequeueReusableCellWithIdentifier:@"HouseSourceCell" forIndexPath:indexPath];
                return cell;
            }
        }
        case 3:{
            if ([tableView isEqual:self.tableView2]) {
                TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
                cell.icon.image = [UIImage imageNamed:@"repaire_call"];
                cell.label.text = @"报修人电话:";
                cell.textField.text = [[[UDManager getUD] getUser] cellphone];
                return cell;
            } else {
                
                RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
                cell.icon.image = [UIImage imageNamed:@"repaire_有偿保修"];
                cell.label.text = @"有偿报修类别:";
                return cell;
            }
        }
        case 4:{
            RepaireCategorysCell *cell = (RepaireCategorysCell *)[tableView dequeueReusableCellWithIdentifier:@"RepaireCategorysCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_保修类别"];
            if ([tableView isEqual:self.tableView2]) {
                cell.label.text = @"报修类别:";
            } else {
                cell.label.text = @"无偿报修类别:";
            }
            return cell;
        }
        case 5:{
            UploadCell *cell = (UploadCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_图片"];
            cell.label.text = @"上传图片:";
            cell.descLabel.text = @"上传图片不能超过2M, 图片格式为jpg, png";
            return cell;
        }
        case 6:{
            UploadCell *cell = (UploadCell *)[tableView dequeueReusableCellWithIdentifier:@"UploadCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:@"repaire_视频"];
            cell.label.text = @"上传视频:";
            cell.descLabel.text = @"上传视频不能超过8M, 视频格式为avi, pge, swf";
            return cell;
        }
        case 7:{
            DescribeCell *cell = (DescribeCell *)[tableView dequeueReusableCellWithIdentifier:@"DescribeCell" forIndexPath:indexPath];
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
    
    [My_ServicesManager getRepairClasses:self.switchFlag onComplete:^(NSString *errorMsg, NSArray *list) {
        for (RepairClassVO * model in list) {
            [self.repaireClassArray addObject:model];
        }
    }];
    switch (indexPath.row) {
        case 3:{
            
            break;
        }
        case 4:{
            
            break;
        }
        default:
            break;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
