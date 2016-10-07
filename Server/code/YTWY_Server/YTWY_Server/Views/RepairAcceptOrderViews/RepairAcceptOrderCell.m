//
//  RepairAcceptOrderCell.m
//  YTWY_Server
//
//  Created by wei on 16/8/22.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RepairAcceptOrderCell.h"
#import "RunSliderLabel.h"

@interface RepairAcceptOrderCell ()

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *houseLabel;
@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *callNumberLabel;

@property (strong, nonatomic) RunSliderLabel *houseDetailLabel;
@property (strong, nonatomic) UILabel *categoryDetailLabel;
@property (strong, nonatomic) UILabel *timeDetailLabel;
@property (strong, nonatomic) UILabel *callNumberDetailLabel;

@property (strong, nonatomic) UIImageView *timerImage;
@property (strong, nonatomic) UILabel *timerDetailLabel;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) TaskVO *task;

@end

@implementation RepairAcceptOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(CONTENT_FONT-1),NSFontAttributeName, nil];
        CGRect rect = [[NSString stringWithFormat:@"报修类别:"] boundingRectWithSize:CGSizeMake(0, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        
        CGFloat topMargin = 10/667.0*My_ScreenH;
        CGFloat leftMargin = topMargin*0.5;
        CGFloat imageWidth = 50/667.0*My_ScreenH;
        CGFloat detailWidth = My_ScreenW-2*topMargin-(3*topMargin+leftMargin+imageWidth)-rect.size.width;
        self.leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"repairStatistics_业主报修"]];
        [self.contentView addSubview:self.leftImageView];
        
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(topMargin);
            make.height.mas_equalTo(imageWidth);
            make.width.mas_equalTo(self.leftImageView.mas_height);
        }];
        
        self.houseLabel = [[UILabel alloc] init];
        self.houseLabel.text = @"报修房源:";
        [self setAttributesForLabel:self.houseLabel];
        [self.contentView addSubview:self.houseLabel];
        [self.houseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(topMargin);
            make.left.mas_equalTo(self.leftImageView.mas_right).offset(topMargin);
//            make.width.mas_equalTo(rect.size.width);
        }];
        
        self.houseDetailLabel = [[RunSliderLabel alloc] init];
        [self.contentView addSubview:self.houseDetailLabel];
        [self.houseDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseLabel.mas_right).offset(leftMargin);
            make.centerY.mas_equalTo(self.houseLabel.mas_centerY);
            make.height.mas_equalTo(self.houseLabel.mas_height);
            make.width.mas_equalTo(detailWidth);
        }];
        
        self.categoryLabel = [[UILabel alloc] init];
        self.categoryLabel.text = @"报修类别:";
        self.categoryLabel.textColor = [UIColor darkGrayColor];
        [self.categoryLabel sizeToFit];
        self.categoryLabel.numberOfLines = 1;
        self.categoryLabel.font = FontSize(CONTENT_FONT-1);
        [self.contentView addSubview:self.categoryLabel];
        [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseLabel.mas_left);
            make.top.mas_equalTo(self.houseLabel.mas_bottom);
            make.width.mas_equalTo(self.houseLabel.mas_width);
        }];
        
        self.categoryDetailLabel = [[UILabel alloc] init];
        self.categoryDetailLabel.text = @"";
        self.categoryDetailLabel.textColor = [UIColor darkGrayColor];
        [self.categoryDetailLabel sizeToFit];
        self.categoryDetailLabel.numberOfLines = 0;
        self.categoryDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.categoryDetailLabel.font = FontSize(CONTENT_FONT-1);
        [self.contentView addSubview:self.categoryDetailLabel];
        [self.categoryDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseDetailLabel.mas_left);
