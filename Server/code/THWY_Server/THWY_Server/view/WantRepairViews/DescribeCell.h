//
//  DescribeCell.h
//  THWY_Client
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DescribeCellDelegate <NSObject>

- (void)commit;

@end

@interface DescribeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) id<DescribeCellDelegate> delegate;

@end
