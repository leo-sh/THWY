//
//  ServicesManager.m
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ServicesManager.h"
#import "UMessage.h"

@interface ServicesManager ()<UIDocumentInteractionControllerDelegate>
{
    NSString* _userName;
    NSString* _passWord;
    SystemSoundID _ringSystemSoundID;
}

@property (nonatomic, strong) Reachability* baiduReach;

@end

@implementation ServicesManager

+(ServicesManager *)getAPI
{
    static ServicesManager *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

-(void)palySend
{
    [self play:@"fasong.caf" withShake:NO];
}

-(void)palyReceive
{
    [self play:@"shou.caf" withShake:YES];
}

-(void)palyPush
{
    [self play:@"tuisong.caf" withShake:YES];
}

-(void)play:(NSString *)soundName withShake:(BOOL)isShake
{
    BOOL shake = [[UDManager getUD] showShakeState];
    BOOL sound = [[UDManager getUD] showSoundState];
    
    if (!isShake && shake) {
        shake = isShake;
    }
    
    if (!shake && !sound) {
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], soundName];
    if (path) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient
                                               error:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:path], &_ringSystemSoundID);
        
        if (shake && sound) {
            AudioServicesPlayAlertSound(_ringSystemSoundID);
        }else if (shake && !sound)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }else if (!shake && sound)
        {
            AudioServicesPlaySystemSound(_ringSystemSoundID);
        }
    }else
    {
        NSLog(@"获取音频文件 %@ 失败！",soundName);
    }
    
}

-(instancetype)init
{
    if (self = [super init]) {
        self.portNum = Normal_API_Port;
        self.mode = Normal;
        
        if ([self isLogin]) {
            _userName = [[UDManager getUD] getUserName];
            _passWord = [[UDManager getUD] getPassWord];
        }
        self.baiduReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        
        [My_NoteCenter addObserver:self
                          selector:@selector(reachabilityChanged)
                              name:kReachabilityChangedNotification
                            object:nil];
        
        self.status = 3;
        [self.baiduReach startNotifier];
        
    }
    return self;
}

//检测到网络状态改变
-(void)reachabilityChanged
{
    if (self.baiduReach.currentReachabilityStatus != self.status) {
        self.status = self.baiduReach.currentReachabilityStatus;
        
        [My_NoteCenter postNotificationName:NetWorkChanged object:[NSNumber numberWithInteger:self.status]];
    }
}

#pragma mark 私有函数
- (AFHTTPSessionManager *)getManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    return manager;
}

-(void)showFile:(NSURL *)filePath
{
    self.documentInteractionController = [UIDocumentInteractionController
                                                        interactionControllerWithURL:filePath];
    [self.documentInteractionController setDelegate:self];
    
    [self.documentInteractionController presentOptionsMenuFromRect:self.vc.view.bounds inView:self.vc.view animated:YES];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.vc;
}

-(UIImage *)getFitImageData:(UIImage *)image{
    
    float imageRatio = image.size.width/image.size.height;
    UIImage *newImage;
    if (image.size.width > 500 ||
        image.size.height > 500) {
        if (image.size.width > image.size.height) {
            newImage = [self imageWithImage:image scaledToSize:CGSizeMake(500, 500/imageRatio)];
        }else{
            newImage = [self imageWithImage:image scaledToSize:CGSizeMake(500*imageRatio, 500)];
        }
    }else{
        newImage = image;
    }
    
    return newImage;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)convertVideoQuailtyWithInputURL:(NSString*)inputStr
                              outputURL:(NSURL*)outputURL
                        completeHandler:(void (^)(AVAssetExportSession*))handler
{
    NSURL* inputURL = nil;
    if (inputStr.length != 0) {
        inputURL = [NSURL URLWithString:inputStr];
    }else
    {
        handler(nil);
        return;
    }
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
     }];
    
}

- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}//此方法可以获取视频文件的时长。

