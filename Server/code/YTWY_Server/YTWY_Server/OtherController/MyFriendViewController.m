//
//  MyFriendViewController.m
//  YTWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MyFriendViewController.h"
#import "ServicesManager.h"
#import "MyFriendTableViewCell.h"
#import "SVProgressHUD.h"
#import "FindFriendTableViewCell.h"
#define TopViewH 60
@interface MyFriendViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property UITableView *tableView;
@property UISegmentedControl *segmentedControl;
@property NSMutableArray *data;
@property UIView *topView;
@property UIImageView *segementBackgroundImageView;
@property int page;
@property NSDictionary *rowAndHeight;
@property int index;
@property UITextField *searchFriend;
@property NSArray *tempData;
@property BOOL addFriendStatu;
@end

@implementation MyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewInitSetting];
    [self getData];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)ViewInitSetting
{
    self.title = @"我的好友";
    self.data = [NSMutableArray array];
    self.page = 0;
    self.index = 0;
    
    self.addFriendStatu = YES;
    
    UIImage *image = [UIImage imageNamed:@"b背景"];
    self.view.layer.contents = (id)image.CGImage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSuccess) name:@"AddStatu" object:nil];
    
}

- (void)getData
{
    
    if (self.index == 0) {
        if (self.addFriendStatu) {
            [SVProgressHUD showWithStatus:@"正在加载数据,请稍后......"];
        }
        [self.searchFriend removeFromSuperview];
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(TopViewH);
        }];
        self.tableView.y = self.topView.bottom + 10;
        [[ServicesManager getAPI] getFriends:^(NSString *errorMsg, NSArray *list) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.addFriendStatu) {
                    self.data.array = list;
                    self.tempData = list;

                }
                else
                {
                    self.data.array = self.tempData;
                }
                
                
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                
            });
        }];
    }
    else
    {
        self.addFriendStatu = NO;
        [self.data removeAllObjects];
        self.searchFriend = [[UITextField alloc]initWithFrame:CGRectMake(20, self.segmentedControl.bottom + 20, self.topView.width - 40, 40)];
        self.searchFriend.font = FontSize(CONTENT_FONT);
        self.searchFriend.leftViewMode = UITextFieldViewModeAlways;
        self.searchFriend.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        [btn setImage:[UIImage imageNamed:@"添加好友"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(searchFriendInfo) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        self.searchFriend.rightViewMode = UITextFieldViewModeAlways;
        self.searchFriend.rightView = view;
        self.searchFriend.placeholder = @"请输入好友手机号或姓名";
        self.searchFriend.layer.borderColor = CellUnderLineColor.CGColor;
        self.searchFriend.layer.borderWidth = 0.5;
        self.searchFriend.backgroundColor = WhiteAlphaColor;
        self.searchFriend.returnKeyType = UIReturnKeySearch;
        self.searchFriend.delegate = self;
        [self.topView addSubview:self.searchFriend];
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {

            make.height.mas_equalTo(self.searchFriend.bottom);
        }];
        [self.tableView reloadData];

    }
    

}

- (void)createUI
{
    self.topView = [[UIImageView alloc]init];
    
    self.topView.backgroundColor = [UIColor clearColor];
    
    self.topView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(TopViewH);
    }];
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"全部好友",@"添加好友"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.frame = CGRectMake(40, 15,My_ScreenW - 100 ,  40);
    self.segmentedControl.center = CGPointMake(My_ScreenW/2, self.segmentedControl.center.y);
    self.segmentedControl.layer.cornerRadius = 10;
    self.segmentedControl.clipsToBounds = YES;
    self.segmentedControl.layer.borderWidth = 1;
    self.segmentedControl.layer.borderColor = My_NAV_BG_Color.CGColor;
    self.segmentedControl.tintColor = My_NAV_BG_Color;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:My_NAV_BG_Color,NSForegroundColorAttributeName,FontSize(CONTENT_FONT + 2),NSFontAttributeName ,nil];
    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [self.topView addSubview:self.segmentedControl];
    
    [self.segmentedControl addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.alpha = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(0);
    }];
    
    
    

}

#pragma mark- tabelView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    
    if (self.index == 0) {
        MyFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[MyFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.width = tableView.width;
        [cell setValue:@60 forKey:@"height"];
        UserVO *temp = self.data[indexPath.row];
        cell.friendName = temp.real_name;

        NSString *content = [NSString stringWithFormat:@"%@/%@",temp.real_name,temp.up_group.group];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setImage:temp.photo Content:content ID:temp.admin_id];
        cell.phoneNumber = temp.cellphone;
        
        returnCell = cell;

    }
    else
    {
        FindFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (cell == nil) {
            cell = [[FindFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
        }
        
        cell.width = tableView.width;
        
        UserVO *temp = self.data[indexPath.row];
        
        cell.admin_id = temp.admin_id;

        NSString *nameAndPhone = [NSString stringWithFormat:@"%@  %@",temp.real_name,temp.cellphone];
        
        NSString *estateAndJob = [NSString stringWithFormat:@"%@ %@",temp.up_group.project,temp.up_group.group];
        
        [cell setIcon:temp.photo NameAndphone:nameAndPhone EstateAndJob:estateAndJob];
        
        returnCell = cell;
        
    }
    [returnCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        MyFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.clickStatu =!cell.clickStatu;
        
        if (cell.clickStatu) {
            for (int i = 0; i <self.data.count; i ++) {
                
                if (i != indexPath.row) {
                    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
                    
                    MyFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath1];
                    
                    cell.clickStatu = NO;
                }
                
            }
        }
        
    }
    
}

#pragma mark -- segmentIndex改变的方法
- (void)change
{
    self.index =(int)self.segmentedControl.selectedSegmentIndex;
    [self.searchFriend endEditing:YES];
    NSLog(@"height:%f",self.topView.height);
    [self getData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self searchFriendInfo];
    
    return YES;
}

- (void)searchFriendInfo
{
    [self.searchFriend resignFirstResponder];
    if (self.searchFriend.text.length == 0) {
        return;
    }
    
    if ([self.searchFriend.text substringToIndex:1].intValue > 0) {
        [SVProgressHUD showWithStatus:@"加载数据中,请稍后..."];
        [[ServicesManager getAPI] findFriends:self.searchFriend.text name:@"" onComplete:^(NSString *errorMsg, NSArray *list) {
            
            if (errorMsg) {
                [SVProgressHUD showWithStatus:errorMsg];
            }
            else
            {
                self.data.array = list;
                
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
            
        }];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"加载数据中,请稍后..."];
        [[ServicesManager getAPI] findFriends:@"" name:self.searchFriend.text onComplete:^(NSString *errorMsg, NSArray *list) {
            
            if (errorMsg) {
                [SVProgressHUD showWithStatus:errorMsg];
            }
            else
            {
                self.data.array = list;
                
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }

        }];
    }
}

- (void)addSuccess
{
    self.addFriendStatu = YES;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.index = 0;
    [self getData];
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
