//
//  ProclamationTableViewCell.m
//  THWY_Client
//
//  Created by HuangYiZhe on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ProclamationTableViewCell.h"
@interface ProclamationTableViewCell()<UIWebViewDelegate>
@property UIImageView *head;
@property UIImageView *right;
@property UIView *backView;
@end
@implementation ProclamationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHeight:) name:@"cellHeight" object:nil];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.head = [[UIImageView alloc]init];
        self.right = [[UIImageView alloc]init];
        self.title = [[UILabel alloc]init];
        self.time = [[UILabel alloc]init];
        self.content = [[UILabel alloc]init];
        self.backView = [[UIView alloc]init];
        
        self.head.frame = CGRectMake(0, 0, 1, 3);
        self.right.frame = CGRectMake(0, 0, 20, 20);
        self.title.frame = CGRectMake(0, CGRectGetMaxY(self.head.frame) + 5, 1, 30);
        
        self.time.frame = CGRectMake(0, CGRectGetMaxY(self.title.frame), 1, 14);

        self.backView.backgroundColor = [UIColor whiteColor];

        self.head.image = [UIImage imageNamed:@"bg_repair_history_color_bar_three"];
        
        UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        left.center = CGPointMake(9, 0);
        left.image = [UIImage imageNamed:@"左"];
        
        self.right.image = [UIImage imageNamed:@"右"];
        
        self.title.textAlignment = NSTextAlignmentCenter;
        
        self.time.font = FontSize(Content_Time_Font);
        
        self.time.textAlignment = NSTextAlignmentCenter;

        self.time.textColor = [UIColor lightGrayColor];
        
        self.content.numberOfLines = 6;
        self.content.font = FontSize(CONTENT_FONT);
        
        [self.backView addSubview:self.title];
        [self.backView addSubview:self.time];
        [self.backView addSubview:self.head];
        [self.backView addSubview:self.content];
        [self.contentView addSubview:left];
        [self.backView addSubview:self.right];
        
        self.backView.backgroundColor = WhiteAlphaColor;
        
        [self.contentView addSubview:self.backView];

        
    }
    return self;
}

- (void)updateFrame:(CGFloat)height Width:(CGFloat)width
{
    CGFloat contentWidth = width;
    self.backView.frame = CGRectMake(0, 0, contentWidth, self.height);
    self.head.width = contentWidth;
    self.time.width = contentWidth;
    self.title.width = contentWidth;
    self.content.width = contentWidth;
    self.right.center = CGPointMake(contentWidth - 9, 0);

}

- (void)getHeight:(NSNotification *)notification
{

    [self updateFrame:[notification.object[0] floatValue] Width:[notification.object[1] floatValue]];
}

- (void)setTitle:(NSString *)title time:(NSString *)time content:(NSString *)content width:(CGFloat)width
{
    self.title.text = title;
    self.time.text = time;
    
    NSArray *array = @[content];
    NSPredicate * prdicate = [NSPredicate predicateWithFormat:@"SELF LIKE '<*?>'"];
    NSArray *a = [array filteredArrayUsingPredicate:prdicate];
    
    for (UIView* subView in self.backView.subviews) {
        if ([subView isKindOfClass:[UIWebView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
    
    if (a.count) {
        [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
        
        UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.time.frame) + 8, width, 0)];
        webView.scrollView.bounces = NO;
        webView.backgroundColor = My_clearColor;
        webView.delegate = self;
        webView.opaque = NO;
        NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", content];
        [webView loadHTMLString:htmlcontent baseURL:nil];
        
        [self.backView addSubview:webView];
        [self.content removeFromSuperview];
    }
    else
    {
        self.content.text = content;
        CGFloat contenHeight = [content sizeWithFont:FontSize(CONTENT_FONT) maxSize:CGSizeMake(width, 4000)].height;
        self.content.frame = CGRectMake(5, CGRectGetMaxY(self.time.frame) + 8, width - 10, contenHeight);
        [self.backView addSubview:self.content];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"giveHeight" object:@[[NSNumber numberWithFloat:webView.bottom + 1000]]];
//    self.height = webView.bottom + 200;
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