-(void)handleRepair:(Repair_RootVO *)repair params:(NSDictionary* )params urlStr:(NSString* )urlString onComplete:(void (^)(NSString *errorMsg))onComplete
{
    NSData *imageData = nil;
    if (repair.image) {
        imageData = UIImageJPEGRepresentation(repair.image, 1);
    }
    
    CGFloat sizeOfImage = imageData.length/1000.0/1024.0;
    CGFloat ratio = 0.95;
    while (sizeOfImage >= 2.0) {
        [SVProgressHUD showSubTitle:@"压缩图片"];
        imageData = UIImageJPEGRepresentation(repair.image, ratio);
        sizeOfImage = imageData.length/1000.0/1024.0;
        ratio -= 0.05;
    }
    
    if (repair.videoPath.length > 0) {
        [SVProgressHUD showSubTitle:@"转换视频格式"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSURL *newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", str]] ;
        [self convertVideoQuailtyWithInputURL:repair.videoPath outputURL:newVideoUrl completeHandler:^(AVAssetExportSession * exportSession) {
            
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCancelled:
                {
                    onComplete(@"Cancelled");
                    NSLog(@"AVAssetExportSessionStatusCancelled");
                }
                    break;
                case AVAssetExportSessionStatusUnknown:
                {
                    onComplete(@"Unknown");
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                }
                    break;
                case AVAssetExportSessionStatusWaiting:
                {
                    onComplete(@"Waiting");
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                }
                    break;
                case AVAssetExportSessionStatusExporting:
                {
                    onComplete(@"Exporting");
                    NSLog(@"AVAssetExportSessionStatusExporting");
                }
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:newVideoUrl]]);
                    NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[newVideoUrl path]]]);
                    NSData *videoData = [NSData dataWithContentsOfURL:newVideoUrl];
                    [self subMitRepair:params image:imageData video:videoData urlString:urlString onComplete:onComplete];
                }
                    break;
                case AVAssetExportSessionStatusFailed:
                {
                    onComplete(@"Failed");
                    NSLog(@"AVAssetExportSessionStatusFailed");
                }
                    break;
                default:
                    break;
            }
        }];
    }else
    {
        [self subMitRepair:params image:imageData video:nil urlString:urlString onComplete:onComplete];
    }
}

-(void)getErrorMessage:(NSString *)code
            onComplete:(void (^)(NSString *errorMsg))onComplete
{
    NSInteger codeNum = [code integerValue];
    NSArray* errorArr = @[@3,@5,@8];
    
    for (NSNumber* num in errorArr) {
        NSInteger errNum = [num integerValue];
        if (errNum == codeNum) {
            [My_NoteCenter postNotificationName:@"userError" object:nil];
            break;
        }
    }
    
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_op_msg_by_code",API_HOST];
    NSDictionary *params = @{@"k":code};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"datas"]);
        onComplete(responseObject[@"datas"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {\
        NSLog(@"网络连接错误");
        onComplete(@"网络连接错误");
    }];
}

#pragma mark 公共函数
-(void)login:(NSString *)userName
    password:(NSString *)password
