//
//  ServicesManager.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ServicesManager.h"

@interface ServicesManager ()
{
    NSString* _userName;
    NSString* _passWord;
}

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

-(instancetype)init
{
    if (self = [super init]) {
        if ([self isLogin]) {
            _userName = [[UDManager getUD] getUserName];
            _passWord = [[UDManager getUD] getPassWord];
        }
    }
    return self;
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

#pragma mark 公共函数
-(void)login:(NSString *)userName
    password:(NSString *)password
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UDManager getUD] saveUserName:userName];
                [[UDManager getUD] saveUserPassWord:password];
                [[UDManager getUD] saveUser:user];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UDManager getUD] saveUser:user];
            });
            onComplete(nil,user);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)editUserInfo:(NSString *)phoneNum
          carNumber:(NSString *)carNumber
        newUserName:(NSString *)newUserName
        newPassWord:(NSString *)newPassWord
         onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@edit_my_info",API_HOST];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"login_name"] = _userName;
    params[@"login_password"] = _passWord;
    
    if (carNumber.length > 0) {
        if (![carNumber isEqualToString:[[UDManager getUD] getUser].car_number]) {
            params[@"car_number"] = carNumber;
        }
    }
    
    if (newUserName.length > 0) {
        if (![newUserName isEqualToString:_userName]) {
            params[@"new_login_name"] = newUserName;
        }
    }

    if (newPassWord.length > 0) {
        if (![newPassWord isEqualToString:_passWord]) {
            params[@"new_login_password"] = newPassWord;
        }
    }
    
    if (params.count == 0 && [phoneNum isEqualToString:[[UDManager getUD] getUser].cellphone]) {
        onComplete(@"nil");
        return;
    }else
    {
        if (phoneNum.length == 0) {
            onComplete(@"手机号为必填");
            return;
        }
        params[@"cellphone"] = phoneNum;
    }
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            if (newUserName.length > 0) {
                _userName = newUserName;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UDManager getUD] saveUserName:newUserName];
                });
            }
            
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
    NSData *data = UIImagePNGRepresentation(newImage);
    
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
        
        [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
        
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

-(void)getUserPoints:(void (^)(NSString *errorMsg,NSString *point))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@points",API_HOST];
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
            onComplete(nil,responseObject[@"datas"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getUserPointsHistory:(int)pageNum onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@points_history",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord,
                             @"page":[NSString stringWithFormat:@"%d",pageNum]};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            NSMutableArray* listArr = [[NSMutableArray alloc]init];
            for (NSDictionary* historyDic in responseObject[@"datas"][@"datas"]) {
                PointHistoryVO *history = [[PointHistoryVO alloc]initWithJSON:historyDic];
                [listArr addObject:history];
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

-(void)getErrorMessage:(NSString *)code
            onComplete:(void (^)(NSString *errorMsg))onComplete
{
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

#pragma mark 测试用函数
-(void)test
{
    if (self.isLogin) {

        UserVO* user = [[UDManager getUD] getUser];
        [My_ServicesManager getUserPointsHistory:1 onComplete:^(NSString *errorMsg, NSArray *list) {
            
        }];
    }else
    {
        [My_ServicesManager login:@"233911" password:@"12345678" onComplete:^(NSString *errorMsg, UserVO *user) {
            
        }];
    }
    
}
@end
