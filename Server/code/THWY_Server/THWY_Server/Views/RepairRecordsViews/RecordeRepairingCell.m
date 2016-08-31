//
//  RecordeRepeiringCell.m
//  THWY_Client
//
//  Created by wei on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecordeRepairingCell.h"
#import "RepairVO.h"
#import "RepairDetailController.h"

#define CENTERY(i) 27 + (50 + 0.5) * i
#define LINECENTERY(i)  2 + 50 * i
@interface RecordeRepairingCell ()

@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) RepairVO *model;

@property (strong, nonatomic) UIImageView *caiTiaoImage;
@property (strong, nonatomic) UIImageView *paiGongNumber;
@property (strong, nonatomic) UILabel *paiGongLabel;
@property (strong, nonatomic) UIButton *detail;

@property (strong, nonatomic) UILabel *line;

@property (strong, nonatomic) UILabel *houseSource;
@property (strong, nonatomic) UILabel *houseSourceLabel;

@property (strong, nonatomic) UILabel *repairCatogery;
@property (strong, nonatomic) UILabel *repairCatogeryLabel;

@property (strong, nonatomic) UILabel *line2;

@property (strong, nonatomic) UILabel *repairDesc;
@property (strong, nonatomic) UILabel *repairDescLabel;

@property (strong, nonatomic) UILabel *line3;

@property (strong, nonatomic) UILabel *repairTime;
@property (strong, nonatomic) UILabel *repairTimeLabel;

@property (strong, nonatomic) UILabel *line4;

@property (strong, nonatomic) UILabel *cellPhone;
@property (strong, nonatomic) UILabel *cellPhoneLabel;

@property (strong, nonatomic) UIButton *callBtn;

@property (strong, nonatomic) UIWebView *phoneCallWebView;

@property (strong, nonatomic) UILabel *line5;

@end

@implementation RecordeRepairingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;      // 让cell的y值增加5(根据自己需要分割线的高度来进行调整)
    frame.size.height -= 5;   // 让cell的高度减5
    [super setFrame:frame];   // 别忘了重写父类方法
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat topMagrin = 5.0/375*My_ScreenW;
        
        self.caiTiaoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 2)];
        self.caiTiaoImage.image = [UIImage imageNamed:@"records_彩条"];
        [self.contentView addSubview:self.caiTiaoImage];
        [self.caiTiaoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
        }];

        self.paiGongNumber = [[UIImageView alloc] init];
        [self.contentView addSubview:self.paiGongNumber];
        self.paiGongLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.paiGongLabel];
        self.numberLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.numberLabel];
        
        
        self.paiGongNumber.image = [UIImage imageNamed:@"records_派工单号"];
        [self.paiGongNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(topMagrin);
            make.width.mas_equalTo(self.paiGongNumber.mas_height);
            make.height.mas_equalTo(18);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(CENTERY(0));
        }];
        
        self.paiGongLabel.text = @"派工单号: ";
        [self setLabelAttributes:self.paiGongLabel with:0];
        [self.paiGongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.paiGongNumber.mas_centerY);
            make.left.mas_equalTo(self.paiGongNumber.mas_right).offset(topMagrin);
        }];
        
        self.numberLabel.text = @"";
        [self setLabelAttributes:self.numberLabel with:0];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.paiGongLabel.mas_centerY);
            make.left.mas_equalTo(self.paiGongLabel.mas_right).offset(10.0/375*My_ScreenW);
        }];
        
        self.detail = [[UIButton alloc] init];
        [self.detail setImage:[UIImage scaleImage:[UIImage imageNamed:@"icon_orders_open"]  toScale:0.5] forState:UIControlStateNormal];
        [self.detail addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.detail];
        [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-topMagrin);
            make.width.mas_equalTo(self.detail.mas_height);
            make.height.mas_equalTo(40.0);
            make.centerY.mas_equalTo(self.numberLabel.mas_centerY);
        }];
        
        self.line = [[UILabel alloc] init];
        [self.contentView addSubview:self.line];
        [self.line setBackgroundColor:My_LineColor];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(LINECENTERY(1));
        }];

        
        self.houseSourceLabel = [[UILabel alloc] init];
        self.houseSource = [[UILabel alloc] init];
        [self.contentView addSubview:self.houseSourceLabel];
        [self.contentView addSubview:self.houseSource];
        
        self.houseSource.text = @"报修房源: ";
        [self setLabelAttributes:self.houseSource with:0];
        
        [self.houseSource mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.paiGongNumber.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(CENTERY(1));
        }];
        
        [self setLabelAttributes:self.houseSourceLabel with:0];
        [self.houseSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.houseSource.mas_centerY);
            make.left.mas_equalTo(self.houseSource.mas_right);
        }];
        
        
        self.repairCatogery = [[UILabel alloc] init];
        self.repairCatogery.text = @"报修类别: ";
        [self setLabelAttributes:self.repairCatogery with:0];
        [self.contentView addSubview:self.repairCatogery];
        [self.repairCatogery mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseSource.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(CENTERY(2));
            make.width.mas_equalTo(self.houseSource.mas_width);
        }];
