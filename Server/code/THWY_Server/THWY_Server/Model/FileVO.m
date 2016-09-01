//
//  FileVO.m
//  THWY_Server
//
//  Created by Mr.S on 16/9/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "FileVO.h"

@interface FileVO ()

@property NSURLSessionDownloadTask * downloadTask;

@property UIViewController* vc;

@end

@implementation FileVO

-(FileVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.Id = JSON[@"id"];
        self.file_name = JSON[@"file_name"];
        self.ctime = JSON[@"ctime"];
        self.file_path = JSON[@"file_path"];
        self.file_size = JSON[@"file_size"];
        self.file_type = JSON[@"file_type"];
        self.note_txt_id = JSON[@"note_txt_id"];
    }
    
    return self;
}

-(void)showInVC:(UIViewController *)vc
{
    self.vc = vc;
    switch (My_ServicesManager.status) {
        case NotReachable:
            [SVProgressHUD showErrorWithStatus:@"网络未连接"];
            NSLog(@"网络未连接");
            break;
        case ReachableViaWWAN:{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前处于非WiFi状态" message:@"你确定下载文件吗?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self downLoadFile];
                
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }];
            
            [alert addAction:confirm];
            [alert addAction:cancel];
            
            [vc presentViewController:alert animated:YES completion:^{
                
            }];
            
            break;
        }
        case ReachableViaWiFi:{
            [self downLoadFile];
            break;
        }
        default:
            break;
    }
    
    
}

-(void)downLoadFile
{
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    NSURL *URL = [NSURL URLWithString:self.file_path];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [SVProgressHUD showSubTitle:@"下载中 0.00％"];
    
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        [SVProgressHUD showSubTitle:[NSString stringWithFormat:@"下载中 %.2f％",downloadProgress.fractionCompleted*100]];
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        My_ServicesManager.vc = self.vc;
        [My_ServicesManager showFile:filePath];
        [SVProgressHUD dismiss];
        
    }];
    [_downloadTask resume];
}

@end
