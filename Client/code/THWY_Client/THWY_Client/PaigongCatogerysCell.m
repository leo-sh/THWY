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

@interface PaigongCatogerysCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn_kaidan;
@property (weak, nonatomic) IBOutlet UIButton *btn_budan;
@property (weak, nonatomic) IBOutlet UIButton *btn_yuyue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint3;


@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *unselectedImage;

@property (strong, nonatomic) MyDatePickerView *datePickerView;
@property (strong, nonatomic) MyTimerPickerView *timePickerView;

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
   
    CGFloat topMargin = 5.0;

    self.datePickerView = [[MyDatePickerView alloc] initWithFrame:CGRectMake(10, self.btn_kaidan.bottom, My_ScreenW-40, 40)];
    self.datePickerView.font = FontSize(CONTENT_FONT+1);
    self.datePickerView.fontColor = [UIColor blackColor];
    self.datePickerView.startDate = [NSDate date];
    self.datePickerView.endDate = [NSDate dateWithTimeIntervalSinceNow:180*24*60*60];
    
    self.timePickerView = [[MyTimerPickerView alloc] initWithFrame:CGRectMake(10, self.datePickerView.bottom , My_ScreenW-40, 40)];
    self.timePickerView.font = FontSize(CONTENT_FONT+1);
    self.timePickerView.fontColor = [UIColor blackColor];
    
    self.showPikerView = NO;
    
}

- (IBAction)kaidanOnclick:(UIButton *)sender {
    
    [self.btn_kaidan setImage:self.selectedImage forState:UIControlStateNormal];
    [self.btn_budan setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.btn_yuyue setImage:self.unselectedImage forState:UIControlStateNormal];
    self.flag = 1;
    
    [self.datePickerView removeFromSuperview];
    [self.timePickerView removeFromSuperview];
    
    if (self.showPikerView) {
        self.showPikerView = NO;
        [self.tableView reloadData];
    }

}

- (IBAction)budanOnclick:(UIButton *)sender {
    
    [self.btn_kaidan setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.btn_budan setImage:self.selectedImage forState:UIControlStateNormal];
    [self.btn_yuyue setImage:self.unselectedImage forState:UIControlStateNormal];
    self.flag = 2;
    
    [self.datePickerView removeFromSuperview];
    [self.timePickerView removeFromSuperview];

    if (self.showPikerView) {
        self.showPikerView = NO;
        [self.tableView reloadData];
    }
    
}

- (IBAction)yuyueOnclick:(UIButton *)sender {
    
    [self.btn_yuyue setImage:self.selectedImage forState:UIControlStateNormal];
    [self.btn_kaidan setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.btn_budan setImage:self.unselectedImage forState:UIControlStateNormal];
    self.flag = 3;
    
    [self.contentView addSubview:self.datePickerView];
    [self.contentView addSubview:self.timePickerView];
    
    if (!self.showPikerView) {
        self.showPikerView = YES;
//        [self.tableView reloadData];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
