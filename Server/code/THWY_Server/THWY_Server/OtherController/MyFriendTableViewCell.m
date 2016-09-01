//
//  MyFriendTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/25.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "MyFriendTableViewCell.h"
#import "CommunicateViewController.h"
@interface MyFriendTableViewCell()<UIGestureRecognizerDelegate>
@property UIImageView *icon;
@property  UILabel *label;
@property UIButton *phoneBtn;
@property UIButton * communionBtn;
@property UIButton *fixedPhoneBtn;
@property UIButton * fixedCommunionBtn;
@property NSString *Id;
@property UIView *scrollView;
@end
@implementation MyFriendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        
       self.icon  = [[UIImageView alloc]init];
        
       self.label = [[UILabel alloc]init];
        
        self.phoneBtn = [[UIButton alloc]init];
        
        [self.phoneBtn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        
        [self.phoneBtn addTarget:self action:@selector(clickPhone) forControlEvents:UIControlEventTouchUpInside];
        
        [self.phoneBtn setHidden:YES];
        self.communionBtn = [[UIButton alloc]init];
        
        [self.communionBtn setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        
        [self.communionBtn setHidden:YES];
        
        [self.communionBtn addTarget:self action:@selector(clickCM) forControlEvents:UIControlEventTouchUpInside];
        
        self.scrollView = [[UIView alloc]init];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        panG.maximumNumberOfTouches = 1;
        [self.scrollView addGestureRecognizer:panG];
        
        [self.scrollView addSubview:self.icon];
        [self.scrollView addSubview:self.label];
        [self.scrollView addSubview:self.phoneBtn];
        [self.scrollView addSubview:self.communionBtn];
        
        
        self.fixedPhoneBtn = [[UIButton alloc]init];
        self.fixedCommunionBtn = [[UIButton alloc]init];
        
        [self.contentView addSubview:self.fixedCommunionBtn];
        [self.contentView addSubview:self.fixedPhoneBtn];
        
        [self.fixedPhoneBtn setImage:[UIImage imageNamed:@"打电话1"] forState:UIControlStateNormal];
        
        [self.fixedPhoneBtn addTarget:self action:@selector(clickPhone) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.fixedCommunionBtn setImage:[UIImage imageNamed:@"发消息1"] forState:UIControlStateNormal];
        
        [self.fixedCommunionBtn addTarget:self action:@selector(clickCM) forControlEvents:UIControlEventTouchUpInside];

        [self.fixedCommunionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(20);
            make.left.equalTo(self).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(25, 20));
            
        }];
        
        [self.contentView addSubview:self.scrollView];

        [self addObserver:self forKeyPath:@"clickStatu" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
    }
    return self;
}

- (void)setImage:(NSString *)image Content:(NSString *)content ID:(NSString *)Id
{
    self.Id = Id;
    
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    
    NSLog(@"image:%@",image);
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"Avatar"]];
    
    self.icon.frame = CGRectMake(10, 5, 50, 50);
    
    self.icon.layer.cornerRadius = 25;
    
    self.icon.clipsToBounds = YES;
    
//    self.icon.backgroundColor = [UIColor greenColor];
    
    NSRange range = [content rangeOfString:@"/"];
    
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:content];
        
        [aString addAttributes:@{NSForegroundColorAttributeName:CellUnderLineColor} range:NSMakeRange(range.location, aString.length - range.location)];
        
        self.label.attributedText = aString;
    }
    

    
    
    self.label.frame = CGRectMake(self.icon.right + 10, 0, 200, CONTENT_FONT);
    self.label.centerY = self.icon.centerY;
    [self.communionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.mas_equalTo(15);
        make.right.equalTo(self.scrollView).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.equalTo(self.communionBtn.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
    [self.fixedPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17.5);
        make.right.equalTo(self).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 25));
        
    }];
    
}

- (void)clickPhone
{
    NSLog(@"点击通话");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.phoneNumber message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phoneNum = self.phoneNumber;// 电话号码
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
        [[UIApplication sharedApplication] openURL:phoneURL];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    
    [self.superview.viewController presentViewController:alert animated:YES completion:^{
        
    }];
    
}

- (void)clickCM
{
    NSLog(@"点击聊天");
    
    CommunicateViewController *pushView = [[CommunicateViewController alloc]init];
    pushView.s_admin_id = self.Id;
    [self.superview.viewController.navigationController pushViewController:pushView animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([change[@"new"] boolValue]) {
        
        [self.communionBtn setHidden:NO];
        [self.phoneBtn setHidden:NO];
    }
    else{
        
        [self.communionBtn setHidden:YES];
        [self.phoneBtn setHidden:YES];
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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"clickStatu"];
}
#pragma mark --手势处理
- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer
{
    static int x = 0;
    
    CGPoint point = [gestureRecognizer translationInView:self];
    
    gestureRecognizer.view.x = x + point.x;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        switch (x) {
            case 0:
            {
                if (point.x > 0 && point.x < 50) {
                    gestureRecognizer.view.x = 0;
                }
                else if (point.x >= 50)
                {
                    gestureRecognizer.view.x = 50;
                }
                else if (point.x < 0 && point.x > -50)
                {
                    gestureRecognizer.view.x = 0;
                }
                else if (point.x <= -50)
                {
                    gestureRecognizer.view.x = -50;
                }
            
            }
                break;
            case 50:
            {
                if ( point.x > -50) {
                    gestureRecognizer.view.x = 50;
                }
                else if (point.x <= -50 && point.x > -100)
                {
                    gestureRecognizer.view.x = 0;
                }
                else if (point.x <= -100)
                {
                    gestureRecognizer.view.x = -50;
                }
                
            }
                break;
                
            case -50:
            {
                if ( point.x <= 50) {
                    gestureRecognizer.view.x = -50;
                }
                else if (point.x >= 50 && point.x < 100)
                {
                    gestureRecognizer.view.x = 0;
                }
                else if (point.x >= 100)
                {
                    gestureRecognizer.view.x = 50;
                }
                
            }
                break;
            default:
                break;
        }
        
        x = gestureRecognizer.view.x;
    }
    
}



@end