//            make.centerY.mas_equalTo(self.categoryLabel.mas_centerY);
            make.top.mas_equalTo(self.houseLabel.mas_bottom);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-topMargin);
            make.height.mas_equalTo(self.categoryLabel.mas_height);
        }];

        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = @"报修时间:";
        [self setAttributesForLabel:self.timeLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseLabel.mas_left);
            make.top.mas_equalTo(self.categoryDetailLabel.mas_bottom);
        }];
    
        self.timeDetailLabel = [[UILabel alloc] init];
        self.timeDetailLabel.text = @"";
        [self setAttributesForLabel:self.timeDetailLabel];
        [self.contentView addSubview:self.timeDetailLabel];
        [self.timeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseDetailLabel.mas_left);
            make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        }];
        
        self.timerDetailLabel = [UILabel new];
        self.timerDetailLabel.textColor = [UIColor darkGrayColor];
        self.timerDetailLabel.font = FontSize(CONTENT_FONT-1);
        [self.contentView addSubview:self.timerDetailLabel];
        [self.timerDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeDetailLabel.mas_left);
            make.top.mas_equalTo(self.timeDetailLabel.mas_bottom);
            make.height.mas_equalTo(30);
        }];
        
        self.timerImage = [UIImageView new];
        [self.contentView addSubview:self.timerImage];
        self.timerImage.image = [UIImage imageNamed:@"daojishi"];
        [self.timerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timerDetailLabel.mas_centerY);
            make.centerX.mas_equalTo(self.timeLabel.mas_centerX);
            make.width.mas_equalTo(30.0);
            make.height.mas_equalTo(30.0);
        }];
        
        self.callNumberLabel = [[UILabel alloc] init];
        self.callNumberLabel.text = @"报修人电话:";
        self.callNumberLabel.textColor = [UIColor darkGrayColor];
        [self.callNumberLabel sizeToFit];
        self.callNumberLabel.numberOfLines = 1;
        self.callNumberLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.callNumberLabel.font = FontSize(CONTENT_FONT-3);
        [self.contentView addSubview:self.callNumberLabel];
        [self.callNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseLabel.mas_left);
            make.width.mas_equalTo(self.houseLabel.mas_width);
            make.top.mas_equalTo(self.timerDetailLabel.mas_bottom);
        }];
        
        self.callNumberDetailLabel = [[UILabel alloc] init];
        self.callNumberDetailLabel.text = @"";
        self.callNumberDetailLabel.textColor = [UIColor darkGrayColor];
        [self.callNumberDetailLabel sizeToFit];
        self.callNumberDetailLabel.numberOfLines = 1;
        self.callNumberDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.callNumberDetailLabel.font = FontSize(CONTENT_FONT-3);
        [self.contentView addSubview:self.callNumberDetailLabel];
        [self.callNumberDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseDetailLabel.mas_left);
            make.centerY.mas_equalTo(self.callNumberLabel.mas_centerY);
        }];

        UIImageView *head = [[UIImageView alloc] init];
        head.image = [UIImage imageNamed:@"records_虚线"];
        [self.contentView addSubview:head];
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(-1);
        }];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_箭头"]];
        arrow.alpha = 0.7;
        [self.contentView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(arrow.mas_height).multipliedBy(0.65);
        }];
    }
    return self;
    
}

- (void)setAttributesForLabel:(UILabel *)label{
    
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    label.numberOfLines = 1;
    label.font = FontSize(CONTENT_FONT);
    
}

