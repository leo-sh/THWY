//
//  AlertView.h
//  THWY_Client
//
//  Created by HuangYiZhe on 16/8/3.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView<UITextViewDelegate>
@property UILabel *title;
@property UITextView *textView;
- (void)show;
- (void)hide;
- (void)addSubOhterview:(UIView *)view;
- (void)addLeftBtnTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)setPlaceholder:(NSString *)placeholder;
@end
