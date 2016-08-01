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

-(void)logOut:(void (^)())onComplete
{
    [[UDManager getUD] removeUDUser];
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
            for (NSDictionary* ipDic in responseObject[@"datas"]) {
                IPAllowVO* ip = [[IPAllowVO alloc]initWithJSON:ipDic];
                [listArr addObject:ip];
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
            for (NSDictionary* userDic in responseObject[@"datas"]) {
                UserVO* user = [[UserVO alloc]initWithJSON:userDic];
                [listArr addObject:user];
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
            for (NSDictionary* userDic in responseObject[@"datas"]) {
                UserVO* user = [[UserVO alloc]initWithJSON:userDic];
                [listArr addObject:user];
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
            for (NSDictionary* noticDic in responseObject[@"datas"][@"datas"]) {
                NoticVO* notic = [[NoticVO alloc]initWithJSON:noticDic];
                [listArr addObject:notic];
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
            for (NSDictionary* adDic in responseObject[@"datas"][@"datas"]) {
                AdVO* ad = [[AdVO alloc]initWithJSON:adDic];
                [listArr addObject:ad];
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

#pragma mark 环境参数判定函数
-(BOOL)isLogin{
    UserVO *user = [[UDManager getUD] getUser];
    return user != nil;
}

#pragma mark 测试用函数
-(void)test
{
    if ([self isLogin]) {
        UserVO *user = [[UDManager getUD] getUser];
        NSLog(@"admin_id:%@",user.admin_id);
        [self getNotice:0 onComplete:^(NSString *errorMsg, NSArray *list) {
            
        }];
    }else
    {
        [self login:@"gyg" password:@"123456" onComplete:^(NSString *errorMsg, UserVO *user) {
            [self test];
        }];
    }
}
@end
