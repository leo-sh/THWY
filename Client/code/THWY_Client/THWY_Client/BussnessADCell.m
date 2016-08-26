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
@property (strong, nonatomic) UIWebView* webView;
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
        [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
        for (UIView* subView in self.desc.superview.subviews) {
            if ([subView isKindOfClass:[UITextView class]]) {
                [subView removeFromSuperview];
                break;
            }
        }
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(self.desc.x, self.desc.y, My_ScreenW-36, 100)];
        
        self.webView.scrollView.bounces = NO;
        self.webView.backgroundColor = My_clearColor;
        self.webView.delegate = self;
        self.webView.opaque = NO;
        NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", merchant.content];
        [self.webView loadHTMLString:htmlcontent baseURL:nil];
        
        [self.contentView addSubview:self.webView];
        [self.contentView bringSubviewToFront:self.webView];
        self.desc.alpha = 0;
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FontSize(CONTENT_FONT-1),NSFontAttributeName, nil];
        CGRect rect = [merchant.content boundingRectWithSize:CGSizeMake(self.desc.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        self.desc.width = rect.size.width;
        self.desc.height = rect.size.height;
        
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
    
    [SVProgressHUD dismiss];
}

- (CGFloat)heightForCell{
    
    if (self.webView == nil) {
        return 100.0 + self.desc.height + 10 > 300/667.0*My_ScreenH ? 100.0 + self.desc.height + 10:300/667.0*My_ScreenH;
    }else{
        return 100.0 + self.webView.height + 10 > 300/667.0*My_ScreenH ? 100.0 + self.webView.height +10:300/667.0*My_ScreenH;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
