//
//  UploadCell.m
//  THWY_Server
//
//  Created by wei on 16/7/30.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "UploadCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UploadCell ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation UploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.layer.borderWidth = 0.5;
}

- (IBAction)select:(UIButton *)sender {
    
    TYAlertView *alertView = [[TYAlertView alloc]init];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    My_WeakSelf;
    [alertView addAction:[TYAlertAction actionWithTitle:@"相机" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"从相册选择" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self loadImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
//    [alertController setDismissComplete:^{
//        [AssetView showInVC:[weakSelf vc:weakSelf.delegate] onComplete:^(UIImage *image) {
//            
//        }];
//    }];
    
    UIViewController *vc = [self vc:self.delegate] ;
    [vc presentViewController:alertController animated:YES completion:nil];
    
}

- (UIViewController *)vc:(UIView *)view{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 选择上传图片
- (void)loadImageWithType:(UIImagePickerControllerSourceType)type
{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType = type;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = NO;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    if (self.selectType == ImageType) {
        _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    }else{
        _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        if (type == UIImagePickerControllerSourceTypeCamera) {
            
            //录制视频时长，默认10s
            _imagePickerController.videoMaximumDuration = 15;
            
            //视频上传质量
            _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
            
            //设置摄像头模式（拍照，录制视频）为录像模式
            _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            
        }
    }
    
    UIViewController *vc = [self vc:self.delegate] ;
    [vc presentViewController:_imagePickerController animated:YES completion:nil];
    
}

//实现选取图片结束后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        if (_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //保存图片至相册
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        //上传图片
        [self.delegate select:image type:ImageType];
        self.textField.text = NSHomeDirectory();
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSString *urlStr = [url path];
#pragma mark - URL
        NSLog(@"path ::  %@", url);
        if (_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                    
                    UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            });
        }
        //视频上传
        self.textField.text = urlStr;
        [self.delegate select:[NSString stringWithFormat:@"file://%@",urlStr] type:VideoType];
    }
    
    UIViewController *vc = [self vc:self.delegate] ;
    [vc dismissViewControllerAnimated:NO completion:nil];
  
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    if (error) {
        NSLog(@"保存图片过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"图片保存成功.");
    }
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
