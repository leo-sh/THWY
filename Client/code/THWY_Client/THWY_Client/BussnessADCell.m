//
//  BussnessADCell.m
//  THWY_Client
//
//  Created by wei on 16/7/31.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "BussnessADCell.h"
#import "ProclamationInfoViewController.h"

@interface BussnessADCell ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (strong, nonatomic) AdVO *advo;
@end

@implementation BussnessADCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnclick)];
    [self.desc addGestureRecognizer:tap];
    
}

- (void)tapOnclick{
    
    ProclamationInfoViewController *detail = [[ProclamationInfoViewController alloc] init];
    detail.proclamationId = self.advo.Id;
    detail.type = 1;
    [self.vc.navigationController pushViewController:detail animated:YES];

}

- (void)loadDataFromMercharge:(AdVO *)merchant{
    
    self.title.text = merchant.title;
    self.advo = merchant;

    self.timeLabel.text = [NSString stringDateFromTimeInterval:[merchant.ctime integerValue] withFormat:@"YYYY-MM-dd HH:mm"];
    
    NSArray *array = @[merchant.content];
    NSPredicate * prdicate = [NSPredicate predicateWithFormat:@"SELF LIKE '<*?>'"];
    NSArray *a = [array filteredArrayUsingPredicate:prdicate];
    
    if (a.count) {
        for (UIView* subView in self.desc.superview.subviews) {
            if ([subView isKindOfClass:[UIWebView class]]) {
                [subView removeFromSuperview];
                break;
            }
        }
        
        UIWebView* webView = [[UIWebView alloc]initWithFrame:self.desc.frame];
        
        webView.scrollView.bounces = NO;
        webView.backgroundColor = My_clearColor;
        webView.delegate = self;
        webView.opaque = NO;
        NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", merchant.content];
        [webView loadHTMLString:htmlcontent baseURL:nil];
        
        [self.desc.superview addSubview:webView];
        self.desc.alpha = 0;
    }
    else
    {
        self.desc.text = merchant.content;
        self.desc.alpha = 1;
        
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
