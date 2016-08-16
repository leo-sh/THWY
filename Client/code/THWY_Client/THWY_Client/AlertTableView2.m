//
//  AlertTableView.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/8.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "AlertTableView2.h"
#import "ServicesManager.h"
#define kCurrentWindow [[UIApplication sharedApplication].windows firstObject]
@interface AlertTableView2()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property NSArray *data;
@end
@implementation AlertTableView2
- (instancetype)initWithNumber:(GetDataMethod)method withData:(NSArray *)data
{
    
    if (self = [super init]) {
       
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = 30;
        self.method = method;
        self.data = data;
        if (method == GetComplainType) {

            self.frame = CGRectMake(0, 0, 130, 30 * self.data.count);
            

        }
        else if(method == GetYear)
        {
            self.frame = CGRectMake(0, 0, 100, 30 * self.data.count);

        }
        else if(method == GetPayStatu)
        {
            self.frame = CGRectMake(0, 0, 100, 30 * self.data.count);
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

       string  = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    }
    else if (self.method == GetYear)
    {
        string = self.data[indexPath.row];
    }
    else if (self.method == GetPayStatu)
    {
       string = [NSString stringWithFormat:@"%d",indexPath.row - 1];
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
        backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [backgroundView addGestureRecognizer:tap];
        [kCurrentWindow addSubview:backgroundView];
        
        self.center = backgroundView.center;
        
        [backgroundView addSubview:self];
        
    }
}

- (void)showOriginY:(CGFloat)y showCentenX:(CGFloat)x
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:kCurrentWindow.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    [backgroundView addGestureRecognizer:tap];
    
    [kCurrentWindow addSubview:backgroundView];
    
    self.y= y;
    self.centerX = x;
    
    [backgroundView addSubview:self];

}

- (void)tap
{
    [self hide];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

@end
