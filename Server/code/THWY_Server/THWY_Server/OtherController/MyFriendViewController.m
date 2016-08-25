//
//  MyFriendViewController.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MyFriendViewController.h"
#import "ServicesManager.h"
#import "MyFriendTableViewCell.h"
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
    
    UIImage *image = [UIImage imageNamed:@"b背景"];
    self.view.layer.contents = (id)image.CGImage;
    
}

- (void)getData
{
    
    if (self.index == 0) {
        [self.searchFriend removeFromSuperview];
        self.topView.height = TopViewH;
        self.tableView.y = self.topView.bottom + 10;
        [[ServicesManager getAPI] getFriends:^(NSString *errorMsg, NSArray *list) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.data.array = list;
                [self.tableView reloadData];
                
            });
        }];
    }
    else
    {
        [self.data removeAllObjects];
        self.searchFriend = [[UITextField alloc]initWithFrame:CGRectMake(20, self.segmentedControl.bottom + 20, self.topView.width - 40, 40)];
        self.searchFriend.font = FontSize(CONTENT_FONT);
        self.searchFriend.placeholder = @"请输入好友手机号或姓名";
        self.searchFriend.layer.borderColor = CellUnderLineColor.CGColor;
        self.searchFriend.layer.borderWidth = 0.5;
        self.searchFriend.backgroundColor = WhiteAlphaColor;
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
    MyFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[MyFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.width = tableView.width;
    
    UserVO *temp = self.data[indexPath.row];
    
    NSString *content = [NSString stringWithFormat:@"%@/%@",temp.real_name,temp.up_group.group];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setImage:@"Avatar" Content:content ID:@"1"];
    cell.phoneNumber = temp.cellphone;
    return cell;
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
    MyFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.clickStatu =!cell.clickStatu;
}

#pragma mark -- segmentIndex改变的方法
- (void)change
{
    self.index =(int)self.segmentedControl.selectedSegmentIndex;
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