savePassWord:(BOOL)save
  onComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@login",API_HOST];
    NSDictionary *params = @{@"login_name":userName,
                             @"login_password":password};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            _userName = userName;
            _passWord = password;
            
            UserVO* user = [[UserVO alloc]initWithJSON:responseObject[@"datas"]];
            [[UDManager getUD] saveUser:user];
            
            NSMutableArray* tagArr = [[NSMutableArray alloc]initWithObjects:@"manager",[NSString stringWithFormat:@"admin_id_%@",user.admin_id],[NSString stringWithFormat:@"group_id%@",user.admin_group_id], nil];
            if ([user.is_serviceman isEqualToString:@"1"]) {
                [tagArr addObject:@"wx"];
            }
            
            NSArray* estates = [user.estate_ids componentsSeparatedByString:@","];
            for (NSString* estateId in estates) {
                [tagArr addObject:[NSString stringWithFormat:@"estate_id_%@",estateId]];
            }
            
            [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                [UMessage addTag:tagArr response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                    
                }];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UDManager getUD] saveUserName:userName];
                [[UDManager getUD] saveUserPassWord:password];
                [[UDManager getUD] saveShowState:save];
                
                [[UDManager getUD] saveSoundState:YES];
                [[UDManager getUD] saveShakeState:YES];
            });
            
            onComplete(nil,user);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getUserInfoOnComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_my_info",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            UserVO* user = [[UserVO alloc]initWithJSON:responseObject[@"datas"]];
            NSMutableArray* tagArr = [[NSMutableArray alloc]initWithObjects:@"manager",[NSString stringWithFormat:@"admin_id_%@",user.admin_id],[NSString stringWithFormat:@"group_id%@",user.admin_group_id], nil];
            if ([user.is_serviceman isEqualToString:@"1"]) {
                [tagArr addObject:@"wx"];
            }
            
            NSArray* estates = [user.estate_ids componentsSeparatedByString:@","];
            for (NSString* estateId in estates) {
                [tagArr addObject:[NSString stringWithFormat:@"estate_id_%@",estateId]];
            }
            
            [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                [UMessage addTag:tagArr response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                    
                }];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UDManager getUD] saveUser:user];
            });
            onComplete(nil,user);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)editUserInfo:(NSString *)realName
          phoneNum:(NSString *)phoneNum
        newPassWord:(NSString *)newPassWord
        pic:(UIImage *)image
         onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@edit_my_info",API_HOST];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"login_name"] = _userName;
    params[@"login_password"] = _passWord;
    
    if (realName.length > 0) {
        params[@"real_name"] = realName;
    }else
    {
        onComplete(@"请输入姓名");
        return;
    }
    
    if ([phoneNum isValidateMobile]) {
        params[@"cellphone"] = phoneNum;
    }else
    {
        onComplete(@"手机号码有误");
        return;
    }
    
    if (newPassWord.length > 0) {
        params[@"new_password"] = newPassWord;
    }
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            UIImage *newImage = [self getFitImageData:image];
            NSData *data = UIImagePNGRepresentation(newImage);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            if (newPassWord.length > 0) {
                _passWord = newPassWord;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UDManager getUD] saveUserPassWord:newPassWord];
                });
            }
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)upLoadAvatar:(UIImage *)image OnComplete:(void (^)(NSString *errorMsg, NSString *avatar))onComplete
{
    UIImage *newImage = [self getFitImageData:image];
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
    
    CGFloat sizeOfImage = imageData.length/1000.0/1024.0;
    CGFloat ratio = 0.95;
    while (sizeOfImage >= 2.0) {
        [SVProgressHUD showSubTitle:@"压缩图片"];
        imageData = UIImageJPEGRepresentation(image, ratio);
        sizeOfImage = imageData.length/1000.0/1024.0;
        ratio -= 0.05;
    }
    
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@avatar",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:imageData name:@"pic" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            
            onComplete(nil,responseObject[@"datas"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)logOut:(void (^)())onComplete
{
    [[UDManager getUD] removeUDUser];
    [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
        
    }];
    onComplete();
}

-(void)getIpAllows:(void (^)(NSString *errorMsg,NSArray* list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@ip_allow_list",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* ipDic in responseObject[@"datas"]) {
                    IPAllowVO* ip = [[IPAllowVO alloc]initWithJSON:ipDic];
                    [listArr addObject:ip];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getAIpAllow:(NSString *)ipId onComplete:(void (^)(NSString *errorMsg,IPAllowVO* list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_ip_allow_by_id",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"id":ipId};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            IPAllowVO* ip = [[IPAllowVO alloc]initWithJSON:responseObject[@"datas"]];
            
            onComplete(nil,ip);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)addAIpAllow:(IPAllowVO *)ip onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@add_ip_allow",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"ip":ip.ip,
                             @"the_user":ip.the_user};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)editAIpAllow:(IPAllowVO *)ip onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@edit_ip_allow",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"ip":ip.ip,
                             @"the_user":ip.the_user,
                             @"id":ip.Id};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)getFriends:(void (^)(NSString *errorMsg,NSArray* list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@friends",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* userDic in responseObject[@"datas"]) {
                    UserVO* user = [[UserVO alloc]initWithJSON:userDic];
                    [listArr addObject:user];
                }
            }
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)findFriends:(NSString* )phoneNum name:(NSString *)name onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@search_friend_by_mobile_or_name",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithDictionary:params];
    if (phoneNum.length > 0) {
        dic[@"mobile"] = phoneNum;
    }
    if (name.length > 0) {
        dic[@"name"] = name;
    }
    
    [manager GET:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* userDic in responseObject[@"datas"]) {
                    UserVO* user = [[UserVO alloc]initWithJSON:userDic];
                    [listArr addObject:user];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)addFriend:(NSString *)adminId onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@add_friend_by_admin_id",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"admin_id":adminId};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)getNotice:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete
{
    page ++;
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@notice",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"page":[NSString stringWithFormat:@"%d",page]};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"][@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* noticDic in responseObject[@"datas"][@"datas"]) {
                    NoticVO* notic = [[NoticVO alloc]initWithJSON:noticDic];
                    [listArr addObject:notic];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getANotice:(NSString *)noticeId onComplete:(void (^)(NSString *errorMsg,NoticVO *notic))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@notice_detail",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"id":noticeId};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NoticVO* notic = [[NoticVO alloc]initWithJSON:responseObject[@"datas"]];
            onComplete(nil,notic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getAds:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete
{
    page ++;
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@ads",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"page":[NSString stringWithFormat:@"%d",page]};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"][@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* adDic in responseObject[@"datas"][@"datas"]) {
                    AdVO* ad = [[AdVO alloc]initWithJSON:adDic];
                    [listArr addObject:ad];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getAnAd:(NSString *)adId onComplete:(void (^)(NSString *errorMsg,AdVO *notic))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@ad_detail",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"id":adId};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            AdVO* ad = [[AdVO alloc]initWithJSON:responseObject[@"datas"]];
            onComplete(nil,ad);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getDocTypes:(void (^)(NSString *errorMsg,NSArray* list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_doc_type",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* typeDic in responseObject[@"datas"]) {
                    DocTypeVO* type = [[DocTypeVO alloc]initWithJSON:typeDic];
                    [listArr addObject:type];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getDocs:(int)page docTypeId:(NSString *)typeId public:(int)isPublic belong:(int)belong onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete
{
    page ++;
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_docs",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"page":[NSString stringWithFormat:@"%d",page]};
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithDictionary:params];
    if (typeId.length > 0) {
        dic[@"doc_type_id"] = typeId;
    }
    
    if (isPublic < 2) {
        dic[@"is_public"] = [NSString stringWithFormat:@"%d",isPublic];
    }
    
    if (belong < 2) {
        dic[@"belong"] = [NSString stringWithFormat:@"%d",belong];
    }
    
    [manager GET:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            if (isPublic && belong == 1) {
                [self getFriends:^(NSString *errorMsg, NSArray *list) {
                    if (errorMsg == nil) {
                        NSMutableArray* listArr = [[NSMutableArray alloc]init];
                        if ([responseObject[@"datas"][@"datas"] isKindOfClass:[NSArray class]]) {
                            for (NSDictionary* docDic in responseObject[@"datas"][@"datas"]) {
                                DocVO* doc = [[DocVO alloc]initWithJSON:docDic];
                                BOOL isFriend = NO;
                                for (UserVO* user in list) {
                                    if ([doc.admin_id isEqualToString:user.admin_id] && doc.is_public) {
                                        isFriend = YES;
                                        break;
                                    }
                                }
                                if (isFriend) {
                                    [listArr addObject:doc];
                                }
                            }
                        }
                        onComplete(nil,listArr);
                    }else{
                        onComplete(errorMsg,nil);
                    }
                    
                }];
            }else
            {
                NSMutableArray* listArr = [[NSMutableArray alloc]init];
                if ([responseObject[@"datas"][@"datas"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* docDic in responseObject[@"datas"][@"datas"]) {
                        DocVO* doc = [[DocVO alloc]initWithJSON:docDic];
                        [listArr addObject:doc];
                    }
                }
                onComplete(nil,listArr);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getADoc:(NSString *)docId onComplete:(void (^)(NSString *errorMsg,DocVO* doc))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_doc",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"id":docId};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            DocVO* doc = [[DocVO alloc]initWithJSON:responseObject[@"datas"]];
            
            onComplete(nil,doc);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)addDoc:(NSString *)typeId public:(BOOL)public title:(NSString* )title content:(NSString* )content onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@add_doc",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"doc_type_id":typeId,
                             @"is_public":[NSNumber numberWithBool:public],
                             @"title":title,
                             @"content":content};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)editDoc:(NSString* )docId typeId:(NSString *)typeId public:(BOOL)public title:(NSString* )title content:(NSString* )content onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@edit_doc",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"id":docId,
                             @"doc_type_id":typeId,
                             @"is_public":[NSNumber numberWithBool:public],
                             @"title":title,
                             @"content":content};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)delDoc:(NSString* )docId onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@del_doc",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"id":docId};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)getEstates:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_estates",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* estateDic in responseObject[@"datas"]) {
                    EstateVO *estate = [[EstateVO alloc]initWithJSON:estateDic];
                    [listArr addObject:estate];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getBlock:(NSString *)estateId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_estate_block",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"estate_id":estateId};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* estateDic in responseObject[@"datas"]) {
                    [listArr addObject:estateDic[@"block"]];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getUnit:(NSString *)estateId block:(NSString *)block onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_estate_block_unit",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"estate_id":estateId,
                             @"block":block};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* estateDic in responseObject[@"datas"]) {
                    [listArr addObject:estateDic[@"unit"]];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getLayer:(NSString *)estateId block:(NSString *)block unit:(NSString *)unit onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_estate_block_unit_layer",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"estate_id":estateId,
                             @"block":block,
                             @"unit":unit};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* estateDic in responseObject[@"datas"]) {
                    [listArr addObject:estateDic[@"layer"]];
                }
            }
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getPublicRepairClasses:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_public_repair_cls",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            for (NSDictionary* estateDic in responseObject[@"datas"][@"_child"]) {
                RepairClassVO *estate = [[RepairClassVO alloc]initWithJSON:estateDic];
                [listArr addObject:estate];
            }
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getPublicRepairStatus:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_public_repair_status",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            for (NSDictionary* estateDic in responseObject[@"datas"]) {
                RepairStatuVO *estate = [[RepairStatuVO alloc]initWithJSON:estateDic];
                [listArr addObject:estate];
            }
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)addPublicRepair:(AddPublicRepairVO *)repair onComplete:(void (^)(NSString *errorMsg))onComplete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString = [NSString stringWithFormat:@"%@add_public_repair",API_HOST];
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        params[@"login_name"] = _userName;
        params[@"login_password"] = _passWord;
        params[@"kb"] = [NSString stringWithFormat:@"%d",repair.kb];
        params[@"estate_id"] = repair.estate_id;
        params[@"block"] = repair.block;
        params[@"unit"] = repair.unit;
        params[@"layer"] = repair.layer;
        params[@"call_name"] = repair.call_name;
        params[@"call_phone"] = repair.call_phone;
        params[@"cls"] = repair.cls;
        params[@"repair_detail"] = repair.repair_detail;
        
        [self handleRepair:repair params:params urlStr:urlString onComplete:onComplete];
    });
    
}

