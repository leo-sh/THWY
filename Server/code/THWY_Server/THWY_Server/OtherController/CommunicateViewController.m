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
@property CGFloat contentHeight;
@property BOOL stop;
@property BOOL cancel;
@property NSString  *endId;
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
    self.contentHeight = 0.0;
    [self ViewInitSetting];
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    [self getData];
    [self createUI];
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self.msgTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    self.rowAndHeight = nil;
    self.cancel = YES;

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
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
    });
    
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    if (!self.Id) {
        self.Id = [[UDManager getUD]getEndId:self.s_admin_id];
    }
    [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
    [[ServicesManager getAPI] getMsgs:self.s_admin_id endId:self.Id onComplete:^(NSString *errorMsg, NSArray *list) {
        
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
        {
            if ([[[list lastObject] Id] intValue] != [[[self.data lastObject] Id] intValue] && self.data.count > 0) {
                [My_ServicesManager palyReceive];
            }
            self.data.array = list;
            self.endId = [[list lastObject] Id];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
        }
        [SVProgressHUD dismiss];
        
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_notify(group, queue, ^{
            [self GCDGetData];
    });
    
}

- (void)GCDGetData
{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
    });

    
    dispatch_group_t group = dispatch_group_create();
    
    
    dispatch_group_enter(group);
    [[ServicesManager getAPI] getMsgs:self.s_admin_id endId:self.Id onComplete:^(NSString *errorMsg, NSArray *list) {
            
            if (![self.endId isEqualToString:[[list lastObject] Id]]) {
                if ([[[list lastObject] Id] intValue] != [[[self.data lastObject] Id] intValue] && self.data.count > 0) {
                    [My_ServicesManager palyReceive];
                }
                
                self.endId = [[list lastObject] Id];
                self.data.array = list;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
            }
        dispatch_group_leave(group);
        

            
        }];
    
    dispatch_group_notify(group, queue, ^{
        if (!self.cancel) {
            [self GCDGetData];
        }
    });
    
    
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
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-60);
    }];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 124, self.view.width, 60)];
    
    bottomView.backgroundColor = WhiteAlphaColor;
    
    self.msgTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 10, self.view.width * 0.8 , 40)];
    self.msgTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.msgTextField.leftViewMode = UITextFieldViewModeAlways;
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGSize size = [change[@"new"] CGSizeValue];
    if (size.height > self.contentHeight && self.tableView.contentSize.height > self.tableView.height) {
        self.contentHeight = size.height;
        self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.height);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *returnCell;
    
    if (![self.data[indexPath.section] fromMe]) {
    
        COTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CO"];
        cell.section = indexPath.section;
        cell.width = tableView.width;
        [cell setValue:@60 forKey:@"height"];
        [cell setIcon:[[self.data[indexPath.section] sender] photo] Content:[self.data[indexPath.section] msg]];
//        NSLog(@"indexpath.section %ld",indexPath.section);
        cell.backgroundColor = [UIColor yellowColor];
        returnCell = cell;
    
    }
    else
    {
        CMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CM"];
        cell.section = indexPath.section;
        cell.width = tableView.width;
        [cell setValue:@60 forKey:@"height"];
        [cell setIcon:[[self.data[indexPath.section] sender] photo] Content:[self.data[indexPath.section] msg]];
//        NSLog(@"indexpath.section %ld",indexPath.section);
        cell.backgroundColor = [UIColor greenColor];
        returnCell = cell;
    }
    
    returnCell.backgroundColor = [UIColor clearColor];
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    CGFloat value = [self.rowAndHeight[key] floatValue];
//    if ([key integerValue] == 26) {
//        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%f",value);
//    }
//    NSLog(@"%f",value);
    return value;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != self.data.count - 1) {
    
        return 0.001;
    }
    return 10;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 120, 30)];
    
    btn.titleLabel.font = FontSize(Content_Ip_Font);
    
    
//    NSLog(@"section :%ld,timeString:%@",section,[self.data[section] ctime]);
    
    NSString *title = [NSString stringDateFromTimeInterval:[[self.data[section] ctime] longLongValue] withFormat:@"YYYY-MM-dd HH:mm"];
    
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
//    NSLog(@"%@",dic);
    if ([[NSString stringWithFormat:@"%d",[dic[@"s_admin_id"] intValue]] isEqualToString:self.s_admin_id]) {
        
        [My_ServicesManager palyReceive];
    }
    else
    {
        self.s_admin_id = dic[@"s_admin_id"];
    }
    [self getData];

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
                MsgVO *msg = [[MsgVO alloc]init];
                msg.fromMe = YES;
                msg.msg = self.msgTextField.text;
                self.msgTextField.text = @"";
                [self.data addObject:msg];
                [self.tableView reloadData];

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
//    NSLog(@"%@",self.rowAndHeight);
    
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
