//
//  PaigongCatogerysCell.m
//  THWY_Server
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "PaigongCatogerysCell.h"

@interface PaigongCatogerysCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn_kaidan;
@property (weak, nonatomic) IBOutlet UIButton *btn_budan;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *unselectedImage;

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
    
}

- (IBAction)kaidanOnclick:(UIButton *)sender {
    
    [self.btn_kaidan setImage:self.selectedImage forState:UIControlStateNormal];
    [self.btn_budan setImage:self.unselectedImage forState:UIControlStateNormal];
    self.flag = 1;
    
}

- (IBAction)budanOnclick:(UIButton *)sender {
    
    [self.btn_kaidan setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.btn_budan setImage:self.selectedImage forState:UIControlStateNormal];
    self.flag = 2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
