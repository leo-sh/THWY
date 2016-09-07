//
//  RecordImageCell.m
//  THWY_Client
//
//  Created by wei on 16/8/4.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecordImageCell.h"
#import "ZLPhoto.h"
#import "RepairDetailController.h"

@interface RecordImageCell ()

@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UIImageView *picImage;

@property RepairVO* repair;

@end

@implementation RecordImageCell

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
        self.leftLabel.text = @"图片:";
        [self setLabelAttributes:self.leftLabel];
        
        UIImage *image = [UIImage imageNamed:@"bannerload"];
        CGSize size = image.size;
        self.picImage = [[UIImageView alloc] initWithImage:image];
        self.picImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.picImage addTarget:self action:@selector(showImage)];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.picImage];
        
        
        CGFloat topMargin = 8.0/375*My_ScreenW;
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(topMargin);
            make.top.mas_equalTo(self.contentView.mas_top).offset(topMargin);
            make.height.mas_equalTo(20);
        }];
        
        [self.picImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-topMargin);
            make.top.mas_equalTo(self.leftLabel.mas_bottom).offset(topMargin);
            make.height.mas_equalTo(size.height);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-topMargin);
        }];
        
    }
    return self;
}

- (void)setLabelAttributes:(UILabel *)label{
    
    label.numberOfLines = 0;
    label.font = FontSize(CONTENT_FONT);
    label.textColor = [UIColor darkGrayColor];
//    [label sizeToFit];
    
}

- (void)loadDataWithModel:(RepairVO *)model{
    self.repair = model;
    
    if ([self.picImage.image isEqual:[UIImage imageNamed:@"bannerload"]]) {
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.pic] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            CGFloat topMargin = 8.0/375*My_ScreenW;
            
            self.picImage.image = image;
            CGSize size = image.size;
            self.imageHeight = (self.tableView.width-2*topMargin)*size.height/size.width;
            
            [(RepairDetailController *)self.vc setImageHeight:self.imageHeight];
            [self.picImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo((self.tableView.width-2*topMargin)*size.height/size.width);
            }];
            [self layoutIfNeeded];
            if (cacheType == 0) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:4]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }

        }];
        
    }
    
}


-(void)showImage
{
    if (self.repair) {
        
        NSMutableArray* imageArr = [[NSMutableArray alloc]init];
        ZLPhotoPickerBrowserPhoto* photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:self.repair.pic];
        [imageArr addObject:photo];
        
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        pickerBrowser.editing = NO;
        pickerBrowser.canLongPress = YES;
        pickerBrowser.photos = imageArr;
        // 当前选中的值
        pickerBrowser.currentIndex = 0;
        // 展示控制器
        [pickerBrowser showPickerVc:self.vc];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
