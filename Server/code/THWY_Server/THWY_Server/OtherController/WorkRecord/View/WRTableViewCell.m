//
//  WRTableViewCell.m
//  THWY_Server
//
//  Created by HuangYiZhe on 16/8/23.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "WRTableViewCell.h"
#import "RunSliderLabel.h"
@interface WRTableViewCell()<UIWebViewDelegate>
@property UITextView *contentTextView;
@property UIImageView *backGroundView;
@property NSString *content;
@property DocVO *docVo;
@property UIView *fujianView;
@end
@implementation WRTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backGroundView = [[UIImageView alloc]init];
        self.backGroundView.image = [UIImage imageNamed:@"WR展开"];
        [self.contentView addSubview:self.backGroundView];
        
        self.contentTextView = [[UITextView alloc]init];
        [self.contentView addSubview:self.contentTextView];
        
    }
    return self;
}

- (void)setTitle:(DocVO *)docVo
{
    if (self.fujianView) {
        [self.fujianView removeFromSuperview];
    }
    
    self.docVo = docVo;
    self.contentTextView.text = docVo.content;
    self.contentTextView.font = FontSize(CONTENT_FONT);
    self.contentTextView.userInteractionEnabled = NO;
    self.contentTextView.backgroundColor = [UIColor clearColor];
    CGFloat height = [docVo.content sizeWithFont:FontSize(CONTENT_FONT) maxSize:CGSizeMake(self.width - 20, 4000)].height;
    
//    NSArray *array = @[title];
//    NSPredicate * prdicate = [NSPredicate predicateWithFormat:@"SELF LIKE '<*?>'"];
//    NSArray *a = [array filteredArrayUsingPredicate:prdicate];
    
    for (UIView* subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UIWebView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
    if ([docVo.title containsString:@"<"] && [docVo.title containsString:@">"]) {
        
        UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
        webView.scrollView.bounces = NO;
        webView.userInteractionEnabled = NO;
        webView.backgroundColor = My_clearColor;
        webView.delegate = self;
        webView.opaque = NO;
        NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", docVo.title];
//            if (![self.content isEqualToString:title]) {
        [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];

                [webView loadHTMLString:htmlcontent baseURL:nil];
//            }
//            self.content = title;
        [self.contentView addSubview:webView];
        [self.contentTextView removeFromSuperview];
    }
    else
    {
        if (self.contentTextView.superview == nil) {
            [self.contentView addSubview:self.contentTextView];
        }
        if (height < 60) {
            
            self.contentTextView.frame = CGRectMake(10, 10, self.width - 20, 60);
            
        }
        else
        {
            self.contentTextView.frame = CGRectMake(10, 10, self.width - 20, height + 10);
            NSLog(@"%@",docVo.title);
        }
        CGFloat returnHeight = self.contentTextView.bottom + 10;

        if (docVo.files.count != 0) {
            
            self.fujianView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentTextView.bottom, self.contentView.width, 1)];
            self.fujianView.backgroundColor = My_AlphaColor(255, 255, 255, 0);
            [self.contentView addSubview:self.fujianView];
            
            UILabel *fujian = [[UILabel alloc]initWithFrame:CGRectMake(10, 0 , 60, 20)];
            fujian.text = @"附件：";
            fujian.textColor = CellUnderLineColor;
            [self.fujianView addSubview:fujian];
            
            CGFloat y = 0;
            CGFloat x = 60;
            for (int i = 0; i < docVo.files.count; i ++ ) {
                
                CGFloat width = GetContentWidth(docVo.files[i].file_name, Content_Ip_Font);
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width , Content_Ip_Font)];
                [btn setTitle:docVo.files[i].file_name forState:UIControlStateNormal];
                btn.titleLabel.font = FontSize(Content_Ip_Font);
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
                btn.tag = 400 + i;
                [btn addTarget:self action:@selector(clickFujian:) forControlEvents:UIControlEventTouchUpInside];
                y += Content_Ip_Font + 5;
                
                [self.fujianView addSubview:btn];
                
                
                if (i == docVo.files.count - 1) {
                    if (fujian.bottom < btn.bottom) {
                        returnHeight = btn.bottom + 10 + self.fujianView.y;
                        
                    }
                    else
                    {
                        returnHeight = fujian.bottom + 10 + self.fujianView.y;
                        
                    }
                }
            }
        }

        self.fujianView.height = returnHeight - self.fujianView.y;
        
        NSString *heightString = [NSString stringWithFormat:@"%f",returnHeight];
        
        NSString *rowS = [NSString stringWithFormat:@"%ld",self.section];
        
        
        NSArray *array = [self.dictionry allKeys];
        
        BOOL isRefrash = YES;
        
        if (array && array.count != 0) {
            for (NSString *temp in array) {
                
                if ([temp intValue] == self.section) {
                    
                    isRefrash = NO;
                }
            }
        }
        
        if (isRefrash) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"giveHeight" object:@{rowS:heightString}];
            
        }
        
        self.backGroundView.frame = CGRectMake(0, 0, self.width, returnHeight);
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(webView.x, webView.y, webView.width, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    webView.frame = CGRectMake(webView.x, webView.y, webView.width, height);
    
    CGFloat returnHeight = webView.bottom + 10;
    
    if (self.docVo.files.count != 0) {
        
        UILabel *fujian = [[UILabel alloc]initWithFrame:CGRectMake(10, self.contentTextView.bottom , 60, 20)];
        fujian.text = @"附件：";
        fujian.textColor = CellUnderLineColor;
        [self.contentView addSubview:fujian];
        
        CGFloat y = self.contentTextView.bottom;
        CGFloat x = 60;
        for (int i = 0; i < self.docVo.files.count; i ++ ) {
            
            CGFloat width = GetContentWidth(self.docVo.files[i].file_name, Content_Ip_Font);
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width , Content_Ip_Font)];
            [btn setTitle:self.docVo.files[i].file_name forState:UIControlStateNormal];
            btn.titleLabel.font = FontSize(Content_Ip_Font);
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            btn.tag = 400 + i;
            [btn addTarget:self action:@selector(clickFujian:) forControlEvents:UIControlEventTouchUpInside];
            y += Content_Ip_Font + 5;
            
            [self.contentView addSubview:btn];
            
            
            if (i == self.docVo.files.count - 1) {
                if (fujian.bottom < btn.bottom) {
                    returnHeight = btn.bottom + 10;
                    
                }
                else
                {
                    returnHeight = fujian.bottom + 10;
                    
                }
            }
        }
    }

    
    NSString *rowS = [NSString stringWithFormat:@"%ld",self.section];
    NSString *heightS = [NSString stringWithFormat:@"%lf",returnHeight];
    self.backGroundView.frame = CGRectMake(0, 0, self.width, [heightS floatValue]);
    
    
    NSArray *array = [self.dictionry allKeys];
    
    BOOL isRefrash = YES;
    
    if (array && array.count != 0) {
        for (NSString *temp in array) {
            
            if ([temp intValue] == self.section) {
                
                isRefrash = NO;
            }
        }
    }
    
    if (isRefrash) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"giveHeight" object:@{rowS:heightS}];
        
    }
    [SVProgressHUD dismiss];
    
    //        [SVProgressHUD dismiss];
    
}

- (void)clickFujian:(UIButton *)btn
{
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.docVo.files[btn.tag - 400] showInVC:self.superview.viewController];
    
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
