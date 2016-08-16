//
//  PayTableViewCell.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PayTableViewCell.h"
#import "Masonry.h"
#import "FeeVO.h"
#import "PrefixHeader.pch"
@interface PayTableViewCell()
@property UILabel *estateLabel;
@property UILabel *houseOwnerLabel;
@property UILabel *AddressLabel;
@property UILabel *timeLabel;
@property UILabel *stateLabel;
@property UILabel *payTypeLabel;
@property UILabel *priceLabel;
@property UIImageView *icon;
@end
@implementation PayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.estateLabel = [[UILabel alloc]init];
        self.houseOwnerLabel = [[UILabel alloc]init];
        self.AddressLabel = [[UILabel alloc]init];
        self.timeLabel = [[UILabel alloc]init];
        self.icon = [[UIImageView alloc]init];
        self.stateLabel = [[UILabel alloc]init];
        self.payTypeLabel = [[UILabel alloc]init];
        self.priceLabel = [[UILabel alloc]init];
        
        [self.contentView addSubview:self.estateLabel];
        [self.contentView addSubview:self.houseOwnerLabel];
        [self.contentView addSubview:self.AddressLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.stateLabel];
        [self.contentView addSubview:self.payTypeLabel];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)updateFrame:(CGSize)cellsize
{
    CGFloat top = cellsize.height * 0.1;
    
    NSLog(@"高度---------------%f",cellsize.height);
    
    CGFloat image_H_W = cellsize.height * 0.6;
    CGFloat image_L = cellsize.height * 0.1;
    
    CGFloat estateAndOwner_H = cellsize.height * 0.2;
    CGFloat estate_L = image_L;
    CGFloat estate_W = image_H_W + 10;
    
    CGFloat left = image_L;
    CGFloat center_W = (cellsize.width - image_H_W - left -image_L) * 0.6;
    CGFloat right_W = (cellsize.width - image_H_W - left -image_L) * 0.35;
    CGFloat Height = image_H_W/3;
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(image_L);
        make.size.mas_equalTo(CGSizeMake(image_H_W, image_H_W));
    }];
    
    [self.AddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.equalTo(self.icon.mas_right).with.offset(left);
        make.size.mas_equalTo(CGSizeMake(center_W, Height));
    }];
    
    [self.houseOwnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.AddressLabel.mas_centerY);
        make.left.equalTo(self.AddressLabel.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(right_W, Height));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.AddressLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.icon.mas_right).with.offset(left);
        make.size.mas_equalTo(CGSizeMake(center_W + 10, Height));
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.left.equalTo(self.timeLabel.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(right_W - 10, Height));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.icon.mas_right).with.offset(left);
        make.size.mas_equalTo(CGSizeMake(center_W - 40, Height));
    }];
    
    [self.estateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).with.offset(0);
        make.left.mas_equalTo(estate_L);
        make.size.mas_equalTo(CGSizeMake(estate_W, estateAndOwner_H));
    }];
    
    [self.payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.mas_centerY);
        make.left.equalTo(self.priceLabel.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(right_W + 40, Height));
    }];
    
    self.icon.layer.borderWidth = 1;
    self.icon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.icon.clipsToBounds = YES;
    self.icon.layer.cornerRadius = image_H_W/2;
    
    self.estateLabel.font = FontSize(CONTENT_FONT);
    self.houseOwnerLabel.font = self.estateLabel.font;
    
    self.AddressLabel.font = self.estateLabel.font;
    self.AddressLabel.textColor = [UIColor lightGrayColor];
    
    self.payTypeLabel.font = self.estateLabel.font;
    self.payTypeLabel.textColor = [UIColor lightGrayColor];
    self.priceLabel.font = self.estateLabel.font;
    self.stateLabel.font = self.estateLabel.font;
    self.stateLabel.textColor = [UIColor lightGrayColor];

    
    self.houseOwnerLabel.textAlignment = NSTextAlignmentRight;
    self.payTypeLabel.textAlignment = NSTextAlignmentRight;
    self.stateLabel.textAlignment = NSTextAlignmentRight;
    
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    
    
    
}

- (void)giveData:(FeeVO *)FeeVO
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:FeeVO.estate_pic]];
    self.estateLabel.text = FeeVO.estate_name;
    self.houseOwnerLabel.text = FeeVO.real_name;
    self.AddressLabel.text = [NSString stringWithFormat:@""];
    NSString *beginT = [NSString stringDateFromTimeInterval:[FeeVO.begin_time intValue] withFormat:@"YYYY/MM/dd"];
    NSString *endT = [NSString stringDateFromTimeInterval:[FeeVO.end_time intValue] withFormat:@"YYYY/MM/dd"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@~%@",beginT,endT];
    self.payTypeLabel.text = FeeVO.cls_name;
    self.priceLabel.text = [NSString stringConvertFloatString:FeeVO.how_much addEndString:@"元"];
    self.AddressLabel.text = [NSString stringWithFormat:@"%@栋%@单元%@室",FeeVO.block,FeeVO.unit,FeeVO.mph];
    
    switch (FeeVO.st) {
        case All:
        {
            self.stateLabel.text = @"选择状态";
        }
            break;
        case NonPayment:
        {
            self.stateLabel.text = @"未缴";
        }
            break;
        case Part:
        {
            self.stateLabel.text = @"未缴齐";
        }
            break;
        case Paid:
        {
            self.stateLabel.text = @"已缴齐";
        }
            break;
        case Refund:
        {
            self.stateLabel.text = @"已经退款";
        }
            break;
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
