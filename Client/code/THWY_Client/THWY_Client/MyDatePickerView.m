//
//  MyDatePickerView.m
//  THWY_Client
//
//  Created by wei on 16/8/20.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MyDatePickerView.h"

@interface MyDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDateComponents *selectedDateComponets;
@property (strong, nonatomic) NSDate *originDate;

@end

@implementation MyDatePickerView

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
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.calendar.timeZone = [NSTimeZone localTimeZone];
        self.selectedDate = [[NSDate date] dateByAddingTimeInterval:8*60*60];
        self.originDate = self.selectedDate;
        self.selectedDateComponets = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
        self.selectedDateComponets.timeZone = self.calendar.timeZone;

        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
        
        [self.pickerView selectRow:[self.selectedDateComponets month]-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:[self.selectedDateComponets day]-1 inComponent:2 animated:NO];
        
        [self addSubview:self.pickerView];

    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) { // component是栏目index，从0开始，后面的row也一样是从0开始
        case 0: { // 第一栏为年，这里startDate和endDate为起始时间和截止时间，请自行指定
            NSDateComponents *startCpts = [self.calendar components:NSCalendarUnitYear fromDate:self.startDate];
            NSDateComponents *endCpts = [self.calendar components:NSCalendarUnitYear fromDate:self.endDate];
            return [endCpts year] - [startCpts year] + 1;
        }
        case 1: // 第二栏为月份
            return 12;
        case 2: { // 第三栏为对应月份的天数
            NSRange dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                   inUnit:NSCalendarUnitMonth
                                                  forDate:self.selectedDate];
//            NSLog(@"current month: %ld, day number: %ld", [[self.calendar components:NSCalendarUnitMonth fromDate:self.selectedDate] month], dayRange.length);
            return dayRange.length;
        }
        default:
            return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        [dateLabel setFont:self.font];
        [dateLabel setTextColor:self.fontColor];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    switch (component) {
        case 0: {
            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear fromDate:self.startDate];
            NSString *currentYear = [NSString stringWithFormat:@"%ld", [components year]+row];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentRight;
            break;
        }
        case 1: { // 返回月份可以用DateFormatter，这样可以支持本地化
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            NSArray *monthSymbols = [formatter shortMonthSymbols];
            [dateLabel setText:[monthSymbols objectAtIndex:row]];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            [dateLabel setText:[NSString stringWithFormat:@" %ld", row+1]];
            dateLabel.textAlignment = NSTextAlignmentLeft;
            break;
        }
        default:
            break;
    }
    self.originDate = self.selectedDate;
    return dateLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    AudioServicesPlayAlertSound(1103);
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    switch (component) {
        case 0: {
            NSDateComponents *indicatorComponents = [self.calendar components:NSCalendarUnitYear
                                                                     fromDate:self.startDate];
            NSInteger year = [indicatorComponents year] + row;
            [self.selectedDateComponets setYear:year];
            break;
        }
        case 1: {
            NSDateComponents *targetComponents = [self.calendar components:unitFlags fromDate:self.selectedDate];
            targetComponents.timeZone = self.calendar.timeZone;
            [targetComponents setMonth:row + 1];
            NSInteger oldDay = [targetComponents day];
            [targetComponents setDay:1];
            if ([self.selectedDateComponets day]>[self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self.calendar dateFromComponents:targetComponents]].length) {
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }else{
                [targetComponents setDay:oldDay];
            }
            self.selectedDateComponets = targetComponents;
            break;
        }
        case 2: {
            NSDateComponents *targetComponents = [self.calendar components:unitFlags fromDate:self.selectedDate];
            targetComponents.timeZone = self.calendar.timeZone;
            [targetComponents setDay:row+1];
            self.selectedDateComponets = targetComponents;
            break;
        }
        default:
            break;
    }
    self.selectedDate = [self.calendar dateFromComponents:self.selectedDateComponets];
    [pickerView reloadAllComponents]; // 注意，这一句不能掉，否则选择后每一栏的数据不会重载，其作用与UITableView中的reloadData相似
//    NSLog(@"selectedData:  %@", self.selectedDate);
    [self.delegate scrollEnded:@{@"date":self.selectedDate} pickerViewType:DatePickerType];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.size.width / 3;
}

- (void)updateDate:(NSNotification *)notification{
    if ([notification.userInfo[@"PickerViewType"] integerValue] == DatePickerType) {
        self.selectedDate = [[NSDate date] dateByAddingTimeInterval:8*60*60];
        self.selectedDateComponets = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
        [self.pickerView selectRow:[self.selectedDateComponets month]-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:[self.selectedDateComponets day]-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:[self.selectedDateComponets year]-1 inComponent:0 animated:NO];
    }
}

- (void)dealloc{
    [My_NoteCenter removeObserver:self name:@"dateFailed" object:nil];
}

@end
