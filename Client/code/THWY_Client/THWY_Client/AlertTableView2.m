//
//  AlertTableView.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/8.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertTableView2.h"
#import "ServicesManager.h"
#import "SVProgressHUD/SVProgressHUD.h"
#define kCurrentWindow [[UIApplication sharedApplication].windows firstObject]
@interface AlertTableView2()<UITableViewDelegate,UITableViewDataSource>
@property NSArray *data;
@end
@implementation AlertTableView2
- (instancetype)initWithNumber:(GetDataMethod)method
{
    
    if (self = [super init]) {
       
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = 30;
        self.method = method;
        if (method == GetComplainType) {
            [[ServicesManager getAPI]getComplaintTypes:^(NSString *errorMsg, NSArray *list) {
                
                NSMutableArray *array = [NSMutableArray array];
                
                for (ComplaintTypeVO *temp in list) {
                    
                    [array addObject:temp.complaint_type];
                }
                
                self.data = array;
                
                self.frame = CGRectMake(0, 0, 105, 30 * self.data.count);
                self.center = kCurrentWindow.center;
                
                if (self.data.count != 0) {
                    [self showCenter];
                }
                else
                {
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showInfoWithStatus:@"网络访问有问题"];
                }
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [self reloadData];
//                    
//                });
                
            }];
        }
        else if(method == GetYear)
        {
            self.data = @[@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016"];
            self.frame = CGRectMake(0, 0, 90, 30 * self.data.count);

        }
        else
        {
            self.data = @[@"全部",@"未支付",@"部分支付",@"已支付",@"退款"];
            self.frame = CGRectMake(0, 0, 90, 30 * self.data.count);
        }
        
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.data[indexPath.row];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.textLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string;
    if (self.method == GetComplainType) {

       string  = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    }
    else if (self.method == GetYear)
    {
        string = self.data[indexPath.row];
    }
    else
    {
       string = [NSString stringWithFormat:@"%ld",indexPath.row - 1];
    }
    NSArray *array = @[self.data[indexPath.row],string];
    
    [self.AlertDelegate returnData:array];
    [self hide];
}

- (void)hide
{
    if (self.superview) {
        [self.superview removeFromSuperview];
    }
}

- (void)showCenter
{
    if (self.superview == nil) {
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:kCurrentWindow.bounds];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [kCurrentWindow addSubview:backgroundView];
        
        self.center = backgroundView.center;
        
        [backgroundView addSubview:self];
        
    }
}

- (void)showOriginY:(CGFloat)y OriginX:(CGFloat)x
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:kCurrentWindow.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [kCurrentWindow addSubview:backgroundView];
    
    self.y = y;
    self.x = x;
    
    [backgroundView addSubview:self];

}


@end
