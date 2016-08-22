//
//  RecordsDetailCell.m
//  THWY_Client
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecordsDetailCell.h"

@interface RecordsDetailCell ()

@property (strong, nonatomic) NSArray *labelNames;

@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *line;

@end

@implementation RecordsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        self.leftLabel = [[UILabel alloc] init];
        self.detailLabel = [[UILabel alloc] init];
        [self setLabelAttributes:self.leftLabel with:0];
        [self setLabelAttributes:self.detailLabel with:-1];
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.line];
        
        CGFloat topMargin = 8.0/375*My_ScreenW;
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(topMargin);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftLabel.mas_right).offset(topMargin);
            make.centerY.mas_equalTo(self.leftLabel.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.height.mas_equalTo(0.4);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
    }
    return self;
}

- (void)loadDataWithModel:(RepairVO *)model indexpath:(NSIndexPath *)indexpath{
    self.leftLabel.text = self.labelNames[indexpath.section][indexpath.row];
    switch (indexpath.section) {
        case 0:{
            switch (indexpath.row) {
                case 0:{
                    self.detailLabel.text = model.real_name;
                    break;
                }
                case 1:{
//                    self.detailLabel.text = model.Id;
                    if (self.type == 1) {
                        self.detailLabel.text = [NSString stringWithFormat:@"WX%@%@", [NSDate currentYear], [NSString stringWithFormat:@"%06d", [model.Id intValue]]];
                    }else{
                        self.detailLabel.text = [NSString stringWithFormat:@"GGWX%@%@", [NSDate currentYear], [NSString stringWithFormat:@"%06d", [model.Id intValue]]];
                    }
                    break;
                }
                case 2:{
                    self.detailLabel.text = @"";
                    NSMutableString *string = [[NSMutableString alloc] init];
                    if(self.type == 1){
                        if(model.estate.length > 0){
                            [string appendString:model.estate];
                        }

                    }else{
                        
                        if(model.estate_name.length > 0){
                            [string appendString:model.estate_name];
                        }
                    }
                    if (model.block.length > 0 && [model.block intValue] > 0){
                        [string appendString:[NSString stringWithFormat:@"%@栋",model.block ]];
                    }
                    if (model.unit.length > 0 && [model.unit intValue] > 0){
                        [string appendString:[NSString stringWithFormat:@"%@单元",model.unit ]];
                    }
                    if (model.layer && ![model.layer isEqualToString:@""] && [model.layer intValue] != 0){
                        [string appendString:[NSString stringWithFormat:@"%@层",model.layer ]];
                    }
                    if (model.mph.length > 0 && [model.mph intValue] > 0){
                        [string appendString:[NSString stringWithFormat:@"%@室",model.mph]];
                    }
                    self.detailLabel.text = string;
                    break;
                }
                case 3:{
                    self.detailLabel.text = model.call_phone;
                    [self.line setHidden:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (indexpath.row) {
                case 0:{
                    self.detailLabel.text = [NSString stringDateFromTimeInterval:[model.st_0_time intValue] withFormat:nil];
                    break;
                }
                case 1:{
                    if ( model.classes_str && ![model.classes_str isEqualToString:@""]) {
                        self.detailLabel.numberOfLines = 0;
                        self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        [self.detailLabel sizeToFit];
                        self.detailLabel.text = model.classes_str;
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(CONTENT_FONT-1),NSFontAttributeName, nil];
                        CGRect rect = [model.classes_str boundingRectWithSize:CGSizeMake(self.contentView.width*0.7, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
                        
                        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_equalTo(rect.size.height);
                            make.width.mas_equalTo(rect.size.width);
                        }];
                        [self layoutIfNeeded];                        
                    }
//                    CGFloat topMargin = 8.0/375*My_ScreenW;
                    break;
                }
                case 2:{
                    self.detailLabel.text = model.detail;
                    [self.line setHidden:YES];
                    break;
                }
                default:
                    break;
            }

            break;
        }
        case 2:{
            switch (indexpath.row) {
                case 0:{
                    self.detailLabel.text = model.repair_task.firstObject.real_name;
                    break;
                }
                case 1:{
                    NSInteger time = [model._st integerValue];
                    if (time == 0) {
                        self.detailLabel.text = @"";
                    }else{
                        self.detailLabel.text = model.repair_task.firstObject.cellphone;
                    }
//                    self.detailLabel.text = model._st;
                    [self.line setHidden:YES];
                    break;
                }
                default:
                    break;
            }

            break;
        }
        case 3:{
            switch (indexpath.row) {
                case 0:{
                    NSInteger time = [model.st_0_time integerValue];
                    if (time == 0) {
                        self.detailLabel.text = @"";
                    }else{
                        self.detailLabel.text = [NSString stringDateFromTimeInterval:time withFormat:nil];
                    }
                    break;
                }
                case 1:{
                    NSInteger time = [model.st_2_time integerValue];
                    if (time == 0) {
                        self.detailLabel.text = @"";
                    }else{
                        self.detailLabel.text = [NSString stringDateFromTimeInterval:time withFormat:nil];
                    }
                    break;
                }
                case 2:{
                    NSInteger time = [model.st_3_time integerValue];
                    if (time == 0) {
                        self.detailLabel.text = @"";
                    }else{
                        self.detailLabel.text = [NSString stringDateFromTimeInterval:time withFormat:nil];
                    }
                    self.line.hidden = YES;
                    break;
                }
  
                default:
                    break;
            }

            break;
        }

        default:
            self.line.hidden = YES;
            break;
    }
    
}

- (void)setLabelAttributes:(UILabel *)label with:(NSInteger)big{
    
    label.numberOfLines = 0;
    label.font = FontSize(CONTENT_FONT+big);
    label.textColor = [UIColor darkGrayColor];
    //    [label sizeToFit];
    
}

- (NSArray *)labelNames{
    
    if (!_labelNames) {
        _labelNames = @[@[@"报修人姓名:", @"派工单号:", @"房源信息:", @"报修人电话:"],
                        @[@"报修时间:", @"报修类别:", @"报修描述:"],
                        @[@"维修人:", @"维修人员电话:"],
                        @[@"派工时间:", @"完工时间:", @"回访时间:"]];
    }
    return _labelNames;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
