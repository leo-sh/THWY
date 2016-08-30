//
//  CommunicateViewController.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "CommunicateViewController.h"
#import "ServicesManager.h"
#import "SVProgressHUD.h"
#import "CMTableViewCell.h"
#import "COTableViewCell.h"
@interface CommunicateViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property UITableView *tableView;
@property NSMutableArray *data;
@property NSMutableDictionary *rowAndHeight;
@property UITextField *msgTextField;
@end

@implementation CommunicateViewController
+ (instancetype)shareCommunicateViewController
{
    static CommunicateViewController *vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[CommunicateViewController alloc]init];
    });
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.msgTextField becomeFirstResponder];
}

- (void)ViewInitSetting
{
    self.title = @"发送短消息";
    
    UIImage *image = [UIImage imageNamed:@"CF背景"];
    
    self.view.layer.contents = (id)image.CGImage;
    
    self.data = [NSMutableArray array];
    self.rowAndHeight = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNew:) name:GetNewMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"giveHeight" object:nil];
    
}

- (void)getData
{
    [[ServicesManager getAPI] getMsgs:self.s_admin_id endId:[[UDManager getUD]getEndId:self.s_admin_id] onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
        {
            self.data.array = list;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.data.count - 1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

                
            });
            
        }
        
    }];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CMTableViewCell class] forCellReuseIdentifier:@"CM"];
    [self.tableView registerClass:[COTableViewCell class] forCellReuseIdentifier:@"CO"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-100);
    }];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 124, self.view.width, 60)];
    
    bottomView.backgroundColor = WhiteAlphaColor;
    
    self.msgTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 10, self.view.width * 0.8 , 40)];
    
    
    self.msgTextField.backgroundColor = [UIColor whiteColor];
    
    self.msgTextField.layer.borderColor = CellUnderLineColor.CGColor;
    self.msgTextField.layer.borderWidth = 0.5;
    self.msgTextField.delegate = self;
    [bottomView addSubview:self.msgTextField];
    
    UIButton *send = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width * 0.8 + 10, 10, self.view.width * 0.15, 40)];
    
    [send setTitle:@"发送" forState:UIControlStateNormal];
    send.backgroundColor = My_NAV_BG_Color;
    
    [bottomView addSubview:send];
    
    [send addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *returnCell;
    
    if ([[self.data[indexPath.section] sender_admin_id] isEqualToString: self.s_admin_id]) {
    
        COTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CO"];
        cell.section = indexPath.section;
        [cell setIcon:@"" Content:[self.data[indexPath.section] msg]];
        NSLog(@"indexpath.section%d",indexPath.section);
        cell.width = tableView.width;
        returnCell = cell;
    
    }
    else
    {
        CMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CM"];
        cell.section = indexPath.section;
        [cell setIcon:@"" Content:[self.data[indexPath.section] msg]];
        cell.width = tableView.width;
        returnCell = cell;
    }
    
    returnCell.backgroundColor = [UIColor clearColor];
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",indexPath.section];
    CGFloat value = [self.rowAndHeight[key] floatValue];
    
    if (value == 0) {
        return 44;
    }
        
    return value;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 12.5, self.view.width * 0.4, 25)];
    
    btn.titleLabel.font = FontSize(Content_Ip_Font);
    
    NSString *title = [NSString stringDateFromTimeInterval:[[self.data[section] ctime] intValue] withFormat:@"YYYY-MM-dd HH:SS"];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"时间背景"] forState:UIControlStateNormal];
    
    btn.userInteractionEnabled = NO;

    btn.centerX = self.view.centerX;
    
    [view addSubview:btn];
    
    return view;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.msgTextField endEditing:YES];
}

#pragma mark --收到消息
- (void)receiveNew:(NSNotification *)new
{
    NSDictionary *dic = new.object;
    if ([[NSString stringWithFormat:@"%d",[dic[@"s_admin_id"] intValue]] isEqualToString:self.s_admin_id]) {
        
        [My_ServicesManager palyReceive];
    }
    else
    {
        self.s_admin_id = dic[@"s_admin_id"];
    }
    [self getData];
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.data.count - 1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}
#pragma  mark --点击发送按钮
- (void)clickSendBtn:(UIButton *)sender
{
    sender.enabled = NO;
    [self.msgTextField endEditing:YES];
    if (self.msgTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
        sender.enabled = YES;
    }else
    {
        [My_ServicesManager sendMsg:self.s_admin_id msg:self.msgTextField.text onComplete:^(NSString *errorMsg) {
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
            }else
            {
                self.msgTextField.text = @"";
                [self getData];
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.data.count - 1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

            }
            sender.enabled = YES;
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self.msgTextField isExclusiveTouch]) {
        [self.msgTextField endEditing:YES];
    }
}

- (void)change:(NSNotification *)notification
{
    if (self.rowAndHeight == nil) {
        self.rowAndHeight = [NSMutableDictionary dictionary];
    }
    
    [self.rowAndHeight setValuesForKeysWithDictionary:notification.object];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