//适配版
//        [self.repairCatogeryLabel setNumberOfLines:0];
//        self.repairCatogeryLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:My_RegularFontName size:16.0],NSFontAttributeName, nil];
//        CGRect rect = [self.repairCatogeryLabel.text boundingRectWithSize:CGSizeMake(300.0/375*My_ScreenW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//
//        [self setLabelAttributes:self.repairCatogeryLabel with:-1];
//        [self.repairCatogeryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.repairCatogery.mas_left);
//            make.top.mas_equalTo(self.repairCatogery.mas_bottom).offset(topMagrin);
//            make.width.mas_equalTo(rect.size.width);
//            make.height.mas_equalTo(rect.size.height);
//
//        }];
//未适配版
        self.repairCatogeryLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.repairCatogeryLabel];
        [self setLabelAttributes:self.repairCatogeryLabel with:0];
        self.repairCatogeryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.repairCatogeryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.repairCatogery.mas_right);
            make.centerY.mas_equalTo(self.repairCatogery.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-topMagrin);
        }];
        
        self.line2 = [[UILabel alloc] init];
        [self.contentView addSubview:self.line2];
        [self.line2 setBackgroundColor:My_LineColor];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(LINECENTERY(2));
        }];

        self.repairDesc = [[UILabel alloc] init];
        self.repairDesc.text = @"报修描述: ";
        self.repairDescLabel = [[UILabel alloc] init];
        [self setLabelAttributes:self.repairDesc with:0];
        [self.contentView addSubview:self.repairDesc];
        [self.contentView addSubview:self.repairDescLabel];
        
        [self.repairDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseSource.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(CENTERY(3));
            make.width.mas_equalTo(self.houseSource.mas_width);
        }];
        
//        适配版
//        [self setLabelAttributes:self.repairDescLabel with:-1];
//        [self.repairDescLabel setNumberOfLines:0];
//        self.repairDescLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:My_RegularFontName size:16.0],NSFontAttributeName, nil];
//        CGRect rect2 = [self.repairDescLabel.text boundingRectWithSize:CGSizeMake(300.0/375*My_ScreenW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//        [self.repairDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.houseSource.mas_left);
//            make.top.mas_equalTo(self.repairDesc.mas_bottom).offset(0);
//            make.width.mas_equalTo(rect2.size.width);
//            make.height.mas_equalTo(rect2.size.height);
//        }];
//未适配版
        [self setLabelAttributes:self.repairDescLabel with:0];
        self.repairDescLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.repairDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.repairDesc.mas_right);
            make.centerY.mas_equalTo(self.repairDesc.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-topMagrin);
        }];
        
   
        self.callBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.callBtn];
        
        self.line3 = [[UILabel alloc] init];
        [self.contentView addSubview:self.line3];
        [self.line3 setBackgroundColor:My_LineColor];
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(LINECENTERY(3));
        }];
        
        self.repairTime = [[UILabel alloc] init];
        self.repairTime.text = @"报修时间: ";
        self.repairTimeLabel = [[UILabel alloc] init];
        [self setLabelAttributes:self.repairTime with:0];
        [self setLabelAttributes:self.repairTimeLabel with:0];
        [self.contentView addSubview:self.repairTime];
        [self.contentView addSubview:self.repairTimeLabel];
        
        [self.repairTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.repairDesc.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(CENTERY(4));
        }];
        
        [self.repairTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.repairTime.mas_right);
            make.centerY.mas_equalTo(self.repairTime.mas_centerY);
        }];
        
        self.line4 = [[UILabel alloc] init];
        [self.contentView addSubview:self.line4];
        [self.line4 setBackgroundColor:My_LineColor];
        [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(LINECENTERY(4));
        }];
        
        self.cellPhone = [[UILabel alloc] init];
        [self.contentView addSubview:self.cellPhone];
        
        self.cellPhone.text = @"报修人电话: ";
        [self setLabelAttributes:self.cellPhone with:0];
        [self.cellPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.houseSource.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(CENTERY(5));
        }];
        
        self.cellPhoneLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.cellPhoneLabel];
        [self setLabelAttributes:self.cellPhoneLabel with:0];
        [self.cellPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cellPhone.mas_right);
            make.centerY.mas_equalTo(self.cellPhone.mas_centerY);
        }];
        
        [self.callBtn setImage:[UIImage scaleImage:[UIImage imageNamed:@"records_call"]  toScale:1] forState:UIControlStateNormal];
        [self.callBtn addTarget:self action:@selector(callNumber) forControlEvents:UIControlEventTouchUpInside];
        [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.detail.mas_centerX);
            make.centerY.mas_equalTo(self.cellPhone.mas_centerY);
            make.height.mas_equalTo(self.detail.mas_height).multipliedBy(0.7);
            make.width.mas_equalTo(self.callBtn.mas_height).multipliedBy(0.75);
        }];
        
        self.line5 = [[UILabel alloc] init];
        [self.contentView addSubview:self.line5];
        [self.line5 setBackgroundColor:My_LineColor];
        [self.line5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_top).offset(LINECENTERY(5));
        }];
        
        
    }
    return self;

}

