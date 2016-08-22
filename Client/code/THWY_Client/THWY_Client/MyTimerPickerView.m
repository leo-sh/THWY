//
//  MyTimerPickerView.m
//  THWY_Client
//
//  Created by wei on 16/8/21.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MyTimerPickerView.h"

@interface MyTimerPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDateComponents *selectedDateComponets;

@end

@implementation MyTimerPickerView

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
        
        self.hour = self.selectedDateComponets.hour;
        self.minute = self.selectedDateComponets.minute;
        
        [self selectRow:[self.selectedDateComponets hour]-1 inComponent:0 animated:NO];
        [self selectRow:[self.selectedDateComponets minute]-1 inComponent:2 animated:NO];
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
            return 1;
        case 2:
            return 59;
        default:
            return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
//        dateLabel.height = 40;
        [dateLabel setFont:self.font];
        [dateLabel setTextColor:self.fontColor];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    switch (component) {
        case 0: {
//            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear fromDate:self.selectedDate];
            NSString *currentHour = [NSString stringWithFormat:@"%02ld", 1 + row];
            [dateLabel setText:currentHour];
            dateLabel.textAlignment = NSTextAlignmentRight;
            break;
        }
        case 1:{
            [dateLabel setText:@":"];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {

            NSString *currentHour = [NSString stringWithFormat:@"%02ld", 1 + row];
            [dateLabel setText:currentHour];
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

    switch (component) {
        case 0: {
            self.hour = row++;
            break;
        }
        case 2: {
            self.minute = row++;
            break;
        }
        default:
            break;
    }

    [pickerView reloadAllComponents]; // 注意，这一句不能掉，否则选择后每一栏的数据不会重载，其作用与UITableView中的reloadData相似
//    NSLog(@"%d", self.selectedDateComponets.day);
//    NSLog(@"%@", self.selectedDate);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.rowHeight?:48.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.size.width / 3-30;
}


@end
