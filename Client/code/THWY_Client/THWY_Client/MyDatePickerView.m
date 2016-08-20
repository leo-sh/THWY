//
//  MyDatePickerView.m
//  THWY_Client
//
//  Created by wei on 16/8/20.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MyDatePickerView.h"

@interface MyDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDateComponents *selectedDateComponets;


@end

@implementation MyDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.selectedDateComponets.timeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
        self.selectedDate = [[NSDate date] dateByAddingTimeInterval:8*60*60];
        self.selectedDateComponets = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];

        [self selectRow:[self.selectedDateComponets month]-1 inComponent:1 animated:NO];
        [self selectRow:[self.selectedDateComponets day]-1 inComponent:2 animated:NO];
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
//            NSDateComponents *endCpts = self.selectedDateComponets;
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
            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear fromDate:self.selectedDate];
            NSString *currentYear = [NSString stringWithFormat:@"%ld", [components year] + row];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentRight;
            break;
        }
        case 1: { // 返回月份可以用DateFormatter，这样可以支持本地化
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            NSArray *monthSymbols = [formatter monthSymbols];
            [dateLabel setText:[monthSymbols objectAtIndex:row]];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            NSRange dateRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:self.selectedDate];
            NSString *currentDay = [NSString stringWithFormat:@"%ld", (row + 1) % (dateRange.length + 1)];
            [dateLabel setText:currentDay];
            dateLabel.textAlignment = NSTextAlignmentLeft;
            break;
        }
        default:
            break;
    }
    
    return dateLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    switch (component) {
        case 0: {
            NSDateComponents *indicatorComponents = [self.calendar components:NSCalendarUnitYear
                                                                     fromDate:self.startDate];
            NSInteger year = [indicatorComponents year] + row;
            NSDateComponents *targetComponents = [self.calendar components:unitFlags
                                                                  fromDate:self.selectedDate];
            [targetComponents setYear:year];
            self.selectedDateComponets = targetComponents;
            break;
        }
        case 1: {
            NSDateComponents *targetComponents = [self.calendar components:unitFlags
                                                                  fromDate:self.selectedDate];
            [targetComponents setMonth:row + 1];
            self.selectedDateComponets = targetComponents;
//            if ([targetComponents day]>[self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self.calendar dateFromComponents:self.selectedDateComponets]].length) {
//            }
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
        }
        case 2: {
            NSDateComponents *targetComponents = [self.calendar components:unitFlags fromDate:self.selectedDate];
            [targetComponents setDay:row+1];
            self.selectedDateComponets = targetComponents;
            break;
        }
        default:
            break;
    }
    self.selectedDate = [self.calendar dateFromComponents:self.selectedDateComponets];
    [pickerView reloadAllComponents]; // 注意，这一句不能掉，否则选择后每一栏的数据不会重载，其作用与UITableView中的reloadData相似
    NSLog(@"%d", self.selectedDateComponets.day);
    NSLog(@"%@", self.selectedDate);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.rowHeight?:44.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.size.width / 3;
}

@end