- (void)loadDataFromTaskVO:(TaskVO *)task{
    _task = task;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(CONTENT_FONT-1),NSFontAttributeName, nil];
    CGRect rect = [[NSString stringWithFormat:@"报修类型:"] boundingRectWithSize:CGSizeMake(0, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    CGFloat topMargin = 10/667.0*My_ScreenH;
    CGFloat leftMargin = topMargin*0.5;
    CGFloat imageWidth = 50/667.0*My_ScreenH;
    CGFloat detailWidth = My_ScreenW-2*topMargin-(3*topMargin+leftMargin+imageWidth)-rect.size.width;
    
    if (task) {
        
        if ([task.owner_public isEqualToString:@"o"]) {
            self.leftImageView.image = [UIImage imageNamed:@"repairStatistics_业主报修"];
        }else{
            self.leftImageView.image = [UIImage imageNamed:@"repairStatistics_公共报修"];
        }
        
        NSMutableString *string = [[NSMutableString alloc] init];
        if(task.estate_name.length > 0){
            [string appendString:task.estate_name];
        }
        
        if (task.block.length > 0 && [task.block intValue] != 0){
            [string appendString:[NSString stringWithFormat:@"%@栋",task.block ]];
        }
        
        if (task.unit.length > 0 && [task.unit intValue] != 0){
            [string appendString:[NSString stringWithFormat:@"%@单元",task.unit ]];
        }
        if (task.layer && ![task.layer isEqualToString:@""] && [task.layer intValue] != 0){
            [string appendString:[NSString stringWithFormat:@"%@层",task.layer ]];
        }
        if (task.mph.length > 0 && [task.mph intValue] != 0){
            [string appendString:[NSString stringWithFormat:@"%@室",task.mph]];
        }

        self.houseDetailLabel.title = string;
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(CONTENT_FONT-1),NSFontAttributeName, nil];
        CGRect rect2 = [task.classes_str boundingRectWithSize:CGSizeMake(detailWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil];
        self.categoryDetailLabel.text = task.classes_str;
        [self.categoryDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(rect2.size.height);
        }];
        
        NSInteger time = [task.st_0_time integerValue];
        if (time == 0) {
            self.timeDetailLabel.text = @"";
        }else{
            self.timeDetailLabel.text = [NSString stringDateFromTimeInterval:time withFormat:nil];
        }
        
        self.callNumberDetailLabel.text = task.call_phone;

        if(task.kb.intValue == 3){
            [self orderData:YES st:task.st];
        }else{
            [self orderData:NO st:task.st];
        }
        
        [self layoutIfNeeded];
        
    }
    
}

- (void)orderData:(BOOL)isOrderData st:(NSString *)st{
    if (!isOrderData) {
        self.timerImage.hidden = YES;
        [self.timerDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        CGFloat rowHeight = 40.0;
        if ([st intValue] == 0) {
            self.timerImage.hidden = NO;
            [self.timerDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(rowHeight);
            }];
            //预约时间
            self.timeDetailLabel.text = [NSString stringDateFromTimeInterval:[self.task.order_ts integerValue] withFormat:nil];
            //倒计时
            //启动定时器
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.task.order_ts integerValue]];
            NSTimeInterval timeinteval = [date timeIntervalSinceNow];
            if (timeinteval <= 0) {
                self.timerDetailLabel.text = [NSString stringWithFormat:@"已超时 %@", [NSDate countDownStringFromTimeInterval:timeinteval]];
                self.timerDetailLabel.textColor = [UIColor redColor];
            }else{
                self.timerDetailLabel.text = [NSDate countDownStringFromTimeInterval:timeinteval];
                self.timerDetailLabel.textColor = [UIColor darkGrayColor];
            }
            if (self.timer) {
                [self.timer invalidate];
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runCircle:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            
        }else{
            self.timerImage.hidden = YES;
            [self.timerDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            //预约时间
            self.timeDetailLabel.text = [NSString stringDateFromTimeInterval:0 withFormat:nil];
        }
    }
    [self.contentView layoutIfNeeded];
}

- (void)runCircle:(NSTimer *)timer{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.task.order_ts integerValue]];
    NSTimeInterval timeinteval = [date timeIntervalSinceNow];
    if (timeinteval <= 0) {
        self.timerDetailLabel.text = [NSString stringWithFormat:@"已超时 %@", [NSDate countDownStringFromTimeInterval:timeinteval]];
        self.timerDetailLabel.textColor = [UIColor redColor];
    }else{
        self.timerDetailLabel.text = [NSDate countDownStringFromTimeInterval:timeinteval];
        self.timerDetailLabel.textColor = [UIColor darkGrayColor];
    }
    
}

@end
