//
//  UploadCell.h
//  YTWY_Client
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UploadCellDelegate <NSObject>

typedef NS_ENUM(NSInteger, SelectType){
    ImageType = 1,
    VideoType
};

- (void)select:(id)content type:(SelectType)type;

@end

@interface UploadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (assign, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id<UploadCellDelegate> delegate;

@property (assign, nonatomic) SelectType selectType;

@end