- (void)setLabelAttributes:(UILabel *)label with:(NSInteger)big{
    
    label.numberOfLines = 1;
    label.font = FontSize(CONTENT_FONT+big);
    label.textColor = [UIColor darkGrayColor];

//    [label sizeToFit];

}

- (void)loadDataFromModel:(RepairVO *)repaireVO{
    
    self.model = repaireVO;
    self.numberLabel.text = [self createNumberText:repaireVO.Id];

    NSMutableString *string = [[NSMutableString alloc] init];
    if(self.flag == 1){
        if(repaireVO.estate.length > 0){
            [string appendString:repaireVO.estate];
        }
    }else{
        
        if(repaireVO.estate_name.length > 0){
            [string appendString:repaireVO.estate_name];
        }
    }
    if (repaireVO.block.length > 0 && [repaireVO.block intValue] != 0){
        [string appendString:[NSString stringWithFormat:@"%@栋",repaireVO.block ]];
    }
    if (repaireVO.unit.length > 0 && [repaireVO.unit intValue] != 0){
        [string appendString:[NSString stringWithFormat:@"%@单元",repaireVO.unit ]];
    }
    if (repaireVO.layer && ![repaireVO.layer isEqualToString:@""] && [repaireVO.layer intValue] != 0){
        [string appendString:[NSString stringWithFormat:@"%@层",repaireVO.layer ]];
    }
    if (repaireVO.mph.length > 0 && [repaireVO.mph intValue] != 0){
        [string appendString:[NSString stringWithFormat:@"%@室",repaireVO.mph]];
    }
    self.houseSourceLabel.text = string;
    self.repairCatogeryLabel.text = repaireVO.classes_str;
    self.repairDescLabel.text = repaireVO.detail;
    self.repairTimeLabel.text = [NSString stringDateFromTimeInterval:[repaireVO.st_0_time integerValue] withFormat:nil];
    self.cellPhoneLabel.text = repaireVO.call_phone;
    
    if (repaireVO.kb.intValue == 2){
        [self.detail setImage:[UIImage scaleImage:[UIImage imageNamed:@"icon_orders_add"]  toScale:0.5]forState:UIControlStateNormal];
    }else{
        [self.detail setImage:[UIImage scaleImage:[UIImage imageNamed:@"icon_orders_open"]  toScale:0.5]forState:UIControlStateNormal];
    }
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:My_RegularFontName size:16.0],NSFontAttributeName, nil];
//    CGRect rect = [self.repairCatogeryLabel.text boundingRectWithSize:CGSizeMake(320/375.0*My_ScreenW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    
//    [self.repairCatogeryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.width.mas_equalTo(rect.size.width);
//        make.height.mas_equalTo(rect.size.height);
//        
//    }];
//
//    [self layoutIfNeeded];
//
//    CGRect rect2 = [self.repairDescLabel.text boundingRectWithSize:CGSizeMake(320/375.0*My_ScreenW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    [self.repairDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(rect2.size.width);
//        make.height.mas_equalTo(rect2.size.height);
//    }];
//    
//    [self layoutIfNeeded];

}

- (void)callNumber{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.cellPhoneLabel.text message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phoneNum = self.cellPhoneLabel.text;// 电话号码
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
        [[UIApplication sharedApplication] openURL:phoneURL];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    
    [self.vc presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)showDetail{
    
    RepairDetailController *detail = [[RepairDetailController alloc] init];
    detail.repairVOId = self.model.Id;
    detail.type = self.flag;
    detail.displayType = 1;
    [self.vc.navigationController pushViewController:detail animated:YES];
    
}

- (NSString *)createNumberText:(NSString *)idString{
    if (self.flag == 1) {
        return [NSString stringWithFormat:@"WX%@%@", [NSDate currentYear], [NSString stringWithFormat:@"%06d", [idString intValue]]];
    }else{
        return [NSString stringWithFormat:@"GGWX%@%@", [NSDate currentYear], [NSString stringWithFormat:@"%06d", [idString intValue]]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