-(void)subMitRepair:(NSDictionary* )params image:(NSData* )imageData video:(NSData *)videoData urlString:(NSString *)urlString onComplete:(void (^)(NSString *errorMsg))onComplete
{
    [SVProgressHUD showSubTitle:@"上传中 0.00％"];
    AFHTTPSessionManager *manager = [self getManager];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [NSString stringWithFormat:@"%@%d",[formatter stringFromDate:[NSDate date]],arc4random() % 99999];
        
        if (imageData) {
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:imageData name:@"pic" fileName:fileName mimeType:@"image/png"];
        }
        if (videoData) {
            NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
            [formData appendPartWithFileData:videoData name:@"vdo" fileName:fileName mimeType:@"video/mp4"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD showSubTitle:[NSString stringWithFormat:@"上传中 %.2f％",uploadProgress.fractionCompleted*100]];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)getRepairStatus:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_repair_status",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            for (NSDictionary* estateDic in responseObject[@"datas"]) {
                RepairStatuVO *estate = [[RepairStatuVO alloc]initWithJSON:estateDic];
                [listArr addObject:estate];
            }
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getRepairStatistic:(NSString *)estateId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_repair_statistic",API_HOST];
    NSDictionary *params = nil;
    if (estateId.length > 0) {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"estate_id":estateId};
    }else
    {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord};
    }
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            for (NSArray* estateArr in responseObject[@"datas"]) {
                NSMutableArray* list = [[NSMutableArray alloc]init];
                for (NSDictionary* estateDic in estateArr) {
                    RepairStatisticVO *estate = [[RepairStatisticVO alloc]initWithJSON:estateDic];
                    [list addObject:estate];
                }
                [listArr addObject:list];
            }
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getPublicRepairStatistic:(NSString *)estateId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_public_repair_statistic",API_HOST];
    NSDictionary *params = nil;
    if (estateId.length > 0) {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"estate_id":estateId};
    }else
    {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord};
    }
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            for (NSArray* estateArr in responseObject[@"datas"]) {
                NSMutableArray* list = [[NSMutableArray alloc]init];
                for (NSDictionary* estateDic in estateArr) {
                    RepairStatisticVO *estate = [[RepairStatisticVO alloc]initWithJSON:estateDic];
                    [list addObject:estate];
                }
                [listArr addObject:list];
            }
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getRepairs:(int)page repairStatu:(NSString *)repairStatuId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    page ++;
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_repairs",API_HOST];
    NSDictionary *params = nil;
    if (repairStatuId.length > 0) {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"page":[NSString stringWithFormat:@"%d",page],
                   @"repair_status":repairStatuId};
    }else
    {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"page":[NSString stringWithFormat:@"%d",page]};
    }
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
                for (NSDictionary* estateDic in responseObject[@"datas"][@"datas"]) {
                    RepairVO *estate = [[RepairVO alloc]initWithJSON:estateDic];
                    [listArr addObject:estate];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getARepair:(NSString *)repairId onComplete:(void (^)(NSString *errorMsg,RepairVO *repair))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_repair",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                                      @"login_password":_passWord,
                                      @"id":repairId};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            RepairVO *estate = [[RepairVO alloc]initWithJSON:responseObject[@"datas"]];
            
            onComplete(nil,estate);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getPublicRepairs:(int)page repairStatu:(NSString *)repairStatuId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    page ++;
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_public_repairs",API_HOST];
    NSDictionary *params = nil;
    if (repairStatuId.length > 0) {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"page":[NSString stringWithFormat:@"%d",page],
                   @"st":repairStatuId};
    }else
    {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"page":[NSString stringWithFormat:@"%d",page]};
    }
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"][@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* estateDic in responseObject[@"datas"][@"datas"]) {
                    RepairVO *estate = [[RepairVO alloc]initWithJSON:estateDic];
                    [listArr addObject:estate];
                }
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getAPublicRepair:(NSString *)repairId onComplete:(void (^)(NSString *errorMsg,RepairVO *repair))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_public_repair",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"id":repairId};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            RepairVO *estate = [[RepairVO alloc]initWithJSON:responseObject[@"datas"]];
            
            onComplete(nil,estate);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getTaskList:(TaskType )type page:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    page ++;
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_task_list",API_HOST];
    NSString *typeStr = @"";
    switch (type) {
        case All:
            typeStr = @"all";
            break;
        case New:
            typeStr = @"new";
            break;
        case Processing:
            typeStr = @"processing";
            break;
        case Done:
            typeStr = @"done";
            break;
            
        default:
            break;
    }
    
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"page":[NSString stringWithFormat:@"%d",page],
                             @"type":typeStr};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            for (NSDictionary* estateDic in responseObject[@"datas"]) {
                TaskVO *estate = [[TaskVO alloc]initWithJSON:estateDic];
                [listArr addObject:estate];
            }
            
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getATask:(NSString *)taskId isPublic:(BOOL)isPublic onComplete:(void (^)(NSString *errorMsg,RepairVO *repair))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_task_detail",API_HOST];
    NSDictionary *params = nil;
    if (isPublic) {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"id":taskId,
                   @"owner_public":@"p"};
    }else
    {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"id":taskId,
                   @"owner_public":@"o"};
    }
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            RepairVO *repair = [[RepairVO alloc]initWithJSON:responseObject[@"datas"]];
            
            [self getEstates:^(NSString *errorMsg, NSArray *list) {
                repair.estate = @"";
                if (errorMsg == nil) {
                    for (EstateVO *estate in list) {
                        if ([estate.estate_id isEqualToString:repair.estate_id]) {
                            repair.estate_name = estate.estate_name;
                            repair.estate = estate.estate_name;
                            break;
                        }
                    }
                }
                onComplete(nil,repair);
            }];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)takeTask:(NSString *)taskId isPublic:(BOOL)isPublic onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@take_task",API_HOST];
    NSDictionary *params = nil;
    if (isPublic) {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"id":taskId,
                   @"owner_public":@"p"};
    }else
    {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"id":taskId,
                   @"owner_public":@"o"};
    }
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)endTask:(NSString *)taskId isPublic:(BOOL)isPublic onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@end_task",API_HOST];
    NSDictionary *params = nil;
    if (isPublic) {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"id":taskId,
                   @"owner_public":@"p"};
    }else
    {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"id":taskId,
                   @"owner_public":@"o"};
    }
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)sendMsg:(NSString *)friendId msg:(NSString *)msg onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@send_msg",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"friend_id":friendId,
                             @"the_msg":msg};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            [self palySend];
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)getMsgs:(NSString *)friendId endId:(NSString *)endId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_my_msg",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"friend_id":friendId,
                             @"end_id":endId};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* msgList = [[NSMutableArray alloc]init];
            for (NSDictionary* msgDic in responseObject[@"datas"][@"msg"]) {
                MsgVO *msgs = [[MsgVO alloc]initWithJSON:msgDic];
                [msgList addObject:msgs];
            }
            onComplete(nil,msgList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)sendCode:(NSString *)name phoneNum:(NSString *)phoneNum onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_password_forgotten_sms_code",API_HOST];
    NSDictionary *params = @{@"login_name":name,
                             @"cellphone":phoneNum};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)setNewPassword:(NSString *)name phoneNum:(NSString *)phoneNum code:(NSString *)code newPassword:(NSString *)newPassword onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@set_new_password",API_HOST];
    NSDictionary *params = @{@"login_name":name,
                             @"cellphone":phoneNum,
                             @"sms_code":code,
                             @"new_password":newPassword};
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

-(void)getStaffRepairStatistics:(NSString *)estateId onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@staff_repair_statistics",API_HOST];
    NSDictionary *params = @{};
    if (estateId.length > 0) {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord,
                   @"estate_id":estateId};
    }else
    {
        params = @{@"login_name":_userName,
                   @"login_password":_passWord};
    }
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            if ([responseObject[@"datas"][@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary* statisticDic in responseObject[@"datas"][@"data"]) {
                    StaffRepairStatisticVO* statistice = [[StaffRepairStatisticVO alloc]initWithJSON:statisticDic];
                    [listArr addObject:statistice];
                }
            }
            onComplete(nil,listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

#pragma mark 环境参数判定函数
-(BOOL)isLogin{
    UserVO *user = [[UDManager getUD] getUser];
    return user != nil;
}

#pragma mark 测试用函数
-(void)test
{
    if ([self isLogin]) {

    }else
    {
//        [self login:@"fzq" password:@"123456" savePassWord:NO onComplete:^(NSString *errorMsg, UserVO *user) {
//            if (errorMsg == nil) {
//                [self test];
//            }
//        }];
    }
}
@end
