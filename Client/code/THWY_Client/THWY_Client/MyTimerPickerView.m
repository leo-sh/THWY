//
//  MyTimerPickerView.m
//  THWY_Client
//
//  Created by wei on 16/8/21.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MyTimerPickerView.h"

@interface MyTimerPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDateComponents *selectedDateComponets;

@property (assign, nonatomic) NSInteger originHour;
@property (assign, nonatomic) NSInteger originMinute;

@end

@implementation MyTimerPickerView

-(void)drawRect:(CGRect)rect{
    for (UIView *view in self.pickerView.subviews) {
        if (view.height<1) {
            [view removeFromSuperview];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [My_NoteCenter addObserver:self selector:@selector(updateDate:) name:@"dateFailed" object:nil];
        self.backgroundColor = My_clearColor;
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.pickerView.backgroundColor = My_clearColor;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.calendar.timeZone = [NSTimeZone localTimeZone];
        self.selectedDateComponets.timeZone = self.calendar.timeZone;
        
        self.selectedDateComponets = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
        
        self.hour = self.selectedDateComponets.hour;
        self.minute = self.selectedDateComponets.minute;
        
        self.originHour = self.hour;
        self.originMinute = self.minute;
        
        [self.pickerView selectRow:[self.selectedDateComponets hour] inComponent:0 animated:NO];
        [self.pickerView selectRow:[self.selectedDateComponets minute] inComponent:2 animated:NO];
        
        [self addSubview:self.pickerView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        label.text = @":";
        label.backgroundColor = My_clearColor;
        label.center = CGPointMake(self.pickerView.center.x+10, self.pickerView.center.y);
        [self addSubview:label];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) { // component是栏目index，从0开始，后面的row也一样是从0开始
        case 0: {
            return 24;
        }
        case 1:
            return 0;
        case 2:
            return 60;
        default:
            return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        dateLabel.height = 40;
        [dateLabel setFont:self.font];
        [dateLabel setTextColor:self.fontColor];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    switch (component) {
        case 0: {
//            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear fromDate:self.selectedDate];
            NSString *currentHour = [NSString stringWithFormat:@"%02ld", row];
            [dateLabel setText:currentHour];
            dateLabel.textAlignment = NSTextAlignmentRight;
            self.originHour = row;
            break;
        }
        case 1:{
            
        }
        case 2: {

            NSString *currentHour = [NSString stringWithFormat:@"%02ld", row];
            [dateLabel setText:currentHour];
            dateLabel.textAlignment = NSTextAlignmentLeft;
            self.originMinute = row;
            break;
        }

        default:
            break;
    }
    return dateLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    switch (component) {
        case 0: {
            self.hour = row;
            break;
        }
        case 2: {
            self.minute = row;
            break;
        }
        default:
            break;
    }

    [pickerView reloadAllComponents]; // 注意，这一句不能掉，否则选择后每一栏的数据不会重载，其作用与UITableView中的reloadData相似
    NSLog(@"hour:%ld.  minute:%ld", self.hour, self.minute);
    [self.delegate scrollEnded:@{@"hour":@(self.hour), @"minute":@(self.minute)} pickerViewType:TimePickerType];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.size.width / 3;
}

- (void)updateDate:(NSNotification *)notification{
    if ([notification.userInfo[@"PickerViewType"] integerValue] == TimePickerType) {
        
        [self.pickerView selectRow:[self.selectedDateComponets hour] inComponent:0 animated:NO];
        [self.pickerView selectRow:[self.selectedDateComponets minute] inComponent:2 animated:NO];
        
    }
}

- (void)dealloc{
    [My_NoteCenter removeObserver:self name:@"dateFailed" object:nil];
}

@end
