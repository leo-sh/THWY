//
//  PaigongCatogerysCell.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PaigongCatogerysCell.h"
#import "MyDatePickerView.h"
#import "MyTimerPickerView.h"
#import "PickerViewProtocol.h"

@interface PaigongCatogerysCell ()<PickerViewProtocol>

@property (weak, nonatomic) IBOutlet UIButton *btn_kaidan;
@property (weak, nonatomic) IBOutlet UIButton *btn_budan;

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *unselectedImage;

@property (strong, nonatomic) MyDatePickerView *datePickerView;
@property (strong, nonatomic) MyTimerPickerView *timePickerView;
@property (strong, nonatomic) UILabel *line;
@end

@implementation PaigongCatogerysCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.flag = 1;
    UIImage *imageselect = [UIImage imageNamed:@"repaire_selected"] ;
    self.selectedImage = [UIImage scaleImage:imageselect toScale:15/33.0];
    [self.btn_kaidan setImage:self.selectedImage forState:UIControlStateNormal];
    
    self.unselectedImage= [UIImage scaleImage:[UIImage imageNamed:@"repaire_unselected"] toScale:15/33.0];
    [self.btn_budan setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.btn_yuyue setImage:self.unselectedImage forState:UIControlStateNormal];
    
    self.constraint1.constant = 10.0/375*My_ScreenW;
    self.constraint2.constant = 10.0/375*My_ScreenW;
    self.constraint3.constant = 10.0/375*My_ScreenW;
   
//    CGFloat topMargin = 5.0;

    self.datePickerView = [[MyDatePickerView alloc] initWithFrame:CGRectMake(10, self.btn_kaidan.bottom, My_ScreenW-40, 65)];
    self.datePickerView.font = FontSize(CONTENT_FONT+1);
    self.datePickerView.fontColor = [UIColor blackColor];
    self.datePickerView.startDate = [NSDate date];
    self.datePickerView.endDate = [NSDate dateWithTimeIntervalSinceNow:180*24*60*60];
    self.datePickerView.delegate = self;
    
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(15, self.datePickerView.bottom-5, My_ScreenW-50, 0.5)];
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.line];
    
    self.timePickerView = [[MyTimerPickerView alloc] initWithFrame:CGRectMake(10, self.datePickerView.bottom-10 , My_ScreenW-40, 65)];
    self.timePickerView.font = FontSize(CONTENT_FONT+1);
    self.timePickerView.fontColor = [UIColor blackColor];
    self.timePickerView.delegate = self;
    
    [self.contentView addSubview:self.datePickerView];
    [self.contentView addSubview:self.timePickerView];
    [self.datePickerView setHidden:YES];
    [self.timePickerView setHidden:YES];
    [self.line setHidden:YES];
}

- (void)updateView{
    
    switch (self.flag) {
        case 1:{
            [self.btn_kaidan setImage:self.selectedImage forState:UIControlStateNormal];
            [self.btn_budan setImage:self.unselectedImage forState:UIControlStateNormal];
            [self.btn_yuyue setImage:self.unselectedImage forState:UIControlStateNormal];
            
            [self.datePickerView setHidden:YES];
            [self.timePickerView setHidden:YES];
            [self.line setHidden:YES];

            break;
        }
        case 2:{
            [self.btn_kaidan setImage:self.unselectedImage forState:UIControlStateNormal];
            [self.btn_budan setImage:self.selectedImage forState:UIControlStateNormal];
            [self.btn_yuyue setImage:self.unselectedImage forState:UIControlStateNormal];
            
            [self.datePickerView setHidden:YES];
            [self.timePickerView setHidden:YES];
            [self.line setHidden:YES];
            break;
        }
        case 3:{
            [self.btn_yuyue setImage:self.selectedImage forState:UIControlStateNormal];
            [self.btn_kaidan setImage:self.unselectedImage forState:UIControlStateNormal];
            [self.btn_budan setImage:self.unselectedImage forState:UIControlStateNormal];
            
            [self.datePickerView setHidden:NO];
            [self.timePickerView setHidden:NO];
            [self.line setHidden:NO];
            break;
        }
        default:
            break;
    }
    [self layoutIfNeeded];
    
}

- (IBAction)kaidanOnclick:(UIButton *)sender {
    
    [self.btn_kaidan setImage:self.selectedImage forState:UIControlStateNormal];
    [self.btn_budan setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.btn_yuyue setImage:self.unselectedImage forState:UIControlStateNormal];
    self.flag = 1;
    
    [self.datePickerView setHidden:YES];
    [self.timePickerView setHidden:YES];
    [self.line setHidden:YES];
    if (self.showPikerView) {
        self.showPikerView = NO;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    }

}

- (IBAction)budanOnclick:(UIButton *)sender {
    
    [self.btn_kaidan setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.btn_budan setImage:self.selectedImage forState:UIControlStateNormal];
    [self.btn_yuyue setImage:self.unselectedImage forState:UIControlStateNormal];
    self.flag = 2;
    
    [self.datePickerView setHidden:YES];
    [self.timePickerView setHidden:YES];
    [self.line setHidden:YES];
    if (self.showPikerView) {
        self.showPikerView = NO;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (IBAction)yuyueOnclick:(UIButton *)sender {
    
    [self.btn_yuyue setImage:self.selectedImage forState:UIControlStateNormal];
    [self.btn_kaidan setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.btn_budan setImage:self.unselectedImage forState:UIControlStateNormal];
    self.flag = 3;
    
    [self.datePickerView setHidden:NO];
    [self.timePickerView setHidden:NO];
    [self.line setHidden:NO];
    if (!self.showPikerView) {
        self.showPikerView = YES;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (void)scrollEnded:(NSDictionary *)data pickerViewType:(PickerViewType)type{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[self.datePickerView.selectedDate dateByAddingTimeInterval:-8*60*60]];
    comp.timeZone = calendar.timeZone;
    [comp setHour:self.timePickerView.hour];
    [comp setMinute:self.timePickerView.minute];
    
    NSDate *date = [[calendar dateFromComponents:comp] dateByAddingTimeInterval:8*60*60];
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:8*60*60];
//    NSDate *date = [calendar dateFromComponents:comp];
    if ([date compare:now] == NSOrderedAscending) {
        [My_NoteCenter postNotificationName:@"dateFailed" object:nil userInfo:@{@"PickerViewType":@(type)}];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择正确的时间" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self.vc presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
}

- (NSUInteger)order_timestamp{
   
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[self.datePickerView.selectedDate dateByAddingTimeInterval:-8*60*60]];
    [comp setHour:self.timePickerView.hour];
    [comp setMinute:self.timePickerView.minute];
    
    NSUInteger timeInterval = [[[calendar dateFromComponents:comp] dateByAddingTimeInterval:8*60*60] timeIntervalSince1970];
    return timeInterval;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
