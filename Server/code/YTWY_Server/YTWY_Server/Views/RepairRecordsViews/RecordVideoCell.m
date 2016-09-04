//
//  RecordVideoCell.m
//  YTWY_Client
//
//  Created by wei on 16/8/17.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "RecordVideoCell.h"
#import "KRVideoPlayerController.h"

@interface RecordVideoCell ()

@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UIButton *videoBtn;
@property (copy, nonatomic) NSString *videoPath;

@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end

@implementation RecordVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        
        self.leftLabel = [[UILabel alloc] init];
        self.leftLabel.text = @"视频:";
        [self setLabelAttributes:self.leftLabel];
        
        self.videoBtn = [[UIButton alloc] init];
        [self.videoBtn setImage:[UIImage imageNamed:@"repaire_video"] forState:UIControlStateNormal];
        [self.videoBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.videoBtn];
        
        CGFloat topMargin = 8.0/375*My_ScreenW;
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(topMargin);
            make.top.mas_equalTo(self.contentView.mas_top).offset(topMargin);
            make.height.mas_equalTo(20);
        }];
        
        [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(topMargin);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-topMargin);
            make.width.mas_equalTo(self.videoBtn.mas_height);
        }];
        
    }
    return self;
}

- (void)setLabelAttributes:(UILabel *)label{
    
    label.numberOfLines = 0;
    label.font = FontSize(CONTENT_FONT);
    label.textColor = [UIColor darkGrayColor];
    [label sizeToFit];
    
}

- (void)loadDataWithModel:(RepairVO *)model{
    self.videoPath = model.vdo;
}

- (void)play{
    
    NSURL *url = [NSURL URLWithString:self.videoPath];
    [self playVideoWithURL:url];

    
}

- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController.videoControl.fullScreenButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    
    // Configure the view for the selected state
}

@end
