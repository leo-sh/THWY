//
//  MBManager.m
//  snowonline
//
//  Created by 史秀泽 on 16/6/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "SVProgressHUD.h"
#import "UIImage+GIF.h"

@interface SVProgressHUD ()

@property BOOL isShow;
@property (strong, nonatomic) MBProgressHUD* hud;
@property UIWindow* window;

@property UIImageView* loadingView;
@property UIImageView* loadingImv;

@property UILabel* hintLabel;

@end

@implementation SVProgressHUD

+(instancetype)shareMBManager
{
    static SVProgressHUD* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SVProgressHUD alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.window = My_KeyWindow;
        self.hud = [[MBProgressHUD alloc]initWithView:self.window];
        [self.window addSubview:self.hud];
        [self hudInit];
    }
    return self;
}

-(void)hudInit
{
    [self.window bringSubviewToFront:self.hud];
    
    [self.loadingView removeFromSuperview];
    [self.loadingLabel removeFromSuperview];
    
    if (self.loadingLabel == nil) {
        self.loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        self.loadingLabel.backgroundColor = My_AlphaColor(25, 25, 25, 0.9);
        self.loadingLabel.layer.cornerRadius = 10;
        self.loadingLabel.clipsToBounds = YES;
        self.loadingLabel.numberOfLines = 0;
        self.loadingLabel.adjustsFontSizeToFitWidth = YES;
        self.loadingLabel.font = FontSize(CONTENT_FONT + 1);
        
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    self.loadingLabel.height = My_ScreenH/3;
    self.loadingLabel.width = My_ScreenW/3*2;
    
    if (self.loadingView == nil) {
        self.loadingView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220, 70)];
        self.loadingView.backgroundColor = [UIColor blackColor];
        
        self.loadingImv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.loadingView.height - 10, self.loadingView.height - 10)];
        self.loadingImv.backgroundColor = My_RandomColor;
        [self.loadingView addSubview:self.loadingImv];
        
        self.hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.loadingImv.right + 10, self.loadingImv.top, self.loadingView.width - self.loadingImv.right - 10, self.loadingImv.height)];
        self.hintLabel.numberOfLines = 0;
        self.hintLabel.textColor = [UIColor whiteColor];
        [self.loadingView addSubview:self.hintLabel];
    }
    
    self.hud.removeFromSuperViewOnHide = NO;
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = My_AlphaColor(0, 0, 0, 0.01);
    self.hud.bezelView.color = [UIColor clearColor];
    self.hud.bezelView.clipsToBounds = NO;
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.animationType = MBProgressHUDAnimationZoom;
    self.hud.minShowTime = 0;
    self.hud.label.text = @"";
    [self.hud setOffset:CGPointMake(0, 0)];
}

#pragma mark -Public
+(void)showErrorWithStatus:(NSString*)title
{
    [[self shareMBManager] setIsShow:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shareMBManager] hudHideWithText:title];
    });
}

+(void)hudHideWithSuccess:(NSString*)title
{
    [[self shareMBManager] setIsShow:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shareMBManager] hudHideWithSuccess:title];
    });
}

+(void)showWithStatus:(NSString*)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shareMBManager] showLoadingWithTitle:title];
    });
}

+(void)showSubTitle:(NSString*)subTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shareMBManager] showSubTitle:subTitle];
    });
}

+(void)dismiss
{
    [[self shareMBManager] setIsShow:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self shareMBManager] hud] hideAnimated:YES];
    });
}

#pragma mark -Private
-(void)showSubTitle:(NSString*)subTitle
{
    if (!self.isShow) {
        self.isShow = YES;
        [self.hud hideAnimated:NO];
    }
    [self hudInit];
    
    self.loadingLabel.text = [self.loadingLabel.text componentsSeparatedByString:@"\n"].firstObject;
    self.loadingLabel.width = [[NSString stringWithFormat:@"%@\n%@",self.loadingLabel.text,subTitle] sizeWithFont:self.loadingLabel.font maxSize:self.loadingLabel.size].width + 45;
    self.loadingLabel.height = [[NSString stringWithFormat:@"%@\n%@",self.loadingLabel.text,subTitle] sizeWithFont:self.loadingLabel.font maxSize:self.loadingLabel.size].height + 25;
    self.loadingLabel.center = CGPointMake(20, 20);
    
    self.loadingLabel.text = [NSString stringWithFormat:@"%@\n%@",self.loadingLabel.text,subTitle];
    self.loadingLabel.layer.cornerRadius = self.loadingLabel.height/2;
    
    [self.hud.bezelView addSubview:self.loadingLabel];
    [self.hud.bezelView bringSubviewToFront:self.loadingLabel];
    
    [self.hud showAnimated:NO];
}

-(void)hudHideWithText:(NSString*)title
{
    [self hudInit];
    self.hud.minShowTime = 1;
    [self.hud showAnimated:YES];
    
    self.loadingLabel.width = [title sizeWithFont:self.loadingLabel.font maxSize:self.loadingLabel.size].width + 45;
    self.loadingLabel.height = [title sizeWithFont:self.loadingLabel.font maxSize:self.loadingLabel.size].height + 25;
    self.loadingLabel.center = CGPointMake(20, 20);
    
    self.loadingLabel.text = title;
    self.loadingLabel.layer.cornerRadius = self.loadingLabel.height/2;
    
    [self.hud setOffset:CGPointMake(0, My_ScreenH - self.loadingLabel.height - 100)];
    
    [self.hud.bezelView addSubview:self.loadingLabel];
    [self.hud.bezelView bringSubviewToFront:self.loadingLabel];
    
    [self.hud hideAnimated:YES afterDelay:1.5];
}

-(void)hudHideWithSuccess:(NSString*)title
{
    [self hudHideWithText:title];
}

-(void)showLoadingWithTitle:(NSString*)title
{
    if (!self.isShow) {
        self.isShow = YES;
        [self.hud showAnimated:YES];
    }
    [self hudInit];
    
    self.loadingLabel.width = [title sizeWithFont:self.loadingLabel.font maxSize:self.loadingLabel.size].width + 45;
    self.loadingLabel.height = [title sizeWithFont:self.loadingLabel.font maxSize:self.loadingLabel.size].height + 25;
    self.loadingLabel.center = CGPointMake(20, 20);
    
    self.loadingLabel.text = title;
    self.loadingLabel.layer.cornerRadius = self.loadingLabel.height/2;
    
    [self.hud.bezelView addSubview:self.loadingLabel];
    [self.hud.bezelView bringSubviewToFront:self.loadingLabel];
}
@end
