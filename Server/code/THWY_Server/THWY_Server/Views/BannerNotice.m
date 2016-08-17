//
//  BannerNotice.m
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BannerNotice.h"
#import <AudioToolbox/AudioToolbox.h>
#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)

@implementation BannerNotice

+(id)bannerWith:(UIImage *)bannerImage bannerName:(NSString *)bannerName bannerContent:(NSString *)bannerContent
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    UIView *viewHidden = [[UIView alloc] init];
    viewHidden = [[UIView alloc] initWithFrame:CGRectMake(0, -70, SCREEN_WIDTH, 70)];
    viewHidden.backgroundColor = [UIColor blackColor];
    viewHidden.alpha = 0.85;
    
//    UIButton * bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bannerBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
//    [bannerBtn setTitle:@"" forState:UIControlStateNormal];
//    [bannerBtn addTarget:self action:@selector(btnSelector:) forControlEvents:UIControlEventTouchUpInside];
//    [viewHidden addSubview:bannerBtn];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 20, 20)];
    [imageView setImage:bannerImage];
    [viewHidden addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(38, 16, 39, 16);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = font;
    nameLabel.text = bannerName;
    [viewHidden addSubview:nameLabel];
    
    
    UILabel *newLabel = [[UILabel alloc] init];
    newLabel.frame = CGRectMake(83, 15, 24, 18);
    newLabel.textColor = [UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
    newLabel.font = [UIFont fontWithName:@"Arial" size:11];
    newLabel.text = @"现在";
    [viewHidden addSubview:newLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(30, 37, SCREEN_WIDTH-70, 29);
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = font;
    contentLabel.text = bannerContent;
    NSLog(@"===========%@",bannerContent);
    [viewHidden addSubview:contentLabel];
    
//    UILabel *ContentLabel = [[UILabel alloc] init];
//    [ContentLabel setNumberOfLines:0];
//    ContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    ContentLabel.textColor = [UIColor whiteColor];
//    ContentLabel.font = font;
//    ContentLabel.text = bannerContent;
//    CGSize size = CGSizeMake(274, MAXFLOAT);
////    CGSize labelsize = [bannerContent sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
//    
//    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:bannerContent attributes:@{NSFontAttributeName: font}];
//    CGRect rect = [attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    CGSize labelsize = rect.size;
//    
//    [ContentLabel setFrame:CGRectMake(30, 31,SCREEN_WIDTH-70, labelsize.height)];
//    [viewHidden addSubview:ContentLabel];
    
//    viewHidden = [[UIView alloc] initWithFrame:CGRectMake(0, -(labelsize.height+50), SCREEN_WIDTH, labelsize.height+50)];
    
    
////    viewHight = labelsize.height+50;
    
    [UIView animateWithDuration:0.5 animations:^{
        viewHidden.transform = CGAffineTransformMakeTranslation(0, 70);
    }];
    AudioServicesPlaySystemSound(1007);
//    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.5 animations:^{
            viewHidden.transform = CGAffineTransformMakeTranslation(0, -70);
        }];
    });
    
    return viewHidden;
    
}


@end
